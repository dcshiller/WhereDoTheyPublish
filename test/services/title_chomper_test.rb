require 'test_helper'

class TitleChomperTest < ActiveSupport::TestCase
  test 'it chomps periods' do
    pub = create :publication, title: "This ends in one period."
    TitleChomper.chomp!
    pub.reload
    assert_equal "This ends in one period.", pub.title
    assert_equal "This ends in one period", pub.display_title
  end
  test 'it doesnt chomp exclamations' do
    pub = create :publication, title: "This ends in one period!"
    TitleChomper.chomp!
    pub.reload
    assert_nil pub.display_title
  end

  test "it works on display titles too" do
    pub = create :publication, title: "goby", display_title: "This ends in one period."
    TitleChomper.chomp!
    pub.reload
    assert_equal  "This ends in one period", pub.display_title
  end

  test 'it does not chomp periods at the end of elipsis' do
    pub = create :publication, title: "This ends in three periods..."
    TitleChomper.chomp!
    pub.reload
    assert_equal "This ends in three periods...", pub.title
    refute_equal "This ends in three periods", pub.display_title
    refute_equal "This ends in three periods..", pub.display_title
  end
end