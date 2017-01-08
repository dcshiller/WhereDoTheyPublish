class JournalRanking
  attr_reader :ranking

  def initialize
    @ranking = Hash.new(0)
  end

  def include(publication)
    ranking[publication.journal.name] += 1
  end

  def sort
    ranking = @ranking.to_a.sort {|a,b| b[1] <=> a[1] }
    ranking.map { |journal_count| { Title: journal_count[0], Count: journal_count[1] } }
  end
end
