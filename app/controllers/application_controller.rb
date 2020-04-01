class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper # 他コントローラーでも使用できるようにする
end
