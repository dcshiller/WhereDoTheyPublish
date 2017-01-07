class Publication < ActiveRecord::Base
  has_many :authorships, autosave: true
  has_many :authors, through: :authorships, autosave: true
  belongs_to :journal

  validates :journal, presence: true

  scope :philosophy, ->{ where(philosophy: true)}
  # attr_reader :journals, :authors

  # def initialize(title: nil, titles: nil, author: nil, authors: nil, journal: nil, journals: nil)
  #   @titles = arrayify(title || titles)
  #   @authors = arrayify(author || authors)
  #   @journals = arrayify(journal || journals)
  # end
  # 
  def title?(string_to_match)
    titles == string_to_match
  end

  def author?(name_to_match)
    authors.any? { |a| a.name? name_to_match }
  end

  def journal?(title_to_match)
    journal.title == title_to_match
  end

  # private
  # attr_reader :titles
  # 
  # def arrayify(obj)
  #   if obj.is_a? Array
  #     obj.compact
  #   elsif obj.nil?
  #     []
  #   else
  #     [obj]
  #   end
  # end
  # 
  # def remove_middle_initials_from(authors)
  #   if authors.is_a? Array
  #     authors.map do |author|
  #       remove_middle_initial_from author
  #     end
  #   elsif authors.is_a? String
  #     remove_middle_initial_from authors
  #   end
  # end
  # 
  # def remove_middle_initial_from(author)
  #   names = author.split(' ')
  #   return names[0] if names.length < 2
  #   names[0] .sp names[-1]
  # end
end
