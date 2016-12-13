class Filterer
  attr_reader :query, :publications, :filtered_list

  def initialize(query:, publications:)
    @query = query
    @publications = publications
  end

  def filter
    @filtered_list = publications.select do |pub|
      query.authors.any? { |author| pub.author? author } &&
      pub.journals.any? { |journal| Journal.exists? {|j| j.name == journal && j.send{"#{category}"}} }
    end
  end

  private

  def category
    query.category
  end
end