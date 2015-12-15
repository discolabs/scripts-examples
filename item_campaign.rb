class ItemCampaign
  def initialize(selector, discount)
    @selector = selector
    @discount = discount
  end

  def run(cart)
    # Iterate through the line items in the cart.
    cart.line_items.each do |line_item|
      # Skip this line item unless it's associated with the target product.
      next unless @selector.match?(line_item)

      @discount.apply(line_item)
    end
  end
end
