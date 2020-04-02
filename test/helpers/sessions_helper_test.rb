require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:michael) # fixture呼び出し
    remember(@user) # 生成トークンをremember_digestへ登録、cookie作成
  end

  test "current_userメソッドのテスト(初期セッションID無し)" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_userメソッドのテスト(初期セッションID無し、かつ記憶トークン相違)" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end