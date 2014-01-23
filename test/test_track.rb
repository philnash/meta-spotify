require 'helper'

class TestTrack < Test::Unit::TestCase
  context "searching for a track" do
    setup do
      FakeWeb.register_uri(:get,
                           "http://ws.spotify.com/search/1/track?q=foo",
                           :body => fixture_file("track_search.xml"))
      @results = MetaSpotify::Track.search('foo')
    end
    should "return a list of results and search meta" do
      assert_kind_of Array, @results[:tracks]

      track = @results[:tracks].first
      assert_kind_of MetaSpotify::Track, track
      assert_equal "Big Me", track.name
      assert_equal '6pb5BBnIM5IM7R1cqag6rE', track.spotify_id
      assert_equal 'http://open.spotify.com/track/6pb5BBnIM5IM7R1cqag6rE', track.http_uri

      query = @results[:query]
      assert_equal 1, query[:start_page]
      assert_equal 'request', query[:role]
      assert_equal "foo", query[:search_terms]
      assert_equal 100, @results[:items_per_page]
      assert_equal 0, @results[:start_index]
      assert_equal 486, @results[:total_results]
    end
  end
  context "paginating search" do
    setup do
      FakeWeb.register_uri(:get,
                           "http://ws.spotify.com/search/1/track?q=foo&page=2",
                           :body => fixture_file("track_search_page_2.xml"))
      @results = MetaSpotify::Track.search('foo', :page => 2)
    end
    should "return page 2's results" do
      assert_equal 2, @results[:query][:start_page]
      assert_equal 100, @results[:start_index]
    end
  end
  context "looking up a track" do
    setup do
      FakeWeb.register_uri(:get,
                           "http://ws.spotify.com/lookup/1/?uri=#{CGI.escape TRACK_URI}",
                           :body => fixture_file("track.xml"))
      @result = MetaSpotify::Track.lookup(TRACK_URI)
    end
    should "fetch a track and return a track object" do
      assert_kind_of MetaSpotify::Track, @result
      assert_equal "Rendez-vu", @result.name
      assert_equal 1, @result.track_number
      assert_equal 345, @result.length
      assert_equal 0.51368, @result.popularity
      assert_equal TRACK_URI, @result.uri
      assert_equal "e230c541-78fb-4d08-99c9-ebcb111d7058", @result.musicbrainz_id
      assert_equal "http://www.allmusic.com/cg/amg.dll?p=amg&sql=33:jifqxvlhldde", @result.allmusic_uri
      assert_equal '3zBhJBEbDD4a4SO1EaEiBP', @result.spotify_id
      assert_equal 'GBBKS9900090', @result.isrc_id
      assert_equal 'http://open.spotify.com/track/3zBhJBEbDD4a4SO1EaEiBP', @result.http_uri
    end
    should "create an album object for that track" do
      assert_kind_of MetaSpotify::Album, @result.album
      assert_equal "Remedy", @result.album.name
      assert_equal "spotify:album:6G9fHYDCoyEErUkHrFYfs4", @result.album.uri
    end
    should "create an artist object for that album" do
      assert_kind_of Array, @result.artists
      assert_kind_of MetaSpotify::Artist, @result.artists.first
      assert_equal "Basement Jaxx", @result.artists.first.name
      assert_equal "spotify:artist:4YrKBkKSVeqDamzBPWVnSJ", @result.artists.first.uri
    end
    should "fail trying to look up an artist" do
      assert_raises MetaSpotify::URIError do
        MetaSpotify::Track.lookup(ARTIST_URI)
      end
    end
  end
end