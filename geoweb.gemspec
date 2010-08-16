spec = Gem::Specification.new do |s| 
  s.name = "geoweb"
  s.version = "0.0.5"
  s.author = "Reinaldo de Souza Junior"
  s.email = "juniorz@gmail.com"
  s.homepage = "http://reinaldojunior.net"
  s.summary = "GeoWeb is a Ruby Geographic Web Library"

#  s.required_ruby_version = '>= 1.8.7'

  require 'rake'
  s.files = FileList["{bin,lib,spec}/**/*"].to_a

  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
end
