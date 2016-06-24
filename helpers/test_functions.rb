# language: en
# encoding: utf-8
# Program: test_functions.rb
# Authors: Cristhian Fuertes & Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-02-26

# @author Cristhian Fuertes
module TestFunctions
  OPTIMAL_FUNCTION_VALUES = [
    -12569.5, # value 1
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
      d = x.size
      x.each do |xi|
        sum += -1.0 * xi * Math.sin(Math.sqrt(xi.abs))
      end
      sum
    end,
    lambda do |x| # function 2
      sum = 0.0
      x.each do |xi|
        sum += xi**2 - 10 * Math.cos(2 * Math::PI * xi) + 10
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
      first_term + second_term + 20.0 + Math.exp(1)
    end,
    lambda do |x| # function 4
      sum = 0.0
      prod = 1.0
      i = 1
      x.each do |xi|
        sum += xi**2
        prod *= Math.cos(xi / Math.sqrt(i))
        i += 1
      end
      ((1.0 / 4000) * sum) - prod + 1
    end,
    lambda do |x| # function 5
      yi = lambda do |xi|
        1.0 + (xi + 1) / 4.0
      end
      u = lambda do |xi, a, k, m|
        r = 0.0
        if xi > a
          r = k * (xi - a)**m
        elsif (-1 * a) >= xi && xi <= a
          r = 0.0
        elsif xi < (-1 * a)
          r = k * ((-1 * xi) - a)**m
        end
        r
      end
      y1 = yi.call x[0]
      yn = yi.call x[-1]
      res = 10.0 * Math.sin(Math::PI * y1)**2
      sum1 = 0.0
      (0...(x.size - 1)).each do |i|
        sum1 += (yi.call(x[i]) - 1)**2 * (1 + 10.0 * Math.sin(Math::PI * yi.call(x[i + 1]))**2)
      end
      sum2 = 0.0
      x.each do |xi|
        sum2 += u.call(xi, 10, 100, 4)
      end
      res += sum1 + (yn - 1)**2
      res *= Math::PI / x.size
      res += sum2
      res
    end,
    lambda do |x| # function 6
      u = lambda do |xi, a, k, m|
        r = 0.0
        if xi > a
          r = k * (xi - a)**m
        elsif (-1 * a) >= xi && xi <= a
          r = 0.0
        elsif xi < (-1 * a)
          r = k * ((-1 * xi) - a)**m
        end
        r
      end
      res = Math.sin(3 * Math::PI * x[0])**2
      sum1 = 0.0
      (0...(x.size - 1)).each do |i|
        sum1 += (x[i] - 1)**2 * (1 + Math.sin(3 * Math::PI * x[i + 1])**2)
      end
      res += sum1 + (x[-1] - 1)**2 * (1 + Math.sin(2 * Math::PI * x[-1])**2)
      res /= 10.0
      sum2 = 0.0
      x.each do |xi|
        sum2 += u.call(xi, 5, 100, 4)
      end
      res += sum2
      res
    end,
    lambda do |x| # function 7
      i = 1
      sum = 0.0
      x.each do |xi|
        sum += Math.sin(xi) * Math.sin(i * xi**2 / Math::PI)**20
        i += 1
      end
      sum * -1
    end,
    lambda do |x| # function 8
      outer_sum = 0.0
      left_inner_sum = 0.0
      right_inner_sum = 0.0
      (0...x.size).each do |i|
        (0...x.size).each do |j|
          chi1 = rand(-100..100) # Correct ?
          psi1 = rand(-100..100)
          chi2 = rand(-100..100) # Correct ?
          psi2 = rand(-100..100)
          omega = rand((-1 * Math::PI)..Math::PI)
          left_inner_sum += chi1 * Math.sin(omega) + psi1 * Math.cos(omega)
          right_inner_sum += chi2 * Math.sin(x[j]) + psi2 * Math.cos(x[j])
        end
        outer_sum += (left_inner_sum - right_inner_sum)**2
      end
      outer_sum
    end,
    lambda do |x| # function 9
      sum = 0.0
      x.each do |xi|
        sum += xi**4 - 16 * xi**2 + 5 * xi
      end
      sum * 1.0 / x.size
    end,
    lambda do |x| # function 10
      res = 0.0
      first_term = 0.0
      second_term = 0.0
      (0...(x.size - 1)).each do |j|
        first_term = ((x[j + 1] - x[j]**2)**2) * 100
        second_term = (x[j] - 1)**2
        res += first_term + second_term
      end
      res
    end,
    lambda do |x| # function 11
      sum = 0.0
      x.each do |xi|
        sum += xi**2
      end
      sum
    end,
    lambda do |x| # function 12
      sum = 0.0
      x.each do |xi|
        sum += xi**4
      end
      sum += rand(0.0...1.0)
      sum
    end,
    lambda do |x| # function 13
      sum = 0.0
      prod = 1.0
      x.each do |xi|
        sum += xi.abs
        prod *= xi.abs
      end
      sum + prod
    end,
    lambda do |x| # function 14
      sum_i = 0.0
      (0...x.size).each do |i|
        sum_j = 0.0
        (0...i).each do |j|
          sum_j += x[j]
        end
        sum_i += sum_j**2
      end
      sum_i
    end,
    lambda do |x| # function 15
      # max = nil
      # x.each do |xi|
      #   max = xi.abs if max.nil? || xi.abs > max
      # end
      # max
      x.max_by { |xi| xi.abs }.abs
    end
  ]
end
