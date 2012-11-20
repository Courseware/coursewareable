$:.push File.expand_path('../lib', __FILE__)

require "coursewareable/version"

Gem::Specification.new do |s|
  s.name        = 'coursewareable'
  s.version     = Coursewareable::VERSION
  s.authors     = ['Stas Suscov']
  s.email       = ['stas@coursewa.re']
  s.homepage    = 'http://coursewa.re'
  s.summary     = 'Courseware Core Engine'
  s.description = 'Courseware back-end business logic and relevant tests.'
  s.files = Dir['{app,config,db,lib}/**/*'] + [
    'LICENSE', 'Rakefile', 'README.rdoc'
  ]

  s.add_dependency 'rails'

  s.add_development_dependency 'sqlite3'
end
