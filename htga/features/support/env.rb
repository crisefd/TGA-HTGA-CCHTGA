require 'simplecov'

SimpleCov.start do
    add_filter '/features/'
    add_filter '/htga_knapsack/'
end

require File.join(File.dirname(__FILE__), '..', '..', 'htga.rb')
require File.join(File.dirname(__FILE__), '..', '..', '..',
                  'helpers/chromosome.rb')
require File.join(File.dirname(__FILE__), '..', '..', '..',
                  'helpers/roulette.rb')
require 'rspec'
require 'mocha'

RSpec.configure { |config| config.mock_framework = :mocha }
Spinach::FeatureSteps.send(:include, RSpec::Matchers)
Spinach::FeatureSteps.send(:include, Mocha::API)
