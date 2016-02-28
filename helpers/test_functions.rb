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

  TEST_FUNCTIONS = [
    lambda do |x| # function 0
      r = 0.0
      x.each_index do |i|
        r += -1 * x[i] * Math.sin(Math.sqrt(radians(x[i].abs)))
      end
      r
    end,
    lambda do |x| # function 1
      r = 0.0
      x.each_index do |i|
        r += x[i]**2 * -10 * Math.cos(radians(2 * Math::PI * x[i])) + 10
      end
      r
    end,

    lambda do |x| # function 2
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
    end

  ]
end
