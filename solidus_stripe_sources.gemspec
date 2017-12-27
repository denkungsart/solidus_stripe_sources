$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "solidus_stripe_sources/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "solidus_stripe_sources"
  s.version     = SolidusStripeSources::VERSION
  s.authors     = ["Evgeny Sugakov"]
  s.email       = ["shiroginne@gmail.com"]
  s.homepage    = "https://github.com/denkungsart/solidus_stripe_sources"
  s.summary     = "Stripe Sources support for Solidus."
  s.description = "Support Stripe's altrnative payment methods for Solidus: SEPA Direct Debit, Sofort, Alipay ant other."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "solidus", [">= 2.2.0", "< 2.3"]
  s.add_dependency "solidus_support"
  s.add_dependency "stripe"
  s.add_dependency "activemerchant", ">= 1.71.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "pry"
  s.add_development_dependency "rails", [">= 5.0.0", "< 5.1.0"]
  s.add_development_dependency "webmock"
  s.add_development_dependency "vcr"
end
