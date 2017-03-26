class JournalCategorizerJob
    @queue = :queue

  def self.perform(journal_ids, average)
    Journal.find(journal_ids).each do |journal|
      CategoryReconciler.reconcile_pubs_with_journal(journal, average)
    end

    Journal.find(journal_ids).each do |journal|
      CategoryReconciler.reconcile_journal_with_pubs(journal, average)
    end
  end
end