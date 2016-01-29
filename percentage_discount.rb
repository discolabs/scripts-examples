# PercentageDiscount
# ==================
#
# The `PercentageDiscount` gives percentage discounts to item prices.
#
# Example
# -------
#   * 15% off
#
class PercentageDiscount

  # Initializes the discount.
  #
  # Arguments
  # ---------
  #
  # * percent
  #   The percentage by which the item will be discounted.
  #
  # * message
  #   The message to show for the discount.
  #
  def initialize(percent, message)
    # Calculate the percentage, while ensuring that Decimal values are used in
    # order to maintain precision.
    @percent = Decimal.new(percent) / 100.0
    @message = message
  end

  # Applies the discount on a line item.
  #
  # Arguments
  # ---------
  #
  # * line_item
  #   The item on which the discount will be applied.
  #
  # Example
  # -------
  # Given `PercentageDiscount.new(10, "Great discount")` and the following line item:
  #
  #   * Quantity = 2, Price = 10
  #
  # The discount will give $1 off per quantity, for a total of $2 off.
  #
  def apply(line_item)
    # Calculate the discount for this line item
    line_discount = line_item.line_price * @percent

    # Calculated the discounted line price
    new_line_price = line_item.line_price - line_discount

    # Apply the new line price to this line item with a given message
    # describing the discount, which may be displayed in cart pages and
    # confirmation emails to describe the applied discount.
    line_item.change_line_price(new_line_price, message: @message)

    # Print a debugging line to the console
    puts "Discounted line item with variant #{line_item.variant.id} by #{line_discount}."
  end
end
