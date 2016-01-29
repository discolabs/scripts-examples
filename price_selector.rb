# PriceSelector
# =============
#
# The `PriceSelector` selects items by price.
#
# Example
# -------
#   * Items with a price lower than $5
#   * Items with a price higher than $10
#
class PriceSelector

  # Initializes the selector.
  #
  # Arguments
  # ---------
  #
  # * condition
  #   The condition to use when conparing the prices.
  #   Available options are `:greater_than` and `:lower_than`.
  #
  # * price
  #   The price to use for comparison.
  def initialize(condition, price)
    @price = price
    @condition = condition
  end

  # Returns whether a line item matches this selector or not.
  #
  # Arguments
  # ---------
  #
  # * line_item
  #   The item to check for matching.
  #
  # Example
  # -------
  # Given `PriceSelector.new(:greater_than, Money.new(cents: 5_00))` and
  # a line_item with a price of 10$:
  #
  #    selector.match?(line_item) # returns true
  #
  def match?(line_item)
    case @condition
    when :greater_than
      line_item.variant.price > @price
    when :lower_than
      line_item.variant.price < @price
    end
  end
end
