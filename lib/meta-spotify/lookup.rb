module MetaSpotify
  class Lookup < MetaSpotify::Base
    base_uri "#{API_URI}/lookup/#{API_VERSION}"
    
    attr_reader :uri

    URI_REGEX = /^spotify:(artist|track|album):\w+$/
    
    def initialize(uri)
      @uri = uri.strip
      raise URIError.new("Spotify URI not in the correct syntacx") unless URI_REGEX.match(@uri)
    end
    
    def fetch
      result = self.class.get('/',:query => {:uri => @uri}, :format => :xml)
      result.each do |k,v|
        case k
        when "artist"
          return Artist.new(v)
        when "album"
          return Album.new(v)
        when "track"
          return Track.new(v)
        end
      end
    end
    
  end
end