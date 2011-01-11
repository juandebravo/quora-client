require 'rubygems'
require 'rake'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/clean'

load 'quora-client.gemspec'


task :default => [:test_units]

Rake::RDocTask.new do |rd|
  rd.main = "README.md"
  rd.rdoc_files.include("README.md", "lib/**/*.rb")
  rd.title = 'Quora Client'
end

desc "Quora Client unit tests"
Rake::TestTask.new("test_units") { |t|
  t.pattern = 'test/test_*.rb'  # Search any file matching test/test_*.rb
  t.verbose = true
  t.warning = true
}

Rake::GemPackageTask.new($spec) do |pkg| 
  pkg.need_tar = true
end 

