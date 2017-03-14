class PublicationCleaner
  def self.categorize!
    review_titles = [
      "Book Review%",
      "%(Hardcover)%",
      "%(Paperback)%",
      "%University Press%",
      "Review of %",
      "%(Editors)%",
      "% a Book Review%",
      "%Oxford: Oxford%",
      "%Routledge Press%",
      "% Book Review %",
      "%(Eds.)%",
      "% Pp. %",
      "% Pp.,%",
      "% Pages",
      "%, By % %",
      "% Isbn %",
      "% Isbn: %"
    ]
    review_titles.each do |string|
      Publication.articles.where("title LIKE ?", string).update_all(publication_type: "book review")
    end
    errata = [
      "Editorial%",
      "Editorial",
      "Books in Review",
      "Editor%",
      "From the % Editor%",
      "To the Reader",
      "Errata",
      "Erratum",
      "Introduction",
      "Index of Subjects",
      "%Books Received%",
      "%an Interview%",
      "New Books%",
      "News and Notes",
      "Notes and News%",
      "List of % Participants",
      "Memo to Authors",
      "Memo on Copyright",
      "Letter to the%",
      "Meeting of the Association%",
      "In Memorium%",
      "Current Periodical Articles",
      "Philosophical Abstracts",
      "About the Authors",
      "Announcements",
      "Notes on Contributors%",
      "Preface",
      "Forward",
      "Index of Authors",
      "Books Received",
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
    ["\"", "\'"].each do |mark|
      quoted = Publication.where("title LIKE '#{mark}%#{mark}'")
      quoted.each do |pub|
        title = pub.display_title || pub.title
        if title[0] == mark && title[-1] == mark && title.count(mark) == 2
          pub.display_title = title[1..-2]
          pub.save
          puts pub.display_title
        end
      end
    end
  end

  def self.substitute!(string_one, string_two)
    pubs = Publication.where("title LIKE '%#{string_one}%'")
    pubs.each do |pub|
      old_title = pub.display_title || pub.title
      new_title = old_title.gsub(string_one, string_two)
      pub.display_title = new_title
      pub.save
    end
  end

  def self.substitute_unless_first!(string_one, string_two)
    pubs = Publication.where("title LIKE '%#{string_one}%'")
    pubs.each do |pub|
      old_title = pub.display_title || pub.title
      new_title_arr = old_title.split(" ")
      new_title_arr.map! do |word|
        first_letter, the_rest = word[0], word[1..-1]
        the_rest.gsub!(string_one, string_two)
        first_letter + the_rest
      end
      new_title = new_title_arr.join(" ")
      pub.display_title = new_title
      pub.save
    end
  end

  def self.cut_dash!
    pubs = Publication.where("display_title LIKE '—%'")
    pubs.each do |pub|
      old_title = pub.display_title
      new_title = old_title[1..-1]
      pub.display_title = new_title
      pub.save
    end
  end
end