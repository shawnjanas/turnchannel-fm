FactoryGirl.define do
  factory :track do
    id 1
    title "love and lies"
    full_title "love and lies by dvbbs (tyr remix)"
    artist "dvbbs"
    sc_url "http://soundcloud.com/dubstep/love-and-lies-by-dvbbs-tyr-remix"
    artwork_url "http://i1.sndcdn.com/artworks-000037013307-yb1ppb-large.jpg?923db0b"
    purchase_url 'http://beatport.com'
    description "This is the description"
    duration 243797
    label_name 'Ultra Records'
    user
    tag
    plays 0
    created_at DateTime.parse("2012-12-26 21:01:18")
    updated_at DateTime.parse("2012-12-26 21:48:24")
    permalink "love-and-lies-by-dvbbs-tyr-remix"
    weekly_plays 123
    daily_plays 57
  end
end

