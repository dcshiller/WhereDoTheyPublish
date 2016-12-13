class Counter
  attr_reader :journal_list, :ranked_journals
  def initialize(journal_list)
    @journal_list = journal_list
  end

  def count
    ranking = JournalRanking.new
    journal_list.each { |journal| ranking.include(journal) }
    @ranked_journals = ranking.sort
  end
end
