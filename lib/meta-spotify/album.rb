module MetaSpotify
  class Album < MetaSpotify::Base

    def self.uri_regex
      /^spotify:album:([A-Za-z0-9]+)$/
    end

    attr_reader :released, :artists, :available_territories, :tracks, :upc,
                :musicbrainz_id, :musicbrainz_uri, :allmusic_id, :allmusic_uri

    def initialize(hash)
      @name = hash['name']
      @popularity = hash['popularity'].to_f if hash.has_key? 'popularity'
      if hash.has_key? 'artist'
        @artists = []
        if hash['artist'].is_a? Array
          hash['artist'].each { |a| @artists << Artist.new(a) }
        else
          @artists << Artist.new(hash['artist'])
        end
      end
      if hash.has_key? 'tracks'
        @tracks = []
        if hash['tracks']['track'].is_a? Array
          hash['tracks']['track'].each { |a| @tracks << Track.new(a) }
        else
          @tracks << Track.new(hash['tracks']['track'])
        end
      end
      @released = hash['released'] if hash.has_key? 'released'
      @uri = hash['href'] if hash.has_key? 'href'

      if hash['id'].is_a? Array

        hash['id'].each do |id|
          case id['type']
            when 'upc' then
              @upc = id['__content__']
            when 'mbid' then
              @musicbrainz_id = id['__content__']
              @musicbrainz_uri = id['href']
            when 'amgid' then
              @allmusic_id = id['__content__']
              @allmusic_uri = id['href']
          end
        end
      else
        @upc = hash['id']['__content__'] if hash.has_key? 'id'
      end

      @available_territories = if hash.has_key?('availability') && !hash['availability']['territories'].nil?
        hash['availability']['territories'].split(/\s+/).map {|t| t.downcase } || []
      else
        []
      end
    end

    def is_available_in?(territory)
      (@available_territories.include?('worldwide') || @available_territories.include?(territory.downcase))
    end

    def is_not_available_in?(territory)
      !is_available_in?(territory)
    end

    def http_uri
      "http://open.spotify.com/album/#{spotify_id}"
    end

  end
end
