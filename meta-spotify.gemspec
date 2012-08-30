# -*- encoding: utf-8 -*-
require File.expand_path('../lib/meta-spotify/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "meta-spotify"
  gem.authors       = ["Phil Nash"]
  gem.email         = ["philnash@gmail.com"]
  gem.description   = %q{A ruby wrapper for the Spotify Metadata API.
                         See https://developer.spotify.com/technologies/web-api/
                         for API documentation.}
  gem.summary       = %q{A ruby wrapper for the Spotify Metadata API}
  gem.homepage      = "http://github.com/philnash/meta-spotify"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = MetaSpotify::VERSION

  gem.add_dependency 'httparty', '> 0.8'

  gem.add_development_dependency 'shoulda', '>= 2.10.2'
  gem.add_development_dependency 'fakeweb', '>= 1.2.4'

end

