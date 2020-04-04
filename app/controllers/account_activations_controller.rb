class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    # ユーザが存在 + 未有効化 + 有効化トークンの一致
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "アカウント登録が完了しました。"
      redirect_to user
    else
      flash[:danger] = "アカウント登録における、このリンクは無効です"
      redirect_to root_url
    end
  end
end
