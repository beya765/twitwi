class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "おはよう、諸君！"
  end
end
