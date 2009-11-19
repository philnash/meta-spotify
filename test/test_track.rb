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
      assert_kind_of MetaSpotify::Track, @results[:tracks].first
      assert_equal "Big Me", @results[:tracks].first.name
      assert_equal 1, @results[:query][:start_page]
      assert_equal 'request', @results[:query][:role]
      assert_equal "foo", @results[:query][:search_terms]
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