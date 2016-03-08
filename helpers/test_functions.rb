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
    -125_69.4600, # value 1
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
      sum = 0.0
      x.each do |xi|
        sum += -1 * xi * Math.sin(Math.sqrt(xi.abs))
      end
      sum
    end,
    lambda do |x| # function 2
      sum = 0.0
      x.each do |xi|
        sum += xi**2 -10 * Math.cos(2 * Math::PI * xi) + 10
      end
      sum
    end,

    lambda do |x| # function 3
      sum_square_x = 0.0
      sum_cos = 0.0
      x.each do |xi|
        sum_square_x += xi**2
        sum_cos += Math.cos(2 * Math::PI * xi)
      end
      sum_square_x *= 1.0 / x.size
      sum_cos *= 1.0 / x.size
      first_term = -20 * Math.exp(-0.2 * Math.sqrt(sum_square_x))
      second_term = -1 * Math.exp(sum_cos)
      first_term + second_term + 20 + Math.exp(1)
    end,
    lambda do |x| # function 4
      sum = 0.0
      prod = 0.0
      i = 1
      x.each do |xi|
        sum += xi**2
        prod *= (Math.cos(xi / Math.sqrt(i)) + 1) # Correct ?
        i += 1
      end
      ((1.0 / 4000) * sum) - prod
    end,
    nil, # function 5
    nil, # function 6
    lambda do |x| # function 7
      i = 1
      sum = 0.0
      x.each do |xi|
        sum += Math.sin(xi) * Math.sin(i * xi**2 / Math::PI)**20
        i += 1
      end
      sum * -1
    end,
    nil, # function 8
    nil, # function 9
    nil, # function 10
    lambda do |x| # function 11
      sum = 0.0
      x.each do |xi|
        sum + xi**2
      end
      sum
    end,
    lambda do |x| # function 12
      sum = 0.0
      x.each do |xi|
        sum += xi**4 + rand(0...10) / 10.0
      end
      sum
    end,
    lambda do |x| # function 13
      sum = 0.0
      prod = 0.0
      x.each do |xi|
        sum += xi.abs
        prod *= xi.abs
      end
      sum + prod
    end,
    nil, # function 14
    lambda do |x| # function 15
      max = nil
      x.each do |xi|
        max = xi.abs if max.nil? || xi.abs > max
      end
      max
    end
  ]
end
