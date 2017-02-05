class Author < ActiveRecord::Base
  has_many :authorships
  has_many :publications, through: :authorships
  has_many :journals, through: :publications

  scope :middle_initial_consistent, ->(mi){ where("middle_initial ~* ?", "^" + mi.to_s + ".*") }
  scope :name_consistent, -> (author) do
    where("middle_initial ~* ?", "^" + author.middle_initial.chomp(".") + ".*").
    where("first_name ~* ?", "^" + author.first_name.chomp(".") + ".*").
    where("last_name ~* ?", "^" + author.last_name + ".*")
  end
  scope :publication_consistent, -> (author) do
    joins(:publications).
    merge(Publication.published_between(author.plausible_publication_range))
  end
  scope :having_five_pubs, -> { joins(:authorships).group("authors.id").having("COUNT(authorships.id) > 5") }
  scope :published_in, -> (journal) { joins(:journals).where("journals.id": journal.id) }

  def name?(name_to_match)
    (first_name .sp last_name) == (name_to_match.split(" ")[0] .sp name_to_match.split(" ")[1]) ||
      (first_name .sp middle_initial .sp last_name == name_to_match)
  end

  def name
    first_name .sp middle_initial .sp last_name
  end

  def merge_into(other_author)
    return unless self != other_author
    authorships.update_all(author_id: other_author.id)
    destroy
  end

  def active_range
    [
      publications.pluck(:publication_year).min,
      publications.pluck(:publication_year).max
    ]
  end

  def plausible_publication_range
    diff = [(15 + active_range[0] - active_range[1]), 0].max
    [
      active_range[0] - 5 - diff,
      active_range[1] + 5 + diff,
    ]
  end

  def publication_consistent?(other_author)
    Author.publication_consistent(self).where(id: other_author).any?
  end

  def plausible_duplicates
    Author.name_consistent(self).publication_consistent(self)
  end
end
