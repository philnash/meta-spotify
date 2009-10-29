module MetaSpotify
  class Artist < MetaSpotify::Base
    
    URI_REGEX = /^spotify:artist:[A-Za-z0-9]+$/
    
    def initialize(hash)
      @name = hash['name']
      @uri = hash['href'] if hash.has_key? 'href'
    end
  end
end