ActiveAdmin.register Track do
  index :as => :grid do |track|
    div do
      link_to(auto_link(track.full_title), admin_track_path(track.id))
    end
    if track.artwork_url
      div do
        link_to(image_tag(track.artwork_url), admin_track_path(track.id))
      end
    end
  end
end
