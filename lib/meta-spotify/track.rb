module MetaSpotify
  class Track < MetaSpotify::Base
    
    URI_REGEX = /^spotify:track:[A-Za-z0-9]+$/
  
    attr_reader :album, :artists, :track_number, :length,
                :musicbrainz_id, :musicbrainz_uri, :allmusic_id, :allmusic_uri
    
    def initialize(hash)
      @name = hash['name']
      @uri = hash['href'] if hash.has_key? 'href'
      @popularity = hash['popularity'].to_f if hash.has_key? 'popularity'
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
      @length = hash['length'].to_f if hash.has_key? 'length'
      
      if hash['id'].is_a? Array
        
        hash['id'].each do |id|
          case id.attributes['type']
            when 'mbid' then
              @musicbrainz_id = id
              @musicbrainz_uri = id.attributes['href']
            when 'amgid' then 
              @allmusic_id = id
              @allmusic_uri = id.attributes['href']
          end
        end
      end
    end
  end
end