class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @title = "Witaj w aplikacji Bilecik"
    @description = "Aplikacja pozwala na zarządzanie wydarzeniami oraz zakup biletów."
  end

  protected
  def authenticate_user
    if session[:user_id]
      @current_user = User.find session[:user_id]
      return true
    else
      redirect_to root_path
      return false
    end
  end

  def save_login_state
    if session[:user_id]
      redirect_to root_path
      return false
    else
      return true
    end
  end
end
