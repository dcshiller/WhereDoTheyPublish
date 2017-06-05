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

  test "it substitutes strings ignoring first" do
    create :publication, title: "Two OOgmas of Web Development"
    PublicationCleaner.substitute_unless_first!("O", "o")
    assert_equal "Two Oogmas of Web Development", Publication.first.display_title
  end

  test "it works when restricted to last" do
    create :publication, title: "Two Dogmas of Web Development"
    PublicationCleaner.substitute_if_last!("ment", "mint")
    PublicationCleaner.substitute_if_last!("Dog", "Frog")
    assert_equal "Two Dogmas of Web Developmint", Publication.first.display_title
  end

  test "it removes terminal ones" do
    create :publication, title: "Two Dogmas1 of Web Development1"
    PublicationCleaner.remove_terminal_ones!
    assert_equal "Two Dogmas1 of Web Development", Publication.first.display_title
  end

  test "it capitalizes inside of quites" do
    create :publication, title: "Two 'dogmas' of Empiricism"
    PublicationCleaner.titlize_quoted
    assert_equal "Two 'dogmas' of Empiricism", Publication.first.reload.title
    assert_equal "Two 'Dogmas' of Empiricism", Publication.first.reload.display_title
  end
end