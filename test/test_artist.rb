require 'helper'

class TestArtist < Test::Unit::TestCase
  context "searching for an artist name" do
    context "many results" do
      setup do
        FakeWeb.register_uri(:get,
                             "http://ws.spotify.com/search/1/artist?q=foo",
                             :body => fixture_file("artist_search.xml"))
        @results = MetaSpotify::Artist.search('foo')
      end
      should "return a list of results and search meta" do
        assert_kind_of Array, @results[:artists]

        artist = @results[:artists].first
        assert_kind_of MetaSpotify::Artist, artist
        assert_equal "Foo Fighters", artist.name
        assert_equal 0.89217, artist.popularity
        assert_equal '7jy3rLJdDQY21OgRLCZ9sD', artist.spotify_id
        assert_equal 'http://open.spotify.com/artist/7jy3rLJdDQY21OgRLCZ9sD', artist.http_uri

        query = @results[:query]
        assert_equal 1, query[:start_page]
        assert_equal 'request', query[:role]
        assert_equal "foo", query[:search_terms]
        assert_equal 100, @results[:items_per_page]
        assert_equal 0, @results[:start_index]
        assert_equal 9, @results[:total_results]
      end
    end
    context "a single result" do
      setup do
        FakeWeb.register_uri(:get,
                             "http://ws.spotify.com/search/1/artist?q=1200+Micrograms",
                             :body => fixture_file("artist_search_one_result.xml"))
        @results = MetaSpotify::Artist.search('1200 Micrograms')
      end
      should "still return a list of results, for consistency" do
        assert_kind_of Array, @results[:artists]
        assert_equal 1, @results[:artists].length

        artist = @results[:artists].first
        assert_kind_of MetaSpotify::Artist, artist
        assert_equal "1200 Micrograms", artist.name
        assert_equal 0.48196, artist.popularity
        assert_equal '3AUNfvctGVnEOGZiAh0JIK', artist.spotify_id
        assert_equal 'http://open.spotify.com/artist/3AUNfvctGVnEOGZiAh0JIK', artist.http_uri

        query = @results[:query]
        assert_equal 1, query[:start_page]
        assert_equal 'request', query[:role]
        assert_equal "1200 Micrograms", query[:search_terms]
        assert_equal 100, @results[:items_per_page]
        assert_equal 0, @results[:start_index]
        assert_equal 1, @results[:total_results]
      end
    end
  end

  context "looking up an artist" do
    setup do
      FakeWeb.register_uri(:get,
                           "http://ws.spotify.com/lookup/1/?uri=#{CGI.escape(ARTIST_URI)}",
                           :body => fixture_file("artist.xml"))
      @result = MetaSpotify::Artist.lookup(ARTIST_URI)
    end
    should "fetch an artist and return an artist object" do
      assert_kind_of MetaSpotify::Artist, @result
      assert_equal "Basement Jaxx", @result.name
      assert_equal ARTIST_URI, @result.uri
    end
    should "fail trying to look up an album" do
      assert_raises MetaSpotify::URIError do
        MetaSpotify::Artist.lookup(ALBUM_URI)
      end
    end
  end

  context "looking up an artist with detailed album information" do
    setup do
      FakeWeb.register_uri(:get,
                           "http://ws.spotify.com/lookup/1/?extras=albumdetail&uri=#{CGI.escape(ARTIST_URI)}",
                           :body => fixture_file("artist_with_albumdetail.xml"))
      @result = MetaSpotify::Artist.lookup(ARTIST_URI, :extras => 'albumdetail')
    end
    should "fetch an artist and return an artist object with detailed album information" do
      assert_kind_of MetaSpotify::Artist, @result
      assert_kind_of MetaSpotify::Album, @result.albums.first
      assert_equal "Jaxx Unreleased", @result.albums.first.name
    end
  end
end