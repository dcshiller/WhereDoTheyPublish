class Publication
  attr_reader :journals, :authors

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
    authors_without_middle_initials = remove_middle_initials_from authors
    name_to_match = remove_middle_initials_from string_to_match
    authors_without_middle_initials.include? name_to_match
  end

  def journal?(string_to_match)
    journals.include? string_to_match
  end

  private
  attr_reader :titles

  def arrayify(obj)
    if obj.is_a? Array
      obj.compact
    elsif obj.nil?
      []
    else
      [obj]
    end
  end

  def remove_middle_initials_from(authors)
    if authors.is_a? Array
      authors.map do |author|
        remove_middle_initial_from author
      end
    elsif authors.is_a? String
      remove_middle_initial_from authors
    end
  end

  def remove_middle_initial_from(author)
    names = author.split(' ')
    return names[0] if names.length < 2
    names[0] .sp names[-1]
  end
end
