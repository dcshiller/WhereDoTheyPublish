class CategorizerQueuer
  def self.queue_journals
    average = CategoryReconciler.get_average_hash(Publication.order("RANDOM()").limit(10000))

    Journal.pluck(:id).each do |j_id|
      Resque.enqueue(JournalCategorizerJob, [j_id], average)
    end
  end

  def self.queue_authors
    average = CategoryReconciler.get_average_hash(Publication.order("RANDOM()").limit(10000))

    Journal.pluck(:id).each_slice(100) do |a_ids|
      Resque.enqueue(JournalCategorizerJob, a_ids, average)
    end
  end
end