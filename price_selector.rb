class PriceSelector
  def initialize(condition, price)
    @price = price
    @condition = condition
  end

  def match?(line_item)
    case @condition
    when :greater_than
      line_item.variant.price > @price
    when :lower_than
      line_item.variant.price < @price
    end
  end
end
