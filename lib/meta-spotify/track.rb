module MetaSpotify
  class Track < MetaSpotify::Base
    
    URI_REGEX = /^spotify:track:[A-Za-z0-9]+$/
  
    attr_reader :album, :artists, :track_number, :length, :popularity
    
    def initialize(hash)
      @name = hash['name']
      if hash.has_key? 'artist'
        @artists = []
        if hash['artist'].is_a? Array
          hash['artist'].each { |a| @artists << Artist.new(a) }
        else
          @artists << Artist.new(hash['artist'])
        end
      end
      @album = Album.new(hash['album']) if hash.has_key? 'album'
      @track_number = hash['track_number'].to_i if hash.has_key? 'track_number'
      @popularity = hash['popularity'].to_f if hash.has_key? 'popularity'
      @length = hash['length'].to_f if hash.has_key? 'length'
    end
  end
end