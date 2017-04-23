require 'test_helper'

class AuthorCleanerTest < ActiveSupport::TestCase
  test "it deletes authors and authorships" do
    create :author, :with_publication, first_name: nil, middle_initial: nil, last_name: nil
    AuthorCleaner.delete_nils!
    there_must_be 0, Author
    there_must_be 1, Publication
  end

  test "it leaves other authors alone" do
    author = create :author, :with_publication, first_name: nil, middle_initial: nil, last_name: nil
    real_author = create :author
    Authorship.create(author: real_author, publication: author.publications.first)
    AuthorCleaner.delete_nils!
    there_must_be 1, Author
    there_must_be 1, Publication
    there_must_be 1, Authorship
  end

  test "delete with no pubs" do
    create :author, :with_publication, first_name: "Achille", middle_initial: nil, last_name: "Varzi"
    create :author, first_name: "David", middle_initial: nil, last_name: "Lewis"
    AuthorCleaner.delete_with_no_pubs!
    there_must_be 1, Author
  end

  test "spreads middle initials" do
    create :author, first_name: "D.C.", last_name: "Shiller"
    create :author, middle_initial: "M.B.N."
    create :author, first_name: "W.V.O.", middle_initial: nil, last_name: "Quine"
    create :author, first_name: "W. V. O.", middle_initial: nil, last_name: "Quine"
    AuthorCleaner.space_initials!
    assert_equal "D. C.", Author.first.first_name
    assert_equal "M. B. N.", Author.second.middle_initial
    there_must_be 3, Author
  end

  test "moves middle initials correctly" do
    create :author, first_name: "Achille C.", middle_initial: nil, last_name: "Varzi"
    create :author, first_name: "D. B.", middle_initial: "", last_name: "Cooper"
    create :author, first_name: "Alfred J.", middle_initial: "", last_name: "Ayer"
    create :author, first_name: "Alfred", middle_initial: "J.", last_name: "Ayer"
    AuthorCleaner.move_initials_to_middle!
    assert_equal "C.", Author.first.middle_initial
    assert_equal "Achille", Author.first.first_name
    assert_equal "B.", Author.second.middle_initial
    there_must_be 3, Author
  end

  test "uncapitalizes non-first characters" do
    create :author, first_name: "ÝartÄ", last_name: "ËËËrg", middle_initial: ""
    AuthorCleaner.remove_non_first_accented_caps!
    assert_equal "Ýartä", Author.first.first_name
    assert_equal "Ëëërg", Author.first.last_name
  end
end