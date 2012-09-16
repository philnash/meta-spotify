module MetaSpotify
  class Artist < MetaSpotify::Base
    
    def self.uri_regex
      /^spotify:artist:([A-Za-z0-9]+)$/
    end
    
    attr_reader :albums
    
    def initialize(hash)
      @name = hash['name']
      @popularity = hash['popularity'].to_f if hash.has_key? 'popularity'
      @uri = hash['href'] if hash.has_key? 'href'
      if hash.has_key? 'albums'
        @albums = []
        if hash['albums']['album'].is_a? Array
          hash['albums']['album'].each { |a| @albums << Album.new(a) }
        else
          @albums << Album.new(hash['albums']['album'])
        end
      end
    end

    def http_uri
      "http://open.spotify.com/artist/#{spotify_id}"
    end

  end
end