class AuthorMatcher
  attr_reader :author

  def initialize(author)
    @author = author
  end

  def match?
    match_score > 1
  end

  def match_score(other_author)
    info_value(other_author).to_f/20
  end

  # private

  def info_value(other_author)
    value = 0
    value += name_info_value
    value += publication_info_value(other_author)
    value += publication_match_value(other_author)
    value
  end

  def name_info_value
    value = 0
    %w(first_name middle_initial last_name).each do |name|
      value += 2 if author.send(name)
      value += 5 if author.send(name) && author.send(name).length > 2
      value += 2 if author.send(name) && author.send(name).length > 8
    end
    value -= 10 if author.last_name && author.last_name.length < 2
    value += 5 if Author.where(last_name: author.last_name).count < 3
    value += 2 if Author.where(last_name: author.last_name).count < 10
    value
  end

  def publication_info_value(other_author)
    value = 0
    value += 3 if author.journals.count > 3 && other_author.journals.count > 3
    value
  end

  def publication_match_value(other_author)
    value = 0.0
    value -= 35 unless other_author.publications.where("publication_year < ? OR publication_year > ?", plausible_publication_range[0], plausible_publication_range[1]).blank?
    author.journals.limit(10).uniq.to_a.product(other_author.journals.limit(10)).each do |a,x|
      value += 0.5 if (Affinity.for(a,x)&.affinity || 0) > 20
      value += 0.5 if (Affinity.for(a,x)&.affinity || 0) > 10
      value -= 0.3 if (Affinity.for(a,x)&.affinity || 1) < 3
    end
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
    Author.distinct.
           where("middle_initial ~* ?", "^" + author.middle_initial.chomp(".") + ".*").
           where("first_name ~* ?", "^" + author.first_name.chomp(".") + ".*").
           where("last_name ~* ?", "^" + author.last_name + ".*").
           joins(:publications).
           merge(Publication.published_between(plausible_publication_range))
  end
end