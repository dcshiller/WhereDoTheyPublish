class PublicationCleaner
  def self.categorize!
    review_titles = [
      "Book Review%",
      "Review of %",
      "%(Editors)%",
      "%(Eds.)%",
      "% Pp. %"
    ]
    review_titles.each do |string|
      Publication.where("title LIKE ?", string).update_all(publication_type: "book review")
    end
    errata = [
      "Editorial%",
      "Editor%",
      "To the Reader",
      "Errata",
      "Erratum",
      "Introduction",
      "Books Received",
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
      "New Books:%"
    ]
    errata.each do |string|
      Publication.where("title LIKE ?", string).update_all(publication_type: "errata")
    end
  end
end