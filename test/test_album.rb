require 'helper'

class TestAlbum < Test::Unit::TestCase
  context "an album with territories" do
    setup do
      @album = MetaSpotify::Album.new('name' => 'test', 'availability' => { 'territories' => 'DE' })
      @worldwide_album = MetaSpotify::Album.new('name' => 'test', 'availability' => { 'territories' => 'worldwide' })
    end
    should "be available in DE" do
      assert @album.is_available_in?('DE')
    end
    should "not be available in UK" do
      assert @album.is_not_available_in?('UK')
    end
    should "be available anywhere" do
      assert @worldwide_album.is_available_in?('UK')
    end
  end
end