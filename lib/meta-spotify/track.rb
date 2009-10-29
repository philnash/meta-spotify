module MetaSpotify
  class Track < MetaSpotify::Item
    attr_reader :album, :artist, :track_number, :length, :popularity
    def initialize(hash)
      @name = hash['name']
      @artist = Artist.new(hash['artist']) if hash.has_key? 'artist'
      @album = Album.new(hash['album']) if hash.has_key? 'album'
      @track_number = hash['track_number'].to_i if hash.has_key? 'track_number'
      @popularity = hash['popularity'].to_f if hash.has_key? 'popularity'
      @length = hash['length'].to_f if hash.has_key? 'length'
    end
  end
end