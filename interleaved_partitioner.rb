# InterleavedPartitioner
# ======================
#
# The `InterleavedPartitioner` is used by campaigns for which not all items
# are discounted, such as `BogoCampaign`. It tries to discount items so that
# the customer sees it as being the best deal for them.
#
# Example
# -------
# Given `InterleavedPartitioner.new(2,1)` and a cart containing the following
# line items:
#
#   * (A) Quantity = 2, Price = 5
#   * (B) Quantity = 3, Price = 10
#
# The partitioner will:
#
#   * Sort them by descending price (B, A)
#   * Skip 2 of B, then take one of B
#   * Skip 2 of A, and nothing is left to be discounted for A
#
# The items to be discounted will be (before discount):
#
#   * (B) Quantity = 1, Price = 10
#
class InterleavedPartitioner

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
  # To create a campaign such as "Buy two, the 3rd item is discounted":
  #
  #    InterleavedPartitioner.new(2,1)
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
  # To create a campaign such that for all items under $5, the 3rd one is discounted:
  #
  #    selected_items = Input.cart.line_items.select{|item| item.variant.price < Money.new(cents: 5_00)}
  #    partitioner = InterleavedPartitioner.new(2,1)
  #    items_to_discount = partitioner.partition(Input.cart, selected_items)
  #
  # After this, the campaign has to apply discounts to `items_to_discount`.
  #
  def partition(cart, line_items)
    # Sort the items by price from high to low
    sorted_items = line_items.sort_by{|line_item| line_item.variant.price}.reverse
    # Create an array of items to return
    discounted_items = []
    # Keep counters of items seen and discounted, to avoid having to recalculate on each iteration
    total_items_seen = 0
    discounted_items_seen = 0

    # Loop over all the items and find those to be discounted
    sorted_items.each do |line_item|
      total_items_seen += line_item.quantity
      # After incrementing total_items_seen, see if any items must be discounted
      count = discounted_items_to_find(total_items_seen, discounted_items_seen)
      # If there are none, skip to the next item
      next if count <= 0

      if count >= line_item.quantity
        # If the full item quantity must be discounted, add it to the items to return
        # and increment the count of discounted items
        discounted_items.push(line_item)
        discounted_items_seen += line_item.quantity
      else
        # If only part of the item must be discounted, split the item
        discounted_item = line_item.split(take: count)
        # Insert the newly-created item in the cart, right after the original item
        position = cart.line_items.find_index(line_item)
        cart.line_items.insert(position + 1, discounted_item)
        # Add it to the list of items to return
        discounted_items.push(discounted_item)
        discounted_items_seen += discounted_item.quantity
      end
    end

    # Return the items to be discounted
    discounted_items
  end

  private

  # Returns the integer amount of items that must be discounted next
  # given the amount of items seen
  #
  def discounted_items_to_find(total_items_seen, discounted_items_seen)
    Integer(total_items_seen / (@paid_item_count + @discounted_item_count) * @discounted_item_count) - discounted_items_seen
  end
end
