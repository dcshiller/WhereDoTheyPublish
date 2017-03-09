class JournalCleaner
  attr_reader :journal
  def self.remove_dups!(journal)
    JournalCleaner.new(journal).remove_dups!
  end

  def initialize(journal)
    @journal = Journal.find_by(name: journal) if journal.is_a? String
    @journal = journal if journal.is_a? Journal
  end

  def remove_dups!
    journal.years.each do |year|
      journal.publications.year(year).each do |pub|
        clear_dups
        if any_dups?(pub)
          remove_dups(pub)
        end
      end
    end
  end

  private

  def any_dups?(pub)
    # !near_dups(pub).blank? || !dups(pub).blank?
    !dups(pub).blank?
  end

  def dups(pub)
    @dups ||= begin
      title = pub.title
      year = pub.publication_year
      id = pub.id
      candidates = journal.publications.where(title: [title, nil, ""], publication_year: year).where.not(id: id).distinct
      unless candidates.blank?
        authors = pub.authors.sort
        candidates.select {|c| c.authors.sort == authors}
      end
    end
  end

  def near_dups(pub)
    @near_dups ||= begin
      title = pub.title
      year = pub.publication_year
      id = pub.id
      candidates = journal.publications.where("title LIKE ?", "%#{title}%").where.not(id: id).distinct
      unless candidates.blank?
        authors = pub.authors.sort
        candidates.reject do |c|
          candidate_authors = c.authors.sort
          authors.all?.with_index do |a,idx|
            a.match?(candidate_authors[idx])
          end
        end
      end
    end
  end

  def remove_dups(pub)
    return unless Publication.exists?(pub.id)
    dups(pub).each { |op| op.destroy }
  end

  def clear_dups
    @dups = nil
  end
end