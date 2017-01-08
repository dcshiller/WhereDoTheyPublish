class CrossRefDispatcher
  attr_reader :response, :authors, :query

  def initialize(query)
    @authors = query.authors
    @response = []
    @query = query
    # @category = query.category
  end

  def dispatch
    @authors.each do |author|
      dispatch_query_for author
    end
  end

  def dispatch_query_for(author, offset = 0)
    url = ""
    query.update_status("#{author} submitted.")
    return_message = Faraday.new(url).get(query_string_for author, offset)
    response = parse(return_message)
    query.update_status("#{author} results received.")
    @response += response
  end

  def query_string_for(author, offset)
    url_prefix = "http://api.crossref.org/works?"
    url_suffix = "&rows=1000&offset=#{offset*1000}&filter=type:journal-article"
    url_prefix + author_param_string_for(author) + url_suffix
  end

  def author_param_string_for(author)
    # authors.map { |author| "query.author=" + author.split(" ").join("+") }.join("&")
    "query.author=+#{author.split(" ").join("+")}"
  end

  def parse(response)
    data_object = JSON.parse(response.body)
    publications = data_object["message"]["items"].collect { |item| convert_to_pub(item) }.compact
    publications
  end

  def convert_to_pub(item)
    return unless item["author"]
    authors = item["author"].collect do |a|
      first_name = a["given"].to_s.split(" ").first&.titlecase
      first_name += "." if first_name&.length == 1
      middle_initial = a["given"].to_s.split(" ")[1..-1]&.join(" ")&.titlecase
      middle_initial += "." if middle_initial&.length == 1
      last_name = a["family"]&.proper_titlecase
      Author.find_by(first_name: first_name, last_name: last_name) ||
        Author.new(first_name: first_name, middle_initial: middle_initial,last_name: last_name)
    end
    condensed_names = item["container-title"].map {|name| Journal.condensed_name(name.proper_titlecase)}
    journal = Journal.find_by(condensed_name: condensed_names) ||
              Journal.new(name: item["container-title"].longest.proper_titlecase)
    year = item.dig('issued', 'date-parts', 0, 0).to_i
    Publication.find_by(title: item["title"].map(&:proper_titlecase), journal: journal, publication_year: year) ||
      Publication.new(title: item["title"].longest, journal: journal, authors: authors,  publication_year: year)
  end
end
