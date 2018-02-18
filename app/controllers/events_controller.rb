class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    if params[:commit] == "Filtruj"
      if params[:start_date] != "" && params[:end_date] != "" && params[:start_date] > params[:end_date]
        flash[:danger] = "Data końcowa musi być późniejsza niż początkowa"
        @events = Event.all
      elsif params[:start_date] == ""
        if !session[:admin]
          @events = Event.where(:date => Date.today().to_s..params[:end_date])
        else
          @events = Event.where("date <= ?", params[:end_date].to_date)
        end
      elsif params[:end_date] == ""
        if params[:start_date].to_date < Date.today() && !session[:admin]
          @events = Event.where("date >= ?", Date.today())
        else
          @events = Event.where("date >= ?", params[:start_date].to_date)
        end
      else
        if session[:admin]
          @events = Event.where(:date => params[:start_date]..params[:end_date])
        else
          if params[:start_date].to_date < Date.today
            @events = Event.where(:date => Date.today().to_s..params[:end_date])
          else
            @events = Event.where(:date => params[:start_date]..params[:end_date])
          end
        end
      end
    elsif session[:admin]
      @events = Event.all
    else
      @events = Event.where("date >= ?", Date.today)
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        flash[:success] = "Dodano nowe wydarzenie"
        format.html { redirect_to @event }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        flash[:success] = "Edycja zakończona powodzeniem"
        format.html { redirect_to @event }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      flash[:success] = "Usunięto wydarzenie"
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :price, :date, :adult_only, :image, :size)
    end
end
