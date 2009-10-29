module MetaSpotify
  class Album < MetaSpotify::Base
    
    URI_REGEX = /^spotify:album:[A-Za-z0-9]+$/
    
    attr_reader :released, :artists, :available_territories
    
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
      @released = hash['released'] if hash.has_key? 'released'
      @uri = hash['href'] if hash.has_key? 'href'
      @available_territories = if hash.has_key?('availability') && hash['availability'].has_key?('territories')
        hash['availability']['territories'].split(/\s+/).map {|t| t.downcase } || []
      else
        []
      end
    end
    
    def is_available_in?(territory)
      return @available_territories.include?('worldwide') || @available_territories.include?(territory.downcase)
    end
    
    def is_not_available_in?(territory)
      return !is_available_in?(territory)
    end
    
  end
end