class TracksController < ApplicationController
  def index
    @popular_tracks = Track.order("cached_plays DESC").limit(10)
    @new_tracks = Track.order("created_at DESC").limit(10)
    @featured_tracks = []
    #@featured_tracks = [Track.find_by_id(3041), Track.find_by_id(2991), Track.find_by_id(2821), Track.find_by_id(2759), Track.find_by_id(2842), Track.find_by_id(2992)]
  end

  def discover
    @tag_name = params[:tag]

    tag = Tag.find_by_name(@tag_name)
    if tag
      @track = tag.tracks.order("RANDOM()").limit(1).first
    else
      @track = Track.order("RANDOM()").limit(1).first
    end

    redirect_to track_url(@track.permalink)
  end

  def search
    @q = params[:q]

    @tracks = Track.find(:all, :conditions => ['full_title LIKE ?', "%#{@q.downcase}%"], :limit => 21)
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find_by_permalink(params[:id])

    if @track
      @track.play
      @tracks_popular = Track.where(:tag_id => @track.tag.id).order('cached_plays DESC').limit(7)
      @tracks_rnd = Track.order("RANDOM()").limit(7)
      @tracks = (@tracks_popular + @tracks_rnd).shuffle
    else
      redirect_to root_path
    end
  end

  # GET /tracks/new
  # GET /tracks/new.json
  ##def new
  #  @track = Track.new

  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @track }
  #  end
  #end

  # GET /tracks/1/edit
  ##def edit
  #  @track = Track.find(params[:id])
  #end

  # POST /tracks
  # POST /tracks.json
  #def create
  #  @track = Track.new(params[:track])

  #  respond_to do |format|
  #    if @track.save
  #      format.html { redirect_to @track, notice: 'Track was successfully created.' }
  #      format.json { render json: @track, status: :created, location: @track }
  #    else
  #      format.html { render action: "new" }
  #      format.json { render json: @track.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # PUT /tracks/1
  # PUT /tracks/1.json
  #def update
  #  @track = Track.find(params[:id])

  #  respond_to do |format|
  #    if @track.update_attributes(params[:track])
  #      format.html { redirect_to @track, notice: 'Track was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @track.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  #def destroy
  #  @track = Track.find(params[:id])
  #  @track.destroy

  #  respond_to do |format|
  #    format.html { redirect_to tracks_url }
  #    format.json { head :no_content }
  #  end
  #end
end
