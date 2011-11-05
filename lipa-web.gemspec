lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'lipa/web/version'

Gem::Specification.new do |gem|
  gem.name = "lipa-rest"
  gem.version = Lipa::Web::VERSION
  gem.author  = 'A.Timin'
  gem.email = "atimin@gmail.com"
  gem.homepage = "http://lipa.flipback.net"
  gem.summary = "Web access to Lipa"
  gem.files = Dir['lib/**/*.rb','spec/*.rb', 'examples/**/*.rb','Rakefile']
  gem.rdoc_options = ["--title", "Lipa", "--inline-source", "--main", "README.md"]
  gem.extra_rdoc_files = ["README.md", "NEWS.md"]

  gem.add_dependency 'lipa', '~> 1.0.0'
  gem.add_dependency 'rack', '~> 1.3.5'

  gem.add_development_dependency 'rake', '>=0.9.2.2'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec', '>= 2.7.0'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'rdiscount'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'notes'
  gem.add_development_dependency 'rack-test', '~> 0.6.1'
  gem.add_development_dependency 'guard-rspec'
end
