ActiveAdmin.register Track do
  index :as => :grid do |track|
    div do
      link_to("#{auto_link(track.name)} (by) #{auto_link(track.artist)}", admin_track_path(track))
    end
    if track.remote
      div do
        link_to(image_tag(track.thumbnail), admin_track_path(track))
      end
    end
  end

  show do
    h3 "#{track.name} by #{track.artist}"
    div do
      if track.remote
        raw '<object width="560" height="315"><param name="movie" value="http://www.youtube.com/v/UJtB55MaoD0?version=3&amp;hl=en_US&amp;rel=0"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/UJtB55MaoD0?version=3&amp;hl=en_US&amp;rel=0" type="application/x-shockwave-flash" width="560" height="315" allowscriptaccess="always" allowfullscreen="true"></embed></object>'.gsub('UJtB55MaoD0', track.remote)
      end
    end
    div do
      image_tag(track.thumbnail)
    end
    div do
      track.duration
    end
    h3 "Mixes"
    track.mixes.each do |mix|
      div do
        link_to(mix.name, admin_mix_path(mix))
      end
    end
  end
end
