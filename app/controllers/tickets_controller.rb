class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :do_return, :undo_return, :submit_return]
  before_action :check_preconditions, only: [:create]

  def check_preconditions
    if ticket_params[:amount].to_f < 0
      respond_to do |format|
        flash[:danger] = 'Musisz podać dodatnią ilość biletów do zakupu'
        format.html { redirect_to events_path }
        format.json { render root_path }
      end
    end
    $user = User.find(ticket_params[:user_id])
    $event = Event.find(ticket_params[:event_id])
    if $event[:adult_only] && ((Date.today - $user.birth) / 365).floor < 18
      respond_to do |format|
        flash[:danger] = 'Musisz być pełnoletni aby kupić bilety na to wydarzenie'
        format.html { redirect_to events_path }
        format.json { render root_path }
      end
    elsif $user[:money].to_f < ticket_params[:amount].to_f * ticket_params[:price].to_f
      respond_to do |format|
        flash[:danger] = 'Nie masz wystarczających środków na koncie'
        format.html { redirect_to events_path }
        format.json { render root_path }
      end
    elsif Ticket.where(user_id: ticket_params[:user_id], event_id: ticket_params[:event_id]).count() + ticket_params[:amount].to_f > 5
      respond_to do |format|
        flash[:danger] = 'Nie możesz kupić tylu biletów na to wydarzenie'
        format.html { redirect_to events_path }
        format.json { render root_path }
      end
    elsif $event[:size] < ticket_params[:amount].to_f + Ticket.where(event_id: ticket_params[:event_id]).count()
      respond_to do |format|
        flash[:danger] = 'Na podane wyrażenie nie ma już tylu dostępnych miejsc'
        format.html { redirect_to events_path }
        format.json { render root_path }
      end
    end
  end

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.where(user_id: session[:user_id])
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    $amount = ticket_params[:amount].to_f
    $i = 0
    @tickets = []
    while $i < $amount
      @tickets.push(Ticket.new(ticket_params.tap{|ticket_params| ticket_params.delete(:amount)}))
      $i += 1
    end
    respond_to do |format|
      if @tickets.each(&:save)
        @user = User.find(ticket_params[:user_id])
        @user.money -= $amount * ticket_params[:price].to_f
        @user.update(money: @user.money)
        flash[:success] = 'Zakupiono bilety'
        format.html { redirect_to events_path }
        format.json { render root_path }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def do_return
    respond_to do |format|
      if @ticket.update(to_return: count_return)
        format.html { redirect_to tickets_path, class: "btn-lg btn-secondary", tickets: Ticket.where(user_id: session[:user_id]) }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def undo_return
    respond_to do |format|
      if @ticket.update(to_return: 0)
        format.html { redirect_to tickets_path, class: "btn-lg btn-secondary", tickets: Ticket.where(user_id: session[:user_id]) }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def to_return
    @tickets = Ticket.where("to_return > ?", 0.0)
  end

  def submit_return
    @user = User.find(@ticket.user_id)
    $temp = @ticket.to_return
    @ticket.destroy
    respond_to do |format|
      @user.update(money: @user.money + @ticket.to_return)
      flash[:success] = "Zatwierdzono zwrot"
      format.html { redirect_to to_return_tickets_path }
      format.json { head :no_content }
    end
  end
  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:price, :event_id, :user_id, :amount, :to_return)
    end

    def count_return
      return @ticket.price - (@ticket.price * 0.1) - ((1 - (@ticket.event.date - Date.today) / 30) * @ticket.price / 2)
    end

  # def person_params
  #   params.require(:ticket).permit(:name, :age)
  # end
end
