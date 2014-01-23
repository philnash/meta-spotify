module MetaSpotify
  class Track < MetaSpotify::Base

    def self.uri_regex
      /^spotify:track:([A-Za-z0-9]+)$/
    end

    attr_reader :album, :artists, :track_number, :length,
                :musicbrainz_id, :musicbrainz_uri, :allmusic_id, :allmusic_uri,
                :isrc_id

    def initialize(hash)
      @name = hash['name']
      @uri = hash['href'] if hash.has_key? 'href'
      @popularity = hash['popularity'].to_f if hash.has_key? 'popularity'

      if hash.has_key? 'artist'
        @artists = []
        if hash['artist'].is_a? Array
          hash['artist'].each { |a| @artists << Artist.new(a) }
        else
          @artists << Artist.new(hash['artist'])
        end
      end

      @album = Album.new(hash['album']) if hash.has_key? 'album'
      @track_number = hash['track_number'].to_i if hash.has_key? 'track_number'
      @length = hash['length'].to_f if hash.has_key? 'length'

      case hash['id']
      when Hash
        node_to_id hash['id']
      when Array
        hash['id'].each do |id|
          node_to_id id
        end
      end
    end

    def http_uri
      "http://open.spotify.com/track/#{spotify_id}"
    end

    private
    def node_to_id(node)
      case node['type']
        when 'mbid' then
          @musicbrainz_id = node['__content__']
          @musicbrainz_uri = node['href']
        when 'amgid' then
          @allmusic_id = node
          @allmusic_uri = node['href']
        when 'isrc' then
          @isrc_id = node['__content__']
      end
    end
  end
end
