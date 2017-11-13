class CategoryShaveJob
  @queue = :queue

  # CategoryShaveJob, Journal, "mt", 0.5) to shave half off mt in each journal.

  def self.perform(categorizable_type, from_cat, amount)
    categorizables = categorizable_type.constantize
    categorizables.find_each do |cato|
      CategoryReconciler.shave(cato, from_cat, amount)
    end
  end
end
