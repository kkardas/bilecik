class SessionController < ApplicationController
  # before_filter :authenticate_user, :only => [root_path]
  before_action :save_login_state, :only => [:login, :login_attempt]

  def login
    if params[:danger]
      flash[:kup] = "Musisz być zalogowany aby kupować bilety"
    end
  end

  def login_attempt
    authorized_user = User.authenticate(params[:username], params[:login_password])
    if authorized_user
      session[:user_id] = authorized_user.id
      session[:admin] = authorized_user.admin
      flash[:success] = "Jesteś zalogowany jako #{authorized_user.name}"
      redirect_to root_path
    else
      flash[:danger] = "Niepoprawny login lub hasło"
      render "login"
    end
  end

  def logout
    flash[:success] = "Wylogowano"
    session[:user_id] = nil
    session[:admin] = nil
    redirect_to root_path
  end
end
