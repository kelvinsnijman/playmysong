class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  # GET /songs
  # GET /songs.json
  def index
    @title = "Song Library"
    @button_name = "Add Song"
    @songs = current_user.songs.order('artist, title')
    @song = Song.new
  end

  # GET /songs/1
  # GET /songs/1.json
  # def show
  # end

  # GET /songs/new
  # def new
  #   @song = Song.new
  # end

  # GET /songs/1/edit
  def edit
    @button_name = "Update Song"
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(song_params)

    @song.user_id = current_user.id

    respond_to do |format|
      if @song.save
        format.html { redirect_to songs_url, notice: 'Song was successfully created.' }
        format.json { render action: 'show', status: :created, location: @song }
      else
        format.html { redirect_to songs_url, notice: 'Please provide both Title and Artist.' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to songs_url, notice: 'Song was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = current_user.songs.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:title, :artist)
    end
end
