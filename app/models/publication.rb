class Publication < ActiveRecord::Base
  include Categorizable
  has_many :authorships, autosave: true
  has_many :authors, through: :authorships, autosave: true
  belongs_to :journal

  before_create :assign_cat
  validates :journal, presence: true

  scope :published_between, -> (years) { where(publication_year: years[0]...years[1]) }
  scope :year,              -> (value) { where(publication_year: value) }
  scope :articles,          -> { where(publication_type: "article") }
  scope :book_reviews,      -> { where(publication_type: "book_review") }
  scope :errata,            -> { where(publication_type: "errata") }

  def title?(string_to_match)
    titles == string_to_match
  end

  def one_page?
    pages && page_array.count > 1 &&
      (page_array[1] - page_array[0]).between?(0,1)
  end

  def page_array
    @page_arr ||= pages.split("-").map(&:to_i)
  end

  def proper_title
    (display_title || title).to_s.html_safe
  end

  def author?(name_to_match)
    authors.any? { |a| a.name? name_to_match }
  end

  def journal?(title_to_match)
    journal.title == title_to_match
  end

  def assign_cat
    self.categorization = starting_cat
  end
end
