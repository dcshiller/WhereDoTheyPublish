class PubSaver

  def self.save(pub_list, options = {})
    pub_list.each do |pub|
      if pub.journal.persisted? && !pub.persisted?
        authors = get_authors(pub)
        assign_authorships(pub, authors)
      end
    end
  end

  def self.assign_authorships(pub, authors)
    publication = Publication.create(title: pub.title&.proper_titlecase, journal_id: pub.journal_id, publication_year: pub.publication_year, categorization: average_cat)
    debugger
    authors.each do |author|
      Authorship.create(author: author, publication: publication)
    end
  end

  def average_cat
    @average_categorization ||= CategoryReconciler.get_average_hash(Publication.order("RANDOM()").limit(1000))
  end

  def self.get_authors(pub)
    authors = pub.authors.map do |author|
      if author.persisted? 
        author
      elsif pub.journal
        this_author = Author.find_by(first_name: author.first_name, middle_initial: author.middle_initial, last_name: author.last_name)
        this_author || Author.create(first_name: author.first_name, middle_initial: author.middle_initial, last_name: author.last_name)
      end
    end.compact
  end
end
