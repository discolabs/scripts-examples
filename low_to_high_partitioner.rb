# LowToHighPartitioner
# ====================
#
# The `LowToHighPartitioner` is used by campaigns for which not all items
# are discounted, such as `BogoCampaign`. It tries to discount items so that
# the cheaper items are prioritized for discounting.
#
# Example
# -------
# Given `LowToHighPartitioner.new(2,1)` and a cart containing the following
# line items:
#
#   * (A) Quantity = 2, Price = 5
#   * (B) Quantity = 3, Price = 10
#
# The partitioner will:
#
#   * Sort them by ascending price (A, B)
#   * Count the total items to be discounted (1)
#   * Take 1 of A to be discounted
#
# The items to be discounted will be (before discount):
#
#   * (A) Quantity = 1, Price = 5
#
class LowToHighPartitioner

  # Initializes the partitioner.
  #
  # Arguments
  # ---------
  #
  # * paid_item_count
  #   The number of items to skip before selecting items to discount.
  #
  # * discounted_item_count
  #   The number of items to return for discounting.
  #
  # Example
  # -------
  # To create a campaign such as "Buy two, the 3rd item is discounted"
  #
  #    LowToHighPartitioner.new(2,1)
  #
  def initialize(paid_item_count, discounted_item_count)
    @paid_item_count = paid_item_count
    @discounted_item_count = discounted_item_count
  end

  # Partitions the items and returns the items that are to be discounted.
  #
  # Arguments
  # ---------
  #
  # * cart
  #   The cart to which split items will be added (typically Input.cart).
  #
  # * line_items
  #   The selected items that are applicable for the campaign.
  #
  # Example
  # -------
  #
  # To create a campaign such that for all items under $5, the 3rd one is discounted:
  #
  #    selected_items = Input.cart.line_items.select{|item| item.variant.price < Money.new(cents: 5_00)}
  #    partitioner = LowToHighPartitioner.new(2,1)
  #    items_to_discount = partitioner.partition(Input.cart, selected_items)
  #
  # After this, the campaign has to apply discounts to `items_to_discount`.
  #
  def partition(cart, applicable_line_items)
    # Sort the items by price from low to high
    sorted_items = applicable_line_items.sort_by{|line_item| line_item.variant.price}
    # Find the total quantity of items
    total_applicable_quantity = sorted_items.map(&:quantity).reduce(0, :+)
    # Find the quantity of items that must be discounted
    discounted_items_remaining = Integer(total_applicable_quantity / (@paid_item_count + @discounted_item_count) * @discounted_item_count)
    # Create an array of items to return
    discounted_items = []

    # Loop over all the items and find those to be discounted
    sorted_items.each do |line_item|
      # Exit the loop if all discounted items have been found
      break if discounted_items_remaining == 0
      # The item will be discounted
      discounted_item = line_item
      if line_item.quantity > discounted_items_remaining
        # If the item has more quantity than what must be discounted, split it
        discounted_item = line_item.split(take: discounted_items_remaining)

        # Insert the newly-created item in the cart, right after the original item
        position = cart.line_items.find_index(line_item)
        cart.line_items.insert(position + 1, discounted_item)
      end

      # Decrement the items left to be discounted
      discounted_items_remaining -= discounted_item.quantity
      # Add the item to be returned
      discounted_items.push(discounted_item)
    end

    # Return the items to be discounted
    discounted_items
  end
end
