class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # 有効でないユーザーがログインできないようにする
      if @user.activated?
        log_in @user
        # ユーザー保持次第でログイン処理変化
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user # user_url(user)
      else
        message = "アカウントが有効化されていません。"
        message += "送られてきたメールのリンクを確認してください。"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Eメールまたはパスワードが違います'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
