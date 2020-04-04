require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # fixtures/users.yml より読み込み
    # アクティブ化されていないユーザをセットアップ
    @non_activated_user = users(:hoge)
  end

  test "ログイン失敗時、フラッシュメッセージは残留しない" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    # 画面遷移時、フラッシュメッセージが残ってないことを確認
    get root_path
    assert flash.empty?
  end

  test "正規ユーザーでログイン" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    # リダイレクト先が正しいかチェックして、ページ移動
    assert_redirected_to @user
    follow_redirect!
    
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)

    # ユーザーログアウトのテスト
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレート
    delete logout_path

    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "記憶ユーザーとしてログイン" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token'] # 永続クッキー保存の確認
    # assignsメソッドでsession#create内の@userにアクセス
    assert_equal cookies['remember_token'], assigns[:user].remember_token
  end

  test "クッキーが残留しないことを確認" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

  test "有効化されていないユーザーでログイン" do
    log_in_as(@non_activated_user)
    assert_redirected_to root_url
  end
end
