# TagSelector
# ============
#
# The `TagSelector` selects items by tag.
#
# Example
# -------
#   * Items where the variant has "sale" tag
#
class TagSelector

  # Initializes the selector.
  #
  # Arguments
  # ---------
  #
  #  * tag
  #    The tag that the selector will look for in the item.
  def initialize(tag)
    @tag = tag
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
  # Given `TagSelector.new("sale")` and
  # a line_item with a variant with tags = ["sale", "boat", "hat"]
  #
  #    selector.match?(line_item) # returns true
  #
  def match?(line_item)
    line_item.variant.product.tags.include?(@tag)
  end
end
