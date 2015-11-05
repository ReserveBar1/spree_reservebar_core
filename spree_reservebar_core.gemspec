Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_reservebar_core'
  s.version     = '0.10.6'
  s.summary     = 'Spree Commerce Extensions for reservebar.com'

  s.author        = 'Thomas Boltze'
  s.email         = 'thomas.boltze@gmail.com'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = false

  s.add_dependency 'spree_core', '1.0.3'
  s.add_dependency 'spree_auth', '1.0.3'
  s.add_dependency 'spree_api', '1.0.3'
  s.add_dependency 'spree_promo', '1.0.3'
  s.add_dependency 'httparty', '0.11.0'
end
