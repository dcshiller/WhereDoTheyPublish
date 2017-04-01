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
      "% Pp",
      "% Pages",
      "%, By % %",
      "% Isbn %",
      "% Isbn: %"
    ]
    review_titles.each do |string|
      Publication.articles.where("title LIKE ?", string).update_all(publication_type: "book review")
    end
    errata = [
      "About the Authors",
      "American Philosophical Association %",
      "Announcements",
      "%an Interview%",
      "Books in Review",
      "%Books Received%",
      "Current Periodical Articles",
      "Editorial%",
      "Editorial",
      "Editor%",
      "Errata",
      "Erratum",
      "From the % Editor%",
      "Forward",
      "Introduction",
      "Index of Authors",
      "Index of Books",
      "Index of Books Received",
      "Index of Subjects",
      "Index to Volume%",
      "Letter to the%",
      "List of % Participants",
      "In Memorium%",
      "Meeting of the Association%",
      "Memo to Authors",
      "Memo on Copyright",
      "New Books%",
      "News and Notes",
      "Note from the Editors",
      "Notes",
      "Notes and News%",
      "Notes on Contributors%",
      "Notice",
      "Notices",
      "Philosophical Abstracts",
      "Preface",
      "Program of the Meetings",
      "To the Reader"
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

  def self.substitute_if_first!(string_one, string_two)
    pubs = Publication.where("title LIKE '#{string_one}%'")
    pubs.each do |pub|
      old_title = pub.display_title || pub.title
      new_title = old_title.gsub(string_one, string_two)
      pub.display_title = new_title
      pub.save
    end
  end

  def self.substitute_if_last!(string_one, string_two)
    pubs = Publication.where("title LIKE '%#{string_one}'")
    pubs.each do |pub|
      old_title = pub.display_title || pub.title
      if old_title.ends_with? string_one
        new_title = old_title.chomp(string_one) + string_two
        pub.display_title = new_title
        pub.save
      end
    end
  end

  def self.remove_terminal_ones!
    ('a'..'z').to_a.each do |letter|
      substitute_if_last!("#{letter}1",letter)
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

  def self.titlize_quoted
    pubs = Publication.where("title LIKE ?","%\'%")
    pubs.each do |pub|
      title = pub.display_title || pub.title.dup
      ('a'..'z').to_a.each do |letter|
        title.gsub!("\'#{letter}","\'#{letter.upcase}")
      end
      ('a'..'z').to_a.each do |letter|
        title.gsub!("\"#{letter}","\"#{letter.upcase}")
      end
      pub.display_title = title
      pub.save
    end
  end
end