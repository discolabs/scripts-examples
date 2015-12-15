# A class that knows how to calculate the discount for a line item, given a
# number representing the percentage to discount each unit of item by.
class PercentageDiscount
  def initialize(percent, message)
    # Calculate the percentage, while ensuring that Decimal values are used in
    # order to maintain precision.
    @percent = Decimal.new(percent) / 100.0
    @message = message
  end

  def apply(line_item)
    # Using the Discount instance, calculate the discount for this line item.
    line_discount = line_item.line_price * @percent

    # Calculated the discounted line price using the line discount.
    new_line_price = line_item.line_price - line_discount

    # Apply the new line price to this line item with a given message
    # describing the discount, which may be displayed in cart pages and
    # confirmation emails to describe the applied discount.
    line_item.change_line_price(new_line_price, message: @message)

    # Print a debugging line to the console.
    puts "Discounted line item with variant #{line_item.variant.id} by #{line_discount}."
  end
end
