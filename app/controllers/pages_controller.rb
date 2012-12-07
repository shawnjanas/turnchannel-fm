class PagesController < ApplicationController
  def landing
    #@popular_tracks = Track.order("cached_plays DESC").limit(8)
    #@new_tracks = Track.order("created_at DESC").limit(8)

    render :layout => false
  end

  def channel
    cache_expire = 1.year
    response.headers["Pragma"] = "public"
    response.headers["Cache-Control"] = "max-age=#{cache_expire.to_i}"
    response.headers["Expires"] = (Time.now + cache_expire).strftime("%d %m %Y %H:%I:%S %Z")
    render :layout => false, :inline => "<script src='//connect.facebook.net/en_US/all.js#xfbml=1&appId=242371292554988'></script>"
  end
end
