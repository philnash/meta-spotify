$:.unshift File.dirname(__FILE__)

require 'httparty'
require 'uri'

module MetaSpotify

  API_VERSION = '1'

  class Base
    include HTTParty
    base_uri 'http://ws.spotify.com'

    attr_reader :name, :uri, :popularity

    def self.uri_regex
      nil
    end

    def self.search(string, opts={})
      item_name = self.name.downcase.gsub(/^.*::/,'')
      query = {:q => string}
      query[:page] = opts[:page].to_s if opts.has_key? :page
      result = get("/search/#{API_VERSION}/#{item_name}",
        :query => query,
        :format => :xml,
        :query_string_normalizer => self.method(:normalize))
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
                 :start_page => result["Query"]["startPage"].to_i,
                 :role => result["Query"]["role"],
                 :search_terms => result["Query"]["searchTerms"]
               },
               :items_per_page => result["itemsPerPage"].to_i,
               :start_index => result["startIndex"].to_i,
               :total_results => result["totalResults"].to_i
              }
    end

    def self.lookup(uri, opts={})
      uri = uri.strip
      raise URIError.new("Spotify URI not in the correct syntax") unless uri_regex.match(uri)
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

    def spotify_id
      if uri
        uri[self.class.uri_regex, 1]
      else
        nil
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
      when 502
        raise ServerError.new('502 - The API internally received a bad response')
      when 503
        raise ServerError.new('503 - The API is temporarily unavailable')
      end
    end

    def self.normalize(query)
      stack = []
      query.each do |key, value|
        stack.push "#{key}=#{URI.encode_www_form_component value}"
      end
      stack.join("&")
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
require 'meta-spotify/version'
