require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael) # fixture
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "マイクロポストの有効性テスト" do
    assert @micropost.valid?
  end

  test "ユーザのIDがないと、関連付けの関係でマイクロポストは無効となる" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "コンテンツがなければ無効となる" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "コンテンツは140文字以内におさめる" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "マイクロポストは最新のものが最初に来る" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
