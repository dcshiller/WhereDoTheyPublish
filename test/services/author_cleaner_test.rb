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
end