#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "meta-spotify"
    gem.summary = %Q{A ruby wrapper for the Spotify Metadata API}
    gem.email = "philnash@gmail.com"
    gem.homepage = "http://github.com/philnash/meta-spotify"
    gem.authors = ["Phil Nash"]
    gem.add_dependency 'httparty', "> 0.8"
    gem.add_development_dependency "shoulda", ">= 2.10.2"
    gem.add_development_dependency "fakeweb", ">= 1.2.4"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test
