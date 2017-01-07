class PubSaver
  def self.save(pub_list, options = {})
    pub_list.each do |pub|
      authors = pub.authors.map do |author|
        if author.persisted? 
          author
        elsif pub.journal && pub.journal.philosophy
          this_author = Author.find_by(first_name: author.first_name, middle_initial: author.middle_initial, last_name: author.last_name)
          this_author || Author.create(first_name: author.first_name, middle_initial: author.middle_initial, last_name: author.last_name)
        end
      end.compact

      if pub.journal.persisted? && !pub.persisted? && pub.journal.philosophy
        publication = Publication.create(title: pub.title&.proper_titlecase, journal_id: pub.journal_id, publication_year: pub.publication_year)
        authors.each do |author|
          Authorship.create(author: author, publication: publication)
        end
      else
        puts pub&.journal&.name
      end
    end
  end
end
