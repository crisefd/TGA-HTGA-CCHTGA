require 'simplecov'

SimpleCov.start do
    add_filter '/features/'
end

require File.join(File.dirname(__FILE__), '..', '..', 'oa_permut.rb')
require 'rspec/expectations'
require 'matrix'
