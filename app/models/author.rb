class Author < ActiveRecord::Base
  include Categorizable
  has_many :authorships
  has_many :publications, through: :authorships
  has_many :journals, through: :publications
  before_save :guess_gender


  scope :middle_initial_consistent, ->(mi){ where("middle_initial ~* ?", "^" + mi.to_s + ".*") }
  scope :having_five_pubs, -> { joins(:authorships).group("authors.id").having("COUNT(authorships.id) > 5") }
  scope :published_in, -> (journal) { joins(:journals).where("journals.id": journal.id) }
  scope :with_name, -> (name) { where(first_name: parse_name(name)[0], middle_initial: parse_name(name)[1], last_name: parse_name(name)[2])}
  scope :with_name_like, -> (name) {
                                      # where(first_name: [parse_name(name)[0], "", nil], middle_initial: [parse_name(name)[1], "", nil], last_name: [parse_name(name)[2], "", nil]).
                                      where("first_name LIKE ? 
                                            #{"AND middle_initial LIKE ?" if parse_name(name)[1]} 
                                             AND last_name LIKE ?", *(parse_name(name).map{|n| (n || "") + '%'}))
                                   }

  def self.find_or_create_by_name(name)
    name = parse_name(name)
    Author.find_or_create_by(first_name: name[0], middle_initial: name[1], last_name: name[2])
  end

  def name?(name_to_match)
    (first_name .sp last_name) == (name_to_match.split(" ")[0] .sp name_to_match.split(" ")[1]) ||
      (first_name .sp middle_initial .sp last_name == name_to_match)
  end

  def name
    first_name .sp middle_initial .sp last_name
  end

  def just_initials?
    not not
    (first_name&.strip || "").match(/(^$)|^(.|.\.)$/) &&
    (middle_initial&.strip || "").match(/(^$)|^(.|.\.)$/) &&
    (last_name&.strip || "").match(/(^$)|^(.|.\.)$/)
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

  def match(other_author)
    match_by(other_author, :first_name) &&
      match_by(other_author, :middle_initial) &&
      match_by(other_author, :last_name)
  end

  private

  def match_by(other_author, name_part)
   send(name_part).chomp(".").include?(other_author.send(name_part).chomp(".")) ||
     other_author.send(name_part).chomp(".").include?(send(name_part).chomp("."))
  end

  def guess_gender
    return if gender == 1 || gender == 0
    gender = Guess.gender(first_name)
    case gender[:gender]
    when "male"
      gender = gender[:confidence]
    when "female"
      gender = 1 - gender[:confidence]
    else
      gender = nil
    end
    self.gender = gender
  end

  def self.parse_name(name)
    names = name.split(" ")
    last_name = names.pop
    first_name = names.shift
    middle_initial = names.join(" ")
    [first_name, middle_initial, last_name]
  end
end
