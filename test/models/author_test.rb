require 'test_helper'

class AuthorTest < ActiveSupport::TestCase

  test "finds "

  test "merges authors" do
    a1 = create :author, :with_publication
    a2 = create :author, :with_publication
    a2.merge_into a1
    assert_equal 2, a1.authorships.count
    assert_equal 1, Author.count
  end 
end