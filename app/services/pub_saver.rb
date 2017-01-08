class PubSaver
  def self.save(pub_list, options = {})
    pub_list.each do |pub|
      authors = get_authors(pub)
      if pub.journal.persisted? && !pub.persisted? && pub.journal.philosophy
        assign_authorships(pub, authors)
      end
    end
  end

  def self.assign_authorships(pub, authors)
    publication = Publication.create(title: pub.title&.proper_titlecase, journal_id: pub.journal_id, publication_year: pub.publication_year)
    authors.each do |author|
      Authorship.create(author: author, publication: publication)
    end
  end

  def self.get_authors(pub)
    authors = pub.authors.map do |author|
      if author.persisted? 
        author
      elsif pub.journal && pub.journal.philosophy
        this_author = Author.find_by(first_name: author.first_name, middle_initial: author.middle_initial, last_name: author.last_name)
        this_author || Author.create(first_name: author.first_name, middle_initial: author.middle_initial, last_name: author.last_name)
      end
    end.compact
  end
end
