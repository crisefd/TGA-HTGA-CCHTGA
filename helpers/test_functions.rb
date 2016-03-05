# language: en
# encoding: utf-8
# Program: test_functions.rb
# Authors: Cristhian Fuertes & Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-02-26

# @author Cristhian Fuertes
module TestFunctions
  private

  def self.radians(x)
    x * Math::PI / 180
  end

  public

  OPTIMAL_FUNCTION_VALUES = [
    -125_69.5, # value 1
    0, # value 2
    0, # value 3
    0, # value 4
    0, # value 5
    0, # value 6
    -99.2784, # value 7
    0, # value 8
    -78.33236, # value 9
    0, # value 10
    0, # value 11
    0, # value 12
    0, # value 13
    0, # value 14
    0 # value 15
  ]

  TEST_FUNCTIONS = [
    lambda do |x| # function 1
      r = 0.0
      x.each_index do |i|
        r += -1 * x[i] * Math.sin(Math.sqrt(radians(x[i].abs)))
      end
      r
    end,
    lambda do |x| # function 2
      r = 0.0
      x.each_index do |i|
        r += x[i]**2 * -10 * Math.cos(radians(2 * Math::PI * x[i])) + 10
      end
      r
    end,

    lambda do |x| # function 3
      sum_square_x = 0.0
      sum_cos = 0.0
      x.each_index do |i|
        sum_square_x += x[i]**2
        sum_cos += Math.cos(radians(2 * Math::PI * x[i]))
      end
      sum_square_x *= 1.0 / x.size
      sum_cos *= 1.0 / x.size
      left_term = -20 * Math.exp(-0.2 * Math.sqrt(sum_square_x))
      right_term = -1 * Math.exp(sum_cos)
      left_term + right_term
    end,
    nil, # function 4
    nil, # function 5
    nil, # function 6
    lambda do |x| # function 7
      i = 1
      r = x.inject(0) do |sum, xi|
        sum + Math.sin(radians(xi)) * (Math.sin(radians(i * xi**2 / Math::PI)))**2
        i += 1
      end
      r * -1
    end,
    nil, # function 8
    nil, # function 9
    nil, # function 10
    lambda do |x| # function 11
      x.inject(0){ |sum, xi| sum + xi**2 }
    end,
    lambda do |x| # function 12
      x.inject(0){ |sum, xi| sum + xi**4 + rand(0...10) / 10.0 }
    end,
    nil, # function 13
    nil, # function 14
    nil # function 15

  ]
end
