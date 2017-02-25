class Author < ActiveRecord::Base
  has_many :authorships
  has_many :publications, through: :authorships
  has_many :journals, through: :publications

  scope :middle_initial_consistent, ->(mi){ where("middle_initial ~* ?", "^" + mi.to_s + ".*") }
  scope :having_five_pubs, -> { joins(:authorships).group("authors.id").having("COUNT(authorships.id) > 5") }
  scope :published_in, -> (journal) { joins(:journals).where("journals.id": journal.id) }
  scope :with_name, -> (name) { where(first_name: parse_name(name)[0], middle_initial: parse_name(name)[1], last_name: parse_name(name)[2])}

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

  def self.from_name(name)
    Author.with_name(name).first || 
      Author.create(first_name: parse_name(name)[0], middle_initial: parse_name(name)[1], last_name: parse_name(name)[2])
  end

  def active_range
    [
      publications.pluck(:publication_year).min,
      publications.pluck(:publication_year).max
    ]
  end

  def unity_rating
    pairs = journals.distinct.to_a.combination(2)
    return 0 if pairs.count == 0
    (pairs.sum {|a,b| a.co_publication_percentage(b)} / pairs.count).round(2)
  end

  private
  
  def self.parse_name(name)
    names = name.split(" ")
    last_name = names.pop
    first_name = names.shift
    middle_initial = names.join(" ")
    [first_name, middle_initial, last_name]
  end
end
