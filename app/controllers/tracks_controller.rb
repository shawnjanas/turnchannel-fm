class TracksController < ApplicationController
  def index
    @genre = 'all_genres'
    @sort = 'recently_added'
    @tracks = Track.order("created_at DESC")
  end

  def list
    @genre = params[:genre] || 'all_genres'
    @sort = params[:sort] || 'recently_added'
    @sort_name = 'Recently_Added'

    if @genre == 'all_genres'
      if @sort == 'plays'
        @tracks = Track.order("cached_plays DESC")
      else
        @tracks = Track.order("created_at DESC")
      end
    else
      tag = Tag.find_by_name(@genre)
      if tag
        if @sort == 'plays'
          @tracks = tag.tracks.order("cached_plays DESC")
        else
          @tracks = tag.tracks.order("created_at DESC")
        end
      else
        if @sort == 'plays'
          @tracks = Track.order("cached_plays DESC")
        else
          @tracks = Track.order("created_at DESC")
        end
      end
    end

    render :index
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find_by_permalink(params[:id])
    @track.play

    @tracks = @track.tag.tracks.shuffle

    #if params[:v].blank?
    #  respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @track }
    # end
    #else
    #  render :layout => false
    #end
  end

  # GET /tracks/new
  # GET /tracks/new.json
  def new
    @track = Track.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @track }
    end
  end

  # GET /tracks/1/edit
  def edit
    @track = Track.find(params[:id])
  end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = Track.new(params[:track])

    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render json: @track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tracks/1
  # PUT /tracks/1.json
  def update
    @track = Track.find(params[:id])

    respond_to do |format|
      if @track.update_attributes(params[:track])
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track = Track.find(params[:id])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :no_content }
    end
  end
end
