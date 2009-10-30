module MetaSpotify
  class Artist < MetaSpotify::Base
    
    URI_REGEX = /^spotify:artist:[A-Za-z0-9]+$/
    
    attr_reader :albums
    
    def initialize(hash)
      @name = hash['name']
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
  end
end