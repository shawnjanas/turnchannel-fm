ActiveAdmin.register Mix do
  index :as => :grid do |mix|
    div do
      link_to(auto_link(mix.name), admin_mix_path(mix.id))
    end
    if mix.remote
      div do
        link_to(image_tag(mix.cover_art), admin_mix_path(mix.id))
      end
    end
  end

  show do
    h3 mix.name
    div do
      image_tag(mix.cover_art)
    end
    div do
      mix.description
    end
    h3 "Tracks"
    mix.tracks.each do |track|
      div :style => 'float: left;width: 200px;height: 200px;' do
        div do
          link_to("#{auto_link(track.name)} (by) #{auto_link(track.artist)}", admin_track_path(track))
        end
        if track.remote
          div do
            link_to(image_tag(track.thumbnail), admin_track_path(track))
          end
        end
      end
    end
  end
end
