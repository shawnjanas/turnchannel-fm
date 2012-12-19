class BeatPortClient
  def initialize
  end

  def tracks(genre_id, options = {:page => 1, :start_date => Date.today.to_s, :end_date => Date.today.to_s})
    query("/catalog/3/tracks?genreId=#{genre_id}&publishDateStart=#{options[:start_date]}&publishDateEnd=#{options[:end_date]}&perPage=150&page=#{options[:page]}")['results']
  end

  def most_popular(genre_id, options = {:per_page => 100})
    query("/catalog/3/most-popular/genre?id=#{genre_id}&perPage=#{options[:per_page]}")['results']
  end

  def artists(artist_ids)
    artist_ids = [artist_ids] unless artist_ids.is_a? Array
    query("/catalog/3/artists?ids=#{artist_ids.join(',')}&perPage=150")['results']
  end

  def labels(label_ids)
    label_ids = [label_ids] unless label_ids.is_a? Array
    query("/catalog/3/labels?ids=#{label_ids.join(',')}&perPage=150")['results']
  end

  def query(url)
    res = HTTParty.get(URI.escape("http://api.beatport.com#{url}"))
    res.parsed_response if res.parsed_response
  end
end
