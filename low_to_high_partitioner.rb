class LowToHighPartitioner
  def initialize(paid_item_count, discounted_item_count)
    @paid_item_count = paid_item_count
    @discounted_item_count = discounted_item_count
  end

  def partition(cart, applicable_line_items)
    sorted_items = applicable_line_items.sort_by{|line_item| line_item.variant.price}

    total_applicable_quantity = sorted_items.map(&:quantity).reduce(0, :+)
    discounted_items_remaining = Integer(total_applicable_quantity / (@paid_item_count + @discounted_item_count) * @discounted_item_count)

    discounted_items = []
    sorted_items.each do |line_item|
      break if discounted_items_remaining == 0
      discounted_item = line_item
      if line_item.quantity > discounted_items_remaining
        discounted_item = line_item.split(take: discounted_items_remaining)
        position = cart.line_items.find_index(line_item)
        cart.line_items.insert(position + 1, discounted_item)
      end

      discounted_items_remaining -= discounted_item.quantity
      discounted_items.push(discounted_item)
    end
    discounted_items
  end
end
