require 'simplecov'

SimpleCov.start do
    add_filter '/features/'
    add_filter '/legacy_step_definitions'
end

require File.join(File.dirname(__FILE__), '..', '..', 'cchtga.rb')
require File.join(File.dirname(__FILE__), '..', '..', 'ihtga.rb')
require File.join(File.dirname(__FILE__), '..', '..', '..', 'helpers/subsystem.rb')
require File.join(File.dirname(__FILE__), '..', '..', '..', 'helpers/test_functions.rb')
require File.join(File.dirname(__FILE__), '..', '..', '..', 'helpers/sus.rb')
require 'rspec'
require 'mocha'

RSpec.configure { |config| config.mock_framework = :mocha }
Spinach::FeatureSteps.send(:include, RSpec::Matchers)
Spinach::FeatureSteps.send(:include, Mocha::API)