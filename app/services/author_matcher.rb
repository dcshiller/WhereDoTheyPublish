class AuthorMatcher
  attr_reader :author

  def initialize(author)
    @author = author
  end

  def match_likelihood(other_author)
    
  end

  private

  def info_value(other_author)
    value = 0
    %(first_name middle_initial last_name).each do |name|
      value += 1 if author.send(name)
      value += 1 if author.send(name) && author.send(name).count > 2
      value += 1 if author.send(name) && author.send(name).count > 8
    end
    value -= 5 if last_name && last_name.count < 2
    value += 2 if Author.where(last_name: last_name).count < 3
    value += 4 if author.publications.count > 3 && other_author.publications.count > 3
    value += 3 if author.journals.count > 3 && other_author.journals.count > 3
    value
  end

  def plausible_publication_range
    diff = [(15 + author.active_range[0] - author.active_range[1]), 0].max
    [
      author.active_range[0] - 5 - diff,
      author.active_range[1] + 5 + diff,
    ]
  end

  def plausible_duplicates
    Author.where("middle_initial ~* ?", "^" + author.middle_initial.chomp(".") + ".*").
           where("first_name ~* ?", "^" + author.first_name.chomp(".") + ".*").
           where("last_name ~* ?", "^" + author.last_name + ".*")
           joins(:publications).
           merge(Publication.published_between(author.plausible_publication_range))
  end
end