class JournalCleaner
  attr_reader :journal
  def self.remove_dups!(journal)
    JournalCleaner.new(journal).remove_dups!
  end

  def self.queue_dups_jobs
    Journal.find_each do |j|
      Resque.enqueue(DupRemoverJob, j.id)
    end
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

  def merge_partial_dups!
    journal.publications.each do |pub|
      next if pub.destroyed?
      near_dups = near_dups(pub)&.push(pub)
      next unless near_dups&.length.to_i > 1
      longest_titled = near_dups.sort { |p| p.title&.length }.last
      next if longest_titled.destroyed?
      all_authors = near_dups.map(&:authors).flatten.uniq
      assign_longest_authors(longest_titled, all_authors)
      (near_dups - [longest_titled]).each do |rd|
        rd.destroy if all_authors_match?(rd, longest_titled)
      end
    end
  end

  private

  def all_authors_match?(pub, pub_to_match)
    pub.authors.all? do |a|
      pub_to_match.authors.any? { |pma| a.match? pma }
    end
  end

  def assign_longest_authors(pub, authors)
    longest_authors = pub.authors.map do |author|
      matching_authors = authors.select {|a| a.match? author }
      matching_authors.sort_by! {|ma| ma.name.length }
      matching_authors.last
    end
    pub.authors = longest_authors
    pub.save
  end

  def any_dups?(pub)
    # !near_dups(pub).blank? || !dups(pub).blank?
    !dups(pub).blank?
  end

  def dups(pub)
    title = pub.proper_title
    year = pub.publication_year
    id = pub.id
    candidates = journal.publications.where("COALESCE(display_title,title) = ANY ( ARRAY[?, \'\']) OR title IS NULL", title).where(publication_year: year).where.not(id: id).distinct
    unless candidates.blank?
      authors = pub.authors.sort
      candidates.select {|c| c.authors.sort == authors}
    end
  end

  def near_dups(pub)
    title = pub.title
    year = pub.publication_year
    id = pub.id
    candidates = journal.publications.year(year).where("title LIKE ?", "%#{title}%").where.not(id: id).distinct
    if candidates.blank?
      []
    else
      authors = pub.authors
      candidates.select do |c|
        candidate_authors = c.authors
        authors.all? do |a|
          candidate_authors.any? { |ca| ca.match?(a) }
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