begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SolidusStripeSources'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'bundler/gem_tasks'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'spree/testing_support/extension_rake'

unless Dir['spec/dummy'].empty?
  APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
  load 'rails/tasks/engine.rake'
end

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(spec: 'app:db:test:prepare')

task default: :spec

task :first_run do
  if Dir['spec/dummy'].empty?
    Rake::Task[:test_app].invoke
    Dir.chdir('../../')
  end
end

desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'solidus_stripe_sources'
  Rake::Task['extension:test_app'].invoke
end
