require 'rubygems'

$:.unshift File.dirname(__FILE__)

require 'httparty'

module MetaSpotify
  
  API_VERSION = '1'
  
  class Base
    include HTTParty
    base_uri 'http://ws.spotify.com'
    
    attr_reader :name, :uri
    
    def self.search(string, opts={})
      item_name = self.name.downcase.gsub(/^.*::/,'')
      query = {:q => string}
      query[:page] = opts[:page].to_s if opts.has_key? :page
      result = get("/search/#{API_VERSION}/#{item_name}", :query => query, :format => :xml)
      result = result[item_name+'s']
      items = []
      result[item_name].each do |item|
        items << self.new(item)
      end
      return { (item_name+'s').to_sym => items,
               :query => {
                 :start_page => result["opensearch:Query"]["startPage"].to_i,
                 :role => result["opensearch:Query"]["role"],
                 :search_terms => result["opensearch:Query"]["searchTerms"]
               },
               :items_per_page => result["opensearch:itemsPerPage"].to_i,
               :start_index => result["opensearch:startIndex"].to_i,
               :total_results => result["opensearch:totalResults"].to_i
              }
    end
    
    def self.lookup(uri)
      uri = uri.strip
      raise URIError.new("Spotify URI not in the correct syntax") unless self::URI_REGEX.match(uri)
      result = get("/lookup/#{API_VERSION}",:query => {:uri => uri}, :format => :xml)
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
  
  class MetaSpotifyError < StandardError
    attr_reader :data
    
    def initialize(data)
      @data = data
      super
    end
  end
  class URIError < MetaSpotifyError; end
end

require 'meta-spotify/artist'
require 'meta-spotify/track'
require 'meta-spotify/album'