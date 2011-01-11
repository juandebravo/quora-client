require 'rubygems'
require 'rake'

# Specification var

$spec = Gem::Specification.new do |s| 
  s.name          = "quora-client"
  s.version       = "0.1"
  s.date          = Date.today.to_s

  s.author        = "Juan de Bravo"
  s.email         = "juandebravo@gmail.com"
  s.homepage      = "http://github.com/juandebravo/quora-client"

  s.platform      = Gem::Platform::RUBY
  s.summary       = "This GEM provides an easy way to access Quora Alpha API"
  s.description   = "This GEM provides an easy way to access Quora Alpha API"

  s.files         = FileList["{lib}/**/*"].to_a
  s.require_path  = "lib"

  s.test_files    = FileList["{test}/**/test_*.rb"].to_a

  s.has_rdoc      = true
  s.extra_rdoc_files = ["README.md", "LICENSE.LGPLv3"]

  # Dependencies
  s.add_dependency("json_pure" , ">= 1.4.3")

  s.add_development_dependency('test-unit', '2.1.0')

end

