require 'test_helper'

class AuthorMergerTest < ActiveSupport::TestCase
  test "merges two matching authors by middle initial" do
    create :author, :with_publication, first_name: "W.", middle_initial: "V.", last_name: "Quine"
    create :author, :with_publication, first_name: "W.", middle_initial: "Van Orman", last_name: "Quine"
    AuthorMerger.merge!
    there_must_be 1, Author
  end

  test "merges two matching authors" do
    create :author, :with_publication, first_name: "W.", middle_initial: "V.", last_name: "Quine"
    create :author, :with_publication, first_name: "Willard", middle_initial: "V.", last_name: "Quine"
    AuthorMerger.merge!
    there_must_be 1, Author
  end

  test "merges two matching authors by first and middles" do
    create :author, :with_publication, first_name: "K.", middle_initial: "F.", last_name: "Godel"
    create :author, :with_publication, first_name: "Kurt", middle_initial: "Friedrich", last_name: "Godel"
    create :author, :with_publication, first_name: "Bogus", middle_initial: "von", last_name: "Schmidt"
    AuthorMerger.merge!
    there_must_be 2, Author
  end

  test "does not merge non-matching authors" do
    create :author, :with_publication, first_name: "W.", middle_initial: "V.", last_name: "Quine"
    create :author, :with_publication, first_name: "W.", middle_initial: "Orman", last_name: "Quine"
    AuthorMerger.merge!
    there_must_be 2, Author
  end

  test "accommodates multiple middle initials" do
    create :author, :with_publication, first_name: "W.", middle_initial: "V. O.", last_name: "Quine"
    create :author, :with_publication, first_name: "W.", middle_initial: "Van Orman", last_name: "Quine"
    create :author, :with_publication, first_name: "Rudolph", middle_initial: "V.O.", last_name: "Carnap"
    create :author, :with_publication, first_name: "Rudolph", middle_initial: "Van Orman", last_name: "Carnap"
    create :author, :with_publication, first_name: "Alfred", middle_initial: "V.O.R.", last_name: "Ayer"
    create :author, :with_publication, first_name: "Alfred", middle_initial: "Van Orman Richard", last_name: "Ayer"
    AuthorMerger.merge!
    there_must_be 3, Author
  end
end