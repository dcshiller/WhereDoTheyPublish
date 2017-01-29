class Query
  attr_reader :journal, :year, :authors, :category
  attr_accessor :message

  def initialize(authors, category, journal, year, request_number = nil)
    @authors = authors
    @journal = journal
    @year = year
    @category = category
  end
end
