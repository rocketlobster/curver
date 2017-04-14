Gem::Specification.new do |s|
  s.name          = 'curver'
  s.version       = '0.0.2'
  s.summary       = 'Curver'
  s.date          = '2017-01-01'
  s.description   = 'Convert your Adobe curves files to polynom functions'
  s.authors       = ['Théo CARRIVE']
  s.require_paths = %(lib)
  s.files         = ["lib/curver.rb"]
  s.license       = 'MIT'
  s.homepage      = 'https://github.com/rocketlobster/curver'

  s.add_runtime_dependency     'spliner', '~> 1.0'

  s.add_development_dependency 'rspec', '~> 3.5'

end