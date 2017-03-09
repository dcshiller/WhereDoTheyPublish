require 'test_helper'

class AuthorTest < ActiveSupport::TestCase

  test "merges authors" do
    a1 = create :author, :with_publication
    a2 = create :author, :with_publication
    a2.merge_into a1
    assert_equal 2, a1.authorships.count
    assert_equal 1, Author.count
  end

  test "checks consistent of publications" do
    a1 = create :author, :with_publication
    a2 = create :author, :with_publication
    a3 = create :author, :with_publication
    a1.publications.update_all(publication_year: 1970)
    a2.publications.update_all(publication_year: 2005)
    a3.publications.update_all(publication_year: 1973)
    
    assert !a1.publication_consistent?(a2)
    assert a1.publication_consistent?(a3)
  end

  test "matches authors" do
    a1 = create :author, first_name: "Bill", middle_initial: "T.", last_name: "Fiddle"
    a2 = create :author, first_name: "B.", middle_initial: "T.", last_name: "Fiddle"
    a3 = create :author, first_name: "B.", middle_initial: "Tuberculosis", last_name: "Fiddle"
    a4 = create :author, first_name: "A.", middle_initial: "Tuberculosis", last_name: "Fiddle"
    assert a1.match(a2)
    assert a2.match(a3)
    assert a1.match(a3)
    refute a1.match(a4)
    refute a4.match(a1)
  end
end