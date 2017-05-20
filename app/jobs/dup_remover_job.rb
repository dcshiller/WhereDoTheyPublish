class DupRemoverJob
  @queue = :queue
  include Categories

  def self.perform(journal_id)
    JournalCleaner.remove_dups!(Journal.find(journal_id))
  end
end