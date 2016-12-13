class Publication
  attr_reader :journals

  def initialize(title: nil, titles: nil, author: nil, authors: nil, journal: nil, journals: nil)
    @titles = arrayify(title || titles)
    @authors = arrayify(author || authors)
    @journals = arrayify(journal || journals)
  end

  def title
    @titles[0]
  end

  def author
    @authors[0]
  end

  def journal
    @journals[0]
  end

  def title?(string_to_match)
    titles.include? string_to_match
  end

  def author?(string_to_match)
    authors.include? string_to_match
  end

  def journal?(string_to_match)
    journals.include? string_to_match
  end

  private
  attr_reader :titles, :authors

  def arrayify(obj)
    obj.is_a?(Array) ? obj : [obj]
  end
end