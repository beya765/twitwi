class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper # 他コントローラーでも使用できるようにする

  private
    # ユーザーのログインを確認する(UsersとMicropostsのコントローラーで使用)
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
