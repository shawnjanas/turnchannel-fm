class TracksController < ApplicationController
  def index
    @tracks = Track.all
    #@popular_tracks = Track.order("plays_count DESC").limit(10)
    #@new_tracks = Track.order("plays_count DESC").limit(10)
    #@featured_tracks = []
    #@featured_tracks = [Track.find_by_id(3041), Track.find_by_id(2991), Track.find_by_id(2821), Track.find_by_id(2759), Track.find_by_id(2842), Track.find_by_id(2992), Track.find_by_id(3050), Track.find_by_id(2970)]
  end

  def discover
    @tag_name = params[:tag]

    tag = Genre.find_by_name(@tag_name)
    if tag
      @track = tag.tracks.order("RANDOM()").limit(1).first
    else
      @track = Track.order("RANDOM()").limit(1).first
    end

    redirect_to track_url(@track.permalink)
  end

  def search
    @q = params[:q]

    @tracks = Track.find(:all, :conditions => ['searchable_meta LIKE ?', "%#{@q.downcase}%"], :limit => 21)
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find_by_permalink(params[:id])

    if @track
      @track.play
      @tracks_popular = Track.where(:genre_id => @track.genres.first.id).order('plays_count DESC').limit(7)
      @tracks_rnd = Track.order("RANDOM()").limit(7)
      @tracks = (@tracks_popular + @tracks_rnd).shuffle
    else
      redirect_to root_path
    end
  end
end
