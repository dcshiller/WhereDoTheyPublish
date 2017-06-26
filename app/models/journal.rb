class Journal < ActiveRecord::Base
  include Categorizable
  has_many :publications
  has_many :articles
  has_many :authors, through: :publications
  has_many :authorships, through: :publications

  def affinities
    Affinity.where(first_journal_id: id).or(Affinity.where(second_journal_id: id))
  end

  scope :empty, -> { where.not(id: Journal.joins(:publications).ids) }
  scope :philosophy, -> { where(philosophy: true) }

  def high_affinity_journals
    ids = affinities.where("affinity > 30 AND NOT affinity > 100").pluck(:first_journal_id, :second_journal_id).flatten.uniq
    Journal.where(id: ids)
  end

  def articles
    publications.articles
  end

  def article_authors
    Author.where(id: authorships.where(publication_id: articles.pluck(:id)).pluck(:author_id).uniq)
  end

  def years
    publication_start..(publication_end || 2017)
  end

  def self.condensed_name(name)
    cn = name.remove("The ", "A ", "'")
    cn = cn.split(":").first
    cn = cn.split("- ").first
    cn = cn.gsub("  ", " ")
    cn = cn.strip
  end

  def co_publication_percentage(other_journal)
    authors_count = authors.having_five_pubs.pluck(:id).count
    other_authors_count = other_journal.authors.having_five_pubs.pluck(:id).count
    # co_pub_ids = authors.merge(Author.group(:id).where("COUNT(authorships.id) > 5").pluck(:id) & other_journal.authors.pluck(:id)
    co_pub_ids = authors.having_five_pubs.pluck(:id) & other_journal.authors.having_five_pubs.pluck(:id)
    co_pub_authors_count = co_pub_ids.count
    (co_pub_authors_count.to_f * 100 / [authors_count, other_authors_count].min).round(2)
  end

  def proper_name
    display_name || name
  end
end