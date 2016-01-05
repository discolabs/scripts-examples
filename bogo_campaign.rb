# BogoCampaign
# ============
#
# Examples campaigns
# ------------------
#   * Buy one, the 2nd item is free
#   * Buy one, the 2nd item is 50% off
#   * Buy two, the 3rd item is 5$ off
#
class BogoCampaign

  # Initializes the campaign
  #
  # Arguments
  # ---------
  #
  # * selector
  #   The selector is used to find eligible items for this campaign.
  #
  # * discount
  #   The discount will change the price of the items returned by the partitioner
  #
  # * partitioner
  #   The partitioner takes all applicable items, and returns only those that
  #   are to be discounted. In a "Buy two, the 3rd item is free" campaign,
  #   the partitioner would skip 2 items and return the 3rd item.
  #
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
