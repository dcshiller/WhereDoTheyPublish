class DupRemoverJob
  @queue = :queue
  include Categories

  def self.perform(journal_id)
    jc = JournalCleaner.new(Journal.find(journal_id))
    jc.remove_dups!
    jc.merge_partial_dups!
  end
end