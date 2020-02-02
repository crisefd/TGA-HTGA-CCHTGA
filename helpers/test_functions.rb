# language: en
# program: test_functions.rb
# creation date: 2016-02-26
# last modified: 2016-11-06

# Helper module for benchmark test functions
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
module TestFunctions

  # Knapsack 0-1 test function. It includes chromosome correction
  # @param [Chromosome] x The chromosome to be evaluated
  # @param [Array] v The benefits
  # @param [Array<Array>] w The list of constraints or weigths
  # @param [Array] max_w The RHS of the contraints
  # @return [Float] The fitness value
  KNAPSACK_FUNCTION = lambda do |x, v, w, max_w|
    sum_w = Array.new(w.size, 0)
    sum_v = 0
    range = (0...x.size).to_a
    while range.size > 0 
      i = range.delete_at(rand(range.size))
      contraint_broke = false
      (0...sum_w.size).each do |j|
        if sum_w[j] + x[i] * w[j][i] > max_w[j]
          contraint_broke = true
          break
        else
          sum_w[j] += x[i]*w[j][i]
        end
      end
      
      break if contraint_broke
      sum_v += x[i] * v[i]
    end
    sum_v
  end
  
  # Array of the known optimal values for the test functions
  OPTIMAL_FUNCTION_VALUES = [
    0, # value 1
    0, # value 2
    0, # value 3
    0, # value 4
    0, # value 5
    0, # value 6
    nil, # value 7 <= -28.53 for N=30; -99.27 for N=100
    0, # value 8
    -78.33236, # value 9
    0, # value 10
    0, # value 11
    0, # value 12
    0, # value 13
    0, # value 14
    0 # value 15
  ]

  # Array of Test Functions
  TEST_FUNCTIONS = [
    lambda do |x| # 1: Schwefel function
      sum = 0.0
      d = x.size
      x.each do |xi|
        sum += -1.0 * xi * Math.sin(Math.sqrt(xi.abs))
      end
      sum + (418.9829 * d)
    end,
    lambda do |x| # 2: Rastrigin function
      sum = 0.0
      x.each do |xi|
        sum += xi**2 - 10 * Math.cos(2 * Math::PI * xi) + 10
      end
      sum
    end,
    lambda do |x| # 3: Ackley's function
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
    lambda do |x| # 4: Griewank function
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
    lambda do |x| # 5: Levy function #1
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
    lambda do |x| # 6: Levy function #2
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
    lambda do |x| # 7: Michalewicz function
      i = 1
      sum = 0.0
      x.each do |xi|
        sum += Math.sin(xi) * Math.sin(i * xi**2 / Math::PI)**20
        i += 1
      end
      sum * -1
    end,
    lambda do |x| # 8: Brown function
      sum = 0.0
      (0...(x.size - 1)).each do |i|
        sum += (x[i]**2)**(x[i + 1]**2 + 1) + (x[i + 1]**2)**(x[i]**2 + 1)
      end
      sum
    end,
    lambda do |x| # 9: Styblinki-Tang function
      sum = 0.0
      d = x.size
      x.each do |xi|
        sum += xi**4 - 16 * xi**2 + 5 * xi
      end
      sum * 1.0 / d
    end,
    lambda do |x| # 10: Rosenbrok function
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
    lambda do |x| # 11: Sphere function
      sum = 0.0
      x.each do |xi|
        sum += xi**2
      end
      sum
    end,
    lambda do |x| # 12: Quartic function with noise
      sum = 0.0
      x.each do |xi|
        sum += xi**4
      end
      sum += rand(0.0...1.0)
      sum
    end,
    lambda do |x| # 13: Schwefel 2.22 function
      sum = 0.0
      prod = 1.0
      x.each do |xi|
        sum += xi.abs
        prod *= xi.abs
      end
      sum + prod
    end,
    lambda do |x| # 14: Schwefel 1.2 function
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
    lambda do |x| # 15: Schwefel 2.21 function 
      x.max_by { |xi| xi.abs }.abs
    end
  ]

end
