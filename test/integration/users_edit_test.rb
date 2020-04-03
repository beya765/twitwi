require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # fixtures/users.yml より読み込み
  end

  test "ユーザーの編集にて無効な値をセット" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "invalid@mail",
                                              password: "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select 'div.alert', "The form contains 4 errors."
  end
    
  test "ユーザーの編集にて有効な値をセット + フレンドリーフォワーディング" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    name = "Foo Bar"
    email = "valid@mail.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
