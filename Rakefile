require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "meta-spotify"
    gem.summary = %Q{A ruby wrapper for the Spotify Metadata API}
    gem.email = "philnash@gmail.com"
    gem.homepage = "http://github.com/philnash/meta-spotify"
    gem.authors = ["Phil Nash"]
    gem.add_dependency 'httparty', "> 0.8"
    gem.add_dependency 'crack'
    gem.add_development_dependency "shoulda", ">= 2.10.2"
    gem.add_development_dependency "fakeweb", ">= 1.2.4"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "meta-spotify #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
