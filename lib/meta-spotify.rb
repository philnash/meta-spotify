$:.unshift File.dirname(__FILE__)

require 'httparty'

module MetaSpotify
  
  API_VERSION = '1'
  
  class Base
    include HTTParty
    base_uri 'http://ws.spotify.com'
    
    attr_reader :name, :uri, :popularity
    
    def self.search(string, opts={})
      item_name = self.name.downcase.gsub(/^.*::/,'')
      query = {:q => string}
      query[:page] = opts[:page].to_s if opts.has_key? :page
      result = get("/search/#{API_VERSION}/#{item_name}", :query => query, :format => :xml)
      raise_errors(result)
      result = result[item_name+'s']
      items = []
      unless result[item_name].nil?
        if result[item_name].is_a? Array
          result[item_name].each do |item|
            items << self.new(item)
          end
        else
          items << self.new(result[item_name])
        end
      end
      return { (item_name+'s').to_sym => items,
               :query => {
                 :start_page => result["opensearch:Query"].try(:[], "startPage").nil? ? result["opensearch:Query"] : result["opensearch:Query"]["startPage"],
                 :role => result["opensearch:Query"].try(:[], "role").nil? ? result["opensearch:Query"] : result["opensearch:Query"]["role"],
                 :search_terms => result["opensearch:Query"].try(:[], "searchTerms").nil? ? result["opensearch:Query"] : result["opensearch:Query"]["searchTerms"]
               },
               :items_per_page => result["opensearch:itemsPerPage"],
               :start_index => result["opensearch:startIndex"],
               :total_results => result["opensearch:totalResults"]
              }
    end
    
    def self.lookup(uri, opts={})
      uri = uri.strip
      raise URIError.new("Spotify URI not in the correct syntax") unless self::URI_REGEX.match(uri)
      query = {:uri => uri}
      query[:extras] = opts[:extras] if opts.has_key? :extras
      result = get("/lookup/#{API_VERSION}/",:query => query, :format => :xml)
      raise_errors(result)
      result.each do |k,v|
        v.merge!({'href' => uri})
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
    
    private
    
    def self.raise_errors(response)
      case response.code
      when 400
        raise BadRequestError.new('400 - The request was not understood')
      when 403
        raise RateLimitError.new('403 - You are being rate limited, please wait 10 seconds before requesting again')
      when 404
        raise NotFoundError.new('404 - That resource could not be found.')
      when 406
        raise BadRequestError.new('406 - The requested format isn\'t available')
      when 500
        raise ServerError.new('500 - The server encountered an unexpected problem')
      when 503
        raise ServerError.new('503 - The API is temporarily unavailable')
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
  class RateLimitError < MetaSpotifyError; end
  class NotFoundError < MetaSpotifyError; end
  class BadRequestError < MetaSpotifyError; end
  class ServerError < MetaSpotifyError; end
end

require 'meta-spotify/artist'
require 'meta-spotify/track'
require 'meta-spotify/album'