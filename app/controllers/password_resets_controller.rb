class PasswordResetsController < ApplicationController
  before_action :get_user,          only: [:edit, :update]
  before_action :valid_user,        only: [:edit, :update]
  before_action :check_expiration,  only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定のメールを送信しましたのでご確認ください。"
      redirect_to root_url
    else
      flash.now[:danger] = "このメールアドレスは登録されていません"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "新しいパスワードの設定が完了しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    # データ指定
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する。
    def valid_user
      #  条件を満たさない場合リダイレクト(ユーザーが存在する、有効化、認証)
      unless (@user && @user.activated? && 
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワード再設定の有効期限が切れてます"
        redirect_to new_password_reset_url
      end
    end
end
