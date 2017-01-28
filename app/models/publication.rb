class Publication < ActiveRecord::Base
  has_many :authorships, autosave: true
  has_many :authors, through: :authorships, autosave: true
  belongs_to :journal

  validates :journal, presence: true

  scope :philosophy, ->{ where(philosophy: true)}
  scope :published_between, -> (years) {where(publication_year: years)}

  def title?(string_to_match)
    titles == string_to_match
  end

  def author?(name_to_match)
    authors.any? { |a| a.name? name_to_match }
  end

  def journal?(title_to_match)
    journal.title == title_to_match
  end

end
