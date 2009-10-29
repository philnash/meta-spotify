module MetaSpotify
  class Artist < MetaSpotify::Item
    attr_reader :uri
    def initialize(hash)
      @name = hash['name']
      @uri = hash['href'] if hash.has_key? 'href'
    end
  end
end