class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    # debugger
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザ登録ありがとうございます！"
      redirect_to @user # redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  # beforeフィルターのcorrect_userで@user変数を定義しているため、
  # editとupdateの@userへの代入文は不要

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除が完了しました"
    redirect_to users_url
  end

  private
    # ユーザ登録で不正なデータが渡ってこないように内容指定
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                          :password_confirmation)
    end

    # before action

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location # アクセス先記憶
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
