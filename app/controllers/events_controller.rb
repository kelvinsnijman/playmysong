class EventsController < ApplicationController
  skip_before_action :authenticate_user!, :only => :live_event
  before_action :set_event, only: [:show, :edit, :update, :destroy, :live_event_admin]

  # GET /events
  # GET /events.json
  def index
    @title = "Events"
    @events = Event.where(user_id: current_user.id)
    @event = Event.new
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @set_items = @event.set_items
    @songs = current_user.songs.find(:all, conditions: ['id not in (?)', @set_items.map(&:song_id)])
    if @songs.empty?
      @songs = current_user.songs
    end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  def live_event
    @event = Event.find_by(code: params[:code])
    @set_items = @event.set_items.order("votes DESC")
  end

  def live_event_admin
    @set_items = @event.set_items.order("votes DESC")
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    @event.user_id = current_user.id
    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
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
      params.require(:event).permit(:venue, :date)
    end
end
