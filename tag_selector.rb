class TagSelector
  def initialize(tag)
    @tag = tag
  end

  def match?(line_item)
    line_item.variant.product.tags.include?(@tag)
  end
end
