# !~/.rvm/rubies/ruby-2.1.5/bin/ruby
# encoding: utf-8
# File: test_functions.rb
# Authors: Cristhian Fuertes, Fabian Cano, Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2015-10-17

# @author Cristhian Fuertes
module TestFunctions
  private

  def self.radians(x)
    x * Math::PI / 180
  end

  public

  TEST_FUNCTIONS = [
    lambda do |x|
      r = 0.0
      x.each_index do |i|
        r += -1 * x[i] * Math.sin(Math.sqrt(radians(x[i].abs)))
      end
      r
    end,
    lambda do |x|
      r = 0.0
      x.each_index do |i|
        r += x[i]**2 * -10 * Math.cos(radians(2 * Math::PI * x[i])) + 10
      end
      r
    end

  ]
end
