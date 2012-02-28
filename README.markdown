# meta-spotify

A ruby wrapper for the Spotify Metadata API. See here for usage: http://developer.spotify.com/en/metadata-api/overview/

Use of the API is subject to the Terms and Conditions: http://developer.spotify.com/en/metadata-api/terms-of-use/

## Installation

    gem install meta-spotify

## Usage

The API has two services for the three types of data, artists, albums and tracks:

### Lookup

To look up an artist, album or track, simply call:

    MetaSpotify::Artist.lookup(spotify_uri)
    MetaSpotify::Album.lookup(spotify_uri)
or

    MetaSpotify::Track.lookup(spotify_uri)

e.g.

    artist = MetaSpotify::Artist.lookup("spotify:artist:4YrKBkKSVeqDamzBPWVnSJ")
    #=> #<MetaSpotify::Artist:0x119764c @name="Basement Jaxx">

    artist.name
    #=> "Basement Jaxx"

You can also call lookup with the extras parameter, but only the acceptable extras will yield results, e.g.

    artist = MetaSpotify::Artist.lookup('spotify:artist:4YrKBkKSVeqDamzBPWVnSJ', :extras => 'album')

    artist.albums.first.name
    #=> "Jaxx Unreleased"

### Search

To search for an artist, album or track works the same way as lookup, simply call:

    MetaSpotify::Artist.search(search_term)
    MetaSpotify::Album.search(search_term)
or
    MetaSpotify::Track.search(search_term)

e.g.

    search = MetaSpotify::Artist.search('foo')

    search.artists.first.name
    #=> "Foo fighters"

For searches with many results, the result also contains details on pages and you can return page 2 like this:

    MetaSpotify::Artist.search('foo', :page => 2)

## Disclaimer

This is very new, so please let me know of any problems or anything that is missing.

## Copyright

Copyright (c) 2009 Phil Nash. See LICENSE for details.
