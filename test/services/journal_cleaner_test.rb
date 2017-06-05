require 'test_helper'

class JournalCleanerTest < ActiveSupport::TestCase
  test "it removes nils for a present author" do
    author = create :author
    journal = create :journal
    create :publication, journal: journal, authors: [author], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author], title: nil, publication_year: 1970
    JournalCleaner.remove_dups! journal
    there_must_be 1, Publication
  end

  test "it removes empties for a present author" do
    author = create :author
    journal = create :journal
    create :publication, journal: journal, authors: [author], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author], title: "", publication_year: 1970
    JournalCleaner.remove_dups! journal
    there_must_be 1, Publication
  end

  test "it removes dups for a present author" do
    author = create :author
    journal = create :journal
    create :publication, journal: journal, authors: [author], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    JournalCleaner.remove_dups! journal
    there_must_be 1, Publication
  end

  test "it removes dups by display_title" do
    author = create :author
    journal = create :journal
    create :publication, journal: journal, authors: [author], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author], display_title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    JournalCleaner.remove_dups! journal
    there_must_be 1, Publication
  end

  test "it does not remove non-dups" do
    author = create :author
    journal = create :journal
    create :publication, journal: journal, authors: [author], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author], title: "Three Dogmas of Empiricism", publication_year: 1970
    create :publication, journal: journal, authors: [author], title: "", publication_year: 1971
    JournalCleaner.remove_dups! journal
    there_must_be 3, Publication
  end

  test "it does not remove empties from other authors" do
    author_one = create :author
    author_two = create :author
    journal = create :journal
    create :publication, journal: journal, authors: [author_one], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author_two], title: "", publication_year: 1970
    JournalCleaner.remove_dups! journal
    there_must_be 2, Publication
  end

  test "it does not remove dups from other authors" do
    author_one = create :author
    author_two = create :author
    journal = create :journal
    create :publication, journal: journal, authors: [author_one], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author_two], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    JournalCleaner.remove_dups! journal
    there_must_be 2, Publication
  end

  test "it merges near duplicate publications" do
    author_one = create :author, first_name: "A", last_name: "Ayer", middle_initial: "C."
    author_two = create :author, first_name: "Alfred", last_name: "Ayer", middle_initial: "C."
    journal = create :journal
    create :publication, journal: journal, authors: [author_one], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author_two], title: "Two Dogmas", publication_year: 1970
    JournalCleaner.new(journal).merge_partial_dups!
    there_must_be 1, Publication
    assert_equal "Alfred", Publication.first.authors.first.first_name
    assert_equal "Two Dogmas of Semantic Essentialism", Publication.first.title
  end

  test "it merges near duplicate publications with lots of duplicates" do
    author_one = create :author, first_name: "A", last_name: "Ayer", middle_initial: "C."
    author_two = create :author, first_name: "Alfred", last_name: "Ayer", middle_initial: "C."
    author_three = create :author, first_name: "Alfredo", last_name: "Ayer", middle_initial: "C."
    author_four = create :author, first_name: "Ernest", last_name: "Sosa", middle_initial: "C."
    journal = create :journal
    create :publication, journal: journal, authors: [author_one], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author_two], title: "Two Dogmas", publication_year: 1970
    create :publication, journal: journal, authors: [author_three], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author_four], title: "Dogmas of Semantic Essentialism", publication_year: 1970
    JournalCleaner.new(journal).merge_partial_dups!
    there_must_be 2, Publication
    there_must_be 1, Publication.where(title: "Two Dogmas of Semantic Essentialism")
    there_must_be 1, Publication.where(title: "Dogmas of Semantic Essentialism")
  end

  test "it does not merges near duplicate from different years" do
    author_one = create :author, first_name: "A", last_name: "Ayer", middle_initial: "C."
    author_two = create :author, first_name: "Alfred", last_name: "Ayer", middle_initial: "C."
    journal = create :journal
    create :publication, journal: journal, authors: [author_one], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author_two], title: "Two Dogmas", publication_year: 1971
    JournalCleaner.new(journal).merge_partial_dups!
    there_must_be 2, Publication
  end
  
  test " finds many duplicate publications" do
    author_one = create :author, first_name: "A", last_name: "Ayer", middle_initial: "C."
    author_two = create :author, first_name: "Alfred", last_name: "Ayer", middle_initial: "C."
    author_three = create :author, first_name: "Alfredo", last_name: "Ayer", middle_initial: "C."
    author_four = create :author, first_name: "Ernesto", last_name: "Sosa", middle_initial: "C."
    author_five = create :author, first_name: "E", last_name: "S", middle_initial: "C."
    journal = create :journal
    create :publication, journal: journal, authors: [author_one], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author_two], title: "Two Dogmas", publication_year: 1970
    create :publication, journal: journal, authors: [author_three], title: "Two Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author_four], title: "Dogmas of Semantic Essentialism", publication_year: 1970
    create :publication, journal: journal, authors: [author_five], title: "D", publication_year: 1970
    JournalCleaner.new(journal).merge_partial_dups!
    there_must_be 2, Publication
    assert_equal 0, author_one.reload.publications.count
    assert_equal 0, author_two.reload.publications.count
    assert_equal 1, author_three.reload.publications.count
    assert_equal 1, Publication.where(title: "Two Dogmas of Semantic Essentialism").count
    assert_equal 0, Publication.where(title: "Two Dogmas").count
  end
end
