class TracksController < ApplicationController
  before_filter :authenticate_user!, :only => [:toggle_like, :toggle_dislike]

  def index
    @popular_tracks = Track.order("cached_plays DESC").limit(10)
    @new_tracks = Track.order("created_at DESC").limit(10)
    #@featured_tracks = Track.order("created_at DESC").limit(8)
    @featured_tracks = [Track.find_by_id(3041), Track.find_by_id(2991), Track.find_by_id(2821), Track.find_by_id(2759), Track.find_by_id(2842), Track.find_by_id(2992), Track.find_by_id(3050), Track.find_by_id(2970)]
    session[:auto_play] = true
  end

  def discover
    @tag_name = params[:tag]

    tag = Tag.find_by_name(@tag_name)
    if tag
      @track = tag.tracks.order("RANDOM()").limit(1).first
    else
      @track = Track.order("RANDOM()").limit(1).first
    end

    session[:auto_play] = true

    redirect_to track_url(@track.permalink)
  end

  def search
    session[:auto_play] = true

    unless params[:q].blank?
      @q = params[:q]

      @tracks = Track.find(:all, :conditions => ['full_title LIKE ?', "%#{@q.downcase}%"], :limit => 21)
    else
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to root_path
      end
    end
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find_by_permalink(params[:id])
    @tags = Tag.all

    redis = Resque.redis

    unless @track.blank?
      @tracks = Track.order("RANDOM()").limit(15)
      @track.play

      unless session[:play_queue].blank?
        records = Track.find(session[:play_queue]).group_by(&:id)
        @play_queue = session[:play_queue].map { |id| records[id].first }

        unless @play_queue.include? @track
          @play_queue = [@track] + Track.find(redis.lrange("tag:#{@track.tag.name}:top40",0,-1)).shuffle[0..6]
          session[:play_queue] = @play_queue.map{|z|z.id}
        end
      else
        @play_queue = [@track] + Track.find(redis.lrange("tag:#{@track.tag.name}:top40",0,-1)).shuffle[0..6]
        session[:play_queue] = @play_queue.map{|z|z.id}
      end

      ti = @play_queue.index(@track) + 1

      if ti < 8
        @next_track = @play_queue[ti]
      else
        @next_track = Track.find(redis.lrange("tag:#{@track.tag.name}:top40",0,-1)).shuffle.first.permalink
      end

      @auto_play = 'false'
      @auto_play = 'true' if session[:auto_play]
      session[:auto_play] = true
    else
      redirect_to root_path
    end
  end

  def toggle_like
    @track = Track.find_by_id(params[:id])
    state = @track.toggle_like(current_user)

    render :json => {:state => state}
  end

  def toggle_dislike
    @track = Track.find_by_id(params[:id])
    state = @track.toggle_dislike(current_user)

    render :json => {:state => state}
  end

  def channel
    cache_expire = 1.year
    response.headers["Pragma"] = "public"
    response.headers["Cache-Control"] = "max-age=#{cache_expire.to_i}"
    response.headers["Expires"] = (Time.now + cache_expire).strftime("%d %m %Y %H:%I:%S %Z")
    render :layout => false, :inline => "<script src='//connect.facebook.net/en_US/all.js#xfbml=1&appId=242371292554988'></script>"
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
