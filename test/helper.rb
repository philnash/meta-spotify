require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'meta-spotify'
require 'fakeweb'
require 'cgi'

FakeWeb.allow_net_connect = false

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

TRACK_URI  = "spotify:track:3zBhJBEbDD4a4SO1EaEiBP"
ARTIST_URI = "spotify:artist:4YrKBkKSVeqDamzBPWVnSJ"
ALBUM_URI  = "spotify:album:6G9fHYDCoyEErUkHrFYfs4"
ALBUM_ONE_UPC_URI = "spotify:album:3MiiF9utmtGnLVITgl0JP7"

class Test::Unit::TestCase
end
