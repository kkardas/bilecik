class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :add_money, :sub_money]
  before_action :save_login_state, :only => [:new, :create]
  before_action :check_money_amount, :only => [:add_money]

  def check_money_amount
    if params[:money].to_f < 0.0
      respond_to do |format|
        flash[:danger] = "Kwota doładowania musi być dodatnia"
        format.html { redirect_to edit_user_path(@user.id) }
      end
    end
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.money = 0
    @user.admin = false
    respond_to do |format|
      if @user.save
        flash[:success] = 'Poprawnie zarejestrowano'
        session[:user_id] = @user.id
        session[:admin] = false
        format.html { redirect_to root_path }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = 'Poprawnie doładowano'
        format.html { redirect_to root_path }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_money
    respond_to do |format|
      if @user.update(:money => @user.money + params[:money].to_f)
        flash[:success] = "Poprawnie doładowano"
        format.html { redirect_to root_path }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def sub_money
    respond_to do |format|
      if @user.update(:money => @user.money - params[:money].to_f)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :money, :birth)
    end
end
