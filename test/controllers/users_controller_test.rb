require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # fixture
    @other_user = users(:archer)
  end

  test "未ログイン時、ユーザー一覧ページにアクセスするとリダイレクトされる" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "未ログイン時、編集ページへアクセスするとリダイレクトされる" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "未ログイン時、更新処理を行うとリダイレクトされる" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "他者ユーザーの編集を行おうとすればリダイレクトされる" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "他者ユーザーの更新を行おうとすればリダイレクトされる" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "",
                                            password_confirmation: "",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "未ログイン時、削除しようとすればリダイレクトされる" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "管理者ユーザーでなければ削除できない" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "未ログイン時、フォローの一覧ページに移動しようとすればリダイレクトされる" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "未ログイン時、フォロワーの一覧ページに移動しようとすればリダイレクトされる" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
