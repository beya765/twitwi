require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:michael) # fixture
    @non_admin = users(:archer) 
    @non_activated_user = users(:hoge)
  end
  
  test "ページネーションを含めたUsersIndexのテスト" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    # paginateメソッドで30件取り出し、ユーザーリンクなどを1件ずつチェック
    User.where(activated: true).paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: '(このユーザーを削除する)'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
    assert_select 'a[href=?]', user_path(@non_activated_user), count: 0
  end

  test "管理者ユーザー出ない場合、削除リンクは表示されない" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: '(このユーザーを削除する)', count: 0
  end
end
