require 'test_helper'

class PublicationCleanerTest < ActiveSupport::TestCase
  test "it substitutes strings" do
    create :publication, title: "Two Dogmas of Web Development"
    create :publication, title: "Science without Abstracta"
    PublicationCleaner.substitute!("Two", "Three")
    assert_equal "Three Dogmas of Web Development", Publication.first.display_title
    assert_equal "Two Dogmas of Web Development", Publication.first.title
    assert_equal nil, Publication.last.display_title
  end
end