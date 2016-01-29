# BogoCampaign
# ============
#
# Example campaigns
# -----------------
#
#   * Buy one, get one free
#   * Buy one, get one 50% off
#   * Buy two items and get a third for $5 off
#
class BogoCampaign

  # Initializes the campaign.
  #
  # Arguments
  # ---------
  #
  # * selector
  #   The selector finds eligible items for this campaign.
  #
  # * discount
  #   The discount changes the prices of the items returned by the partitioner.
  #
  # * partitioner
  #   The partitioner takes all applicable items, and returns only those that
  #   are to be discounted. In a "Buy two items, get the third for free"
  #   campaign, the partitioner would skip two items and return the third item.
  #
  def initialize(selector, discount, partitioner)
    @selector = selector
    @discount = discount
    @partitioner = partitioner
  end

  # Runs the campaign on the given cart.
  #
  # Arguments
  # ---------
  #
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
    applicable_items = cart.line_items.select do |line_item|
      @selector.match?(line_item)
    end
    discounted_items = @partitioner.partition(cart, applicable_items)

    discounted_items.each do |line_item|
      @discount.apply(line_item)
    end
  end
end
