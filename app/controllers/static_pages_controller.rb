class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # shared/_micropost_form.html.erbに渡すインスタンス変数
      @micropost = current_user.microposts.build if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
      
  end

  def about
  end

  def contact
  end
end
