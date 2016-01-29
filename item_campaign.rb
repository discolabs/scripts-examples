# ItemCampaign
# ============
#
# Example campaigns
# -----------------
#   * All items are 15% off
#   * Items with the "sale" tag are 5$ off
#   * Items that cost less than 10$ are 10% off
#
class ItemCampaign

  # Initializes the campaign.
  #
  # Arguments
  # ---------
  # * selector
  #   The selector finds eligible items for the campaign.
  #
  # * discount
  #   The discount changes the price of the items returned by the partitioner.
  #
  def initialize(selector, discount)
    @selector = selector
    @discount = discount
  end

  # Runs the campaign on the given cart.
  #
  # Arguments
  # ---------
  # * cart
  #   The cart to which the campaign is applied.
  #
  # Example
  # -------
  # To run the campaign on the input cart:
  #
  #    campaign.run(Input.cart)
  #
  def run(cart)
    # Iterate through the line items in the cart.
    cart.line_items.each do |line_item|
      # Skip this line item unless it's associated with the target product.
      next unless @selector.match?(line_item)

      @discount.apply(line_item)
    end
  end
end
