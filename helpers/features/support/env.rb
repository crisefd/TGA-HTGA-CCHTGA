require 'simplecov'

SimpleCov.start do
    add_filter '/features/'
    add_filter 'chromosome.rb'
    add_filter 'subsystem.rb'
    add_filter 'test_functions.rb'
end
require File.join(File.dirname(__FILE__), '..', '..', 'chromosome.rb')
require File.join(File.dirname(__FILE__), '..', '..', 'sus.rb')
require File.join(File.dirname(__FILE__), '..', '..', 'roulette.rb')
require 'rspec'
require 'mocha'

RSpec.configure { |config| config.mock_framework = :mocha }
Spinach::FeatureSteps.send(:include, RSpec::Matchers)
Spinach::FeatureSteps.send(:include, Mocha::API)


