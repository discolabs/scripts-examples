# VariantsSelector
# ================
#
# The `VariantsSelector` selects items by their variant ID.
#
# Example
# -------
#   * Items where the variant ID is either 100, 200 or 301
#
class VariantsSelector

  # Initializes the selector.
  #
  # Arguments
  # ---------
  #
  #  * variant_ids
  #    An array containing the accepted variant IDs.
  def initialize(variant_ids)
    @variant_ids = Array(variant_ids)
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
  # Given `VariantsSelector.new(15, 20, 25)` and
  # a line_item with a variant with ID = 15
  #
  #    selector.match?(line_item) # returns true
  #
  def match?(line_item)
    @variant_ids.include?(line_item.variant.id)
  end
end
