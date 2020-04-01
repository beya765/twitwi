class UsersController < ApplicationController
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

  private
    # ユーザ登録で不正なデータが渡ってこないように内容指定
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                          :password_confirmation)
    end
end
