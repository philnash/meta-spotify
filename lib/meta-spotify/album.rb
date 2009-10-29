module MetaSpotify
  class Album < MetaSpotify::Item
    attr_reader :released, :artist, :uri, :available_territories
    def initialize(hash)
      @name = hash['name']
      @artist = Artist.new(hash['artist']) if hash.has_key? 'artist'
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