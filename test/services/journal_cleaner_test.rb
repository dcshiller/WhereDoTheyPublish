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
end