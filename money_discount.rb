# MoneyDiscount
# =============
#
# The `MoneyDiscount` gives flat amount discounts.
#
# Example
# -------
#   * $5 off
#
class MoneyDiscount

  # Initializes the discount.
  #
  # Arguments
  # ---------
  #
  # * cents
  #   The discount amount (in cents).
  #
  # * message
  #   The message to show for the discount.
  #
  def initialize(cents, message)
    @amount = Money.new(cents: cents)
    @message = message
  end

  # Applies the discount on a line item.
  #
  # Arguments
  # ---------
  #
  # * line_item
  #   The item to which the discount will be applied.
  #
  # Example
  # -------
  # Given `MoneyDiscount.new(5_00, "Great discount")` and the following line item:
  #
  #   * Quantity = 2, Price = 10
  #
  # The discount will give $5 off per quantity, for a total of 10$ off.
  #
  def apply(line_item)
    # Calculate the total discount for this line item
    line_discount = @amount * line_item.quantity

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
