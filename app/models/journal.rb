class Journal < ActiveRecord::Base
  has_many :publications
  has_many :authors, through: :publications

  scope :philosophy, -> { where(philosophy: true)} 

  
  def self.condensed_name(name)
    cn = name.remove("The ", "A ", "'")
    cn = cn.split(":").first
    cn = cn.split("- ").first
    cn = cn.gsub("  ", " ")
    cn = cn.strip
  end

  def co_publication_percentage(other_journal)
    authors_count = authors.count
    other_authors_count = other_journal.authors.count
    co_pub_ids = authors.pluck(:id) & other_journal.authors.pluck(:id)
    co_pub_authors_count = co_pub_ids.count
    co_pub_authors_count.to_f / [authors_count, other_authors_count].min
  end
end