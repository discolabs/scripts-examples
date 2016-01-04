class InterleavedPartitioner
  def initialize(paid_item_count, discounted_item_count)
    @paid_item_count = paid_item_count
    @discounted_item_count = discounted_item_count
  end

  def partition(cart, line_items)
    sorted_items = line_items.sort_by{|line_item| line_item.variant.price}.reverse
    discounted_items = []
    total_items_seen = 0
    discounted_items_seen = 0

    sorted_items.each do |line_item|
      total_items_seen += line_item.quantity
      count = discounted_items_to_find(total_items_seen, discounted_items_seen)
      next if count <= 0

      if count >= line_item.quantity
        discounted_items.push(line_item)
        discounted_items_seen += line_item.quantity
      else
        discounted_item = line_item.split(take: count)
        position = cart.line_items.find_index(line_item)
        cart.line_items.insert(position + 1, discounted_item)
        discounted_items.push(discounted_item)
        discounted_items_seen += discounted_item.quantity
      end
    end
    discounted_items
  end

  private

  def discounted_items_to_find(total_items_seen, discounted_items_seen)
    Integer(total_items_seen / (@paid_item_count + @discounted_item_count) * @discounted_item_count) - discounted_items_seen
  end
end
