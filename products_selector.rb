# ProductsSelector
# ================
#
# The `ProductsSelector` selects items by their product ID.
#
# Example
# -------
#   * Items where the product ID is either 100, 200 or 301
#
class ProductsSelector

  # Initializes the selector.
  #
  # Arguments
  # ---------
  #
  #  * product_ids
  #    An array containing the accepted product IDs.
  def initialize(product_ids)
    @product_ids = Array(product_ids)
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
  # Given `ProductsSelector.new(15, 20, 25)` and
  # a line_item with a product with ID = 15
  #
  #    selector.match?(line_item) # returns true
  #
  def match?(line_item)
    @product_ids.include?(line_item.variant.product.id)
  end
end
