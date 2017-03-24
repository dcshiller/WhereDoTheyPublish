class CategoryShiftJob
  @queue = :queue
  def perform(categorizable_type, categorizable_ids, from_cat, to_cat)
    categorizables = categorizable_type.constantize.find(categorizable_ids)
    categorizables.each do |cato|
      CategoryReconciler.shift(cato, from_cat, to_cat)
    end
  end
end