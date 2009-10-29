require 'rubygems'

$:.unshift File.dirname(__FILE__)

require 'httparty'

module MetaSpotify
  
  class Base
    include HTTParty
    API_URI = 'ws.spotify.com'
    API_VERSION = '1'
  end
  
  class Item
    attr_reader :name
  end
  
  class MetaSpotifyError < StandardError
    attr_reader :data
    
    def initialize(data)
      @data = data
      super
    end
  end
  class URIError < MetaSpotifyError; end
end

require 'meta-spotify/lookup'
require 'meta-spotify/artist'
require 'meta-spotify/track'
require 'meta-spotify/album'