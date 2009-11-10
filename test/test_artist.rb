require 'helper'

class TestArtist < Test::Unit::TestCase
  context "searching for an artist name" do
    setup do
      FakeWeb.register_uri(:get,
                           "http://ws.spotify.com/search/1/artist?q=foo",
                           :body => fixture_file("artist_search.xml"))
      @results = MetaSpotify::Artist.search('foo')
    end
    should "return a list of results and search meta" do
      assert_kind_of Array, @results[:artists]
      assert_kind_of MetaSpotify::Artist, @results[:artists].first
      assert_equal "Foo Fighters", @results[:artists].first.name
      assert_equal 1, @results[:query][:start_page]
      assert_equal 'request', @results[:query][:role]
      assert_equal "foo", @results[:query][:search_terms]
      assert_equal 100, @results[:items_per_page]
      assert_equal 0, @results[:start_index]
      assert_equal 9, @results[:total_results]
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