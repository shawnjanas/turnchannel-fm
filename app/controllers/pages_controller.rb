class PagesController < ApplicationController
  def landing
    @popular_tracks = Track.order("cached_plays DESC").limit(8)
    @new_tracks = Track.order("created_at DESC").limit(8)

    render :layout => false
  end
end
