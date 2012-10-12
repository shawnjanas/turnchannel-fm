class CreateCategoriesTracks < ActiveRecord::Migration
  def change
    create_table :categories_tracks, :id => false do |t|
      t.integer :category_id
      t.integer :track_id

      t.timestamps
    end

    add_index :categories_tracks, :category_id
    add_index :categories_tracks, :track_id

    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/bar9/bar9-midnight', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/nickraymondg/two-door-cinema-club-what-you', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/labrat/m-o-u-break-your-neck-labrat-1', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/hollywoodundead/i-dont-wanna-die-borgore', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/caiosilvaa/mord-fustang-lick-the-rainbow', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/nickraymondg/skrillex-vs-feed-me-the-blood', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/skrillex/scary-monsters-and-nice-1', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/mostaddictiverecords/tristam-jawn-mastered', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/constatijn/feed-me-pink-lady-original-mix', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/electro/nancy-sinatra-bang-bang', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/iamvoltorb/tristam-rogue-rewel-free', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/subfocus/falling-down-ft-kenzie-may', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dirtyloud/porter-robinson-feat-amba', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/thisistrapmusic/bassnectar-vava-voom-remix', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dubstep/brometheus-by-bare-ft', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dubstep/temptation-by-zander-bleck', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/cenob1te/onslaught', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/kristinaccorsi/everything-you-need', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dubstep-collective/please-mr-postman-cragga-dubstep-remix-the-marvelletes', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dubstep-collective/one-bar9-remix-sky-ferreira', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/knifepartyinc/labrinth-last-time-knife-party', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/rocketpimp/rocket-pimp-grim-reaper', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/mutrix/mutrix-o', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/pra2music/zedd-spectrum-pra2-dubstep', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/trampboat/virtu-arsenal-trampboat-remix', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/skrillex/birdy-nam-nam-goin-in-skrillex', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dubstep/cant-control-myself-by-krewella-candylandremix-dubstepnet-exclusive', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dubstep/elements-by-lindsey-stirling', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dubstep/moonrise-by-tbma-dirt-monkey', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dubstep/inndia-by-inna-forknknife', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dubstep/buckshot-by-spl-triage', :user_id => 1

    Category.all[1].tracks.create :source => 0, :remote_url => 'http://soundcloud.com/maxburnside/calling-lose-my-mind-sebastian', :user_id => 1
    Category.all[1].tracks.create :source => 0, :remote_url => 'http://soundcloud.com/bassjackers/enrique-iglesias-finally-found', :user_id => 1
    Category.all[1].tracks.create :source => 0, :remote_url => 'http://soundcloud.com/bassjackers/spencer-hill-surrender', :user_id => 1
    Category.all[1].tracks.create :source => 0, :remote_url => 'http://soundcloud.com/bassjackers/tocadisco-that-miami-track', :user_id => 1
    Category.all[1].tracks.create :source => 0, :remote_url => 'http://soundcloud.com/bassjackers/the-wanted-glad-you-came', :user_id => 1
    Category.all[1].tracks.create :source => 0, :remote_url => 'http://soundcloud.com/bassjackers/dada-life-whitenoise-redmeat-bassjackers-remix', :user_id => 1
    Category.all[1].tracks.create :source => 0, :remote_url => 'http://soundcloud.com/peacetreaty/dada-life-white-noise-red-meat-peacetreaty-remix-preview-cip', :user_id => 1
    Category.all[1].tracks.create :source => 0, :remote_url => 'http://soundcloud.com/dirty-electro-mix-1/dirty-electro-mix-2012-electro', :user_id => 1
  end
end
