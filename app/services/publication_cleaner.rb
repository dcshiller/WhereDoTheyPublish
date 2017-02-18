class PublicationCleaner
  def self.categorize!
    review_titles = [
      "Book Review%",
      "Review of %",
      "%(Editors)%",
      "%(Eds.)%",
      "% Pp. %",
      ", By % %"
    ]
    review_titles.each do |string|
      Publication.articles.where("title LIKE ?", string).update_all(publication_type: "book review")
    end
    errata = [
      "Editorial%",
      "Editor%",
      "To the Reader",
      "Errata",
      "Erratum",
      "Introduction",
      "Books Received",
      "New Books%",
      "Notes and News%",
      "List of % Participants",
      "Memo to Authors",
      "Memo on Copyright",
      "Letter to the",
      "Meeting of the Assocation",
      "In Memorium%",
      "Current Periodical Articles",
      "Philosophical Abstracts",
      "About the Authors",
      "Announcements",
      "Notes on Contributors%",
      "Preface",
      "Forward",
      "Index of Authors",
      "Index of Books Received",
      "New Books:%",
      "American Philosophical Association %",
      "Index to Volume%",
      "Index of Books",
      "Program of the Meetings",
      "Note from the Editors"
    ]
    errata.each do |string|
      Publication.articles.where("title LIKE ?", string).update_all(publication_type: "errata")
    end
  end

  def self.dequote!
    quoted = Publication.where("title LIKE '\"%\"'")
    quoted.each do |pub|
      title = pub.display_title || pub.title
      if title[0] == "\"" && title[-1] == "\"" && title.count("\"") == 2
        pub.display_title = title[1..-2]
        pub.save
        puts pub.display_title
      end
    end
  end
end