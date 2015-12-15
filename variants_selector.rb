class VariantsSelector
  def intialize(variant_ids)
    @variant_ids = Array(variant_ids)
  end

  def match?(line_item)
    @variant_ids.include?(line_item.variant.id)
  end
end
