class CrossRefDispatcher
  attr_reader :response, :authors

  def initialize(query)
    @authors = query.authors
    @response = []
    # @category = query.category
  end

  def dispatch
    @authors.each do |author|
      dispatch_query_for author
    end
  end

  def dispatch_query_for(author)
    url = ""
    return_message = Faraday.new(url).get(query_string_for author)
    response = parse(return_message)
    @response += response
  end

  def query_string_for(author)
    url_prefix = "http://api.crossref.org/works?"
    url_suffix = "&rows=1000"
    url_prefix + author_param_string_for(author) + url_suffix
  end

  def author_param_string_for(author)
    # authors.map { |author| "query.author=" + author.split(" ").join("+") }.join("&")
    "query.author=#{author.split(" ").join("+")}"
  end

  def parse(response)
    data_object = JSON.parse(response.body)
    publications = data_object["message"]["items"].collect { |item| convert_to_pub(item) }.compact
    publications
  end

  def convert_to_pub(item)
    return unless item["author"]
    author = item["author"].collect{ |a| "#{a["given"]} #{a["family"]}" }
    journal = item["container-title"]
    title = item["title"]
    Publication.new(title: title, author: author, journal: journal)
  end
end