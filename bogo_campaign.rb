class BogoCampaign
  def initialize(selector, discount, partitioner)
    @selector = selector
    @discount = discount
    @partitioner = partitioner
  end

  def run(cart)
    applicable_items = cart.line_items.select do |line_item|
      @selector.match?(line_item)
    end
    discounted_items = @partitioner.partition(cart, applicable_items)

    discounted_items.each do |line_item|
      @discount.apply(line_item)
    end
  end
end
