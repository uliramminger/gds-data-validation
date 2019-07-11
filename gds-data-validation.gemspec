require_relative 'lib/gds-data-validation/version'

Gem::Specification.new do |s|

  s.name        = 'gds-data-validation'
  s.version     = GdsDataValidation::VERSION
  s.summary     = 'A data validation library providing a rule-based schema definition language'
  s.authors     = [ 'Uli Ramminger' ]
  s.email       = 'uli@urasepandia.de'
  s.homepage    = 'https://urasepandia.de/gds-data-validation.html'
  s.files       = %w(CHANGELOG.md MIT-LICENSE Rakefile README.md) + Dir["{lib}/**/*"]
  s.license     = 'MIT'

  s.description = <<-EOS
A data validation library providing a rule-based schema definition language.
For checking (incoming) data against a specified schema definition.
GDS stands for General Data Structure.
EOS

  s.add_dependency 'treetop', '~> 1.6', '>= 1.6.9'

  s.add_development_dependency 'rake', '~> 12'
  s.add_development_dependency 'minitest', '~> 5.1'
  s.add_development_dependency 'gdstruct', '~> 0.8', '>= 0.8.2'

end
