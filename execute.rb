# language: english
# encoding: utf-8
# Program: execute.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-03-25

# Manager class for running tests
class TestRunner

  def initialize(path_to_input_test_file)
    load_input_test_file path_to_input_test_file
  end

  def execute
  end

  def load_input_test_file(path_to_input_test_file)
    @hash_input = {}
    file = open(path_to_input_test_file, 'r')
    file.each_line do |line|
      splitted_line = line.split(':')
      first_word = splitted_line[1].gsub(/\A\p{Space}*|\p{Space}*\z/, '')
      second_word = splitted_line[0].gsub(/\A\p{Space}*|\p{Space}*\z/,
                                          '').gsub(/\s+/, ' ')
      @hash_input.merge return_hash(first_word, second_word)
    end
    file.close
  end

  def return_hash(first_word, second_word)
    hash = {}
    case first_word
    when 'function'
      hash = { selected_func: second_word.to_i }
    when 'minimization'
      if second_word == 'yes'
        hash = { is_high_fit: false }
      elsif second_word == 'no'
        hash = { is_high_fit: true }
      else
        fail '#minization bad keyword, expected yes or no'
      end
    when 'continuous'
      if second_word == 'yes'
        hash = { continuous: true }
      elsif second_word == 'no'
        hash = { continuous: false }
      else
        fail '#continuous bad keyword, expected yes or no'
      end
    when 'population size'
      hash = { pop_size: second_word.to_i }
    when 'number of genes'
      hash = { num_genes: second_word.to_i }
    when 'mutation rate'
      hash = { mut_rate: second_word.to_f }
    when 'crossover rate'
      hash = { cross_rate: second_word.to_f }
    when 'beta values'
      fail "Invalid beta values #{second_word}" unless second_word == 'discrete' || second_word == 'uniform distribution'
      hash = { beta_values:  second_word }
    when 'max number of generations'
      hash = { max_generation: second_word.to_i }
    when 'upper bounds'
      begin
        bound = second_word.to_f
        hash = { upper_bounds: Array.new(@hash_input[:num_genes], bound) }
      rescue
        bound = second_word.gsub(/[\[\] ]/, '').split(',').map!(&:to_f)
        hash = { upper_bounds: bound }
      end
    when 'lower bounds'
      begin
        bound = second_word.to_f
        hash = { lower_bounds: Array.new(@hash_input[:num_genes], bound) }
      rescue
        bound = second_word.gsub(/[\[\] ]/, '').split(',').map!(&:to_f)
        hash = { lower_bounds: bound }
      end
    else
      @num_runs = second_word.to_i
    end
    hash
  end
end

if __FILE__ == $PROGRAM_NAME
  path_to_input_test_file = ARGV[0].to_s
  tr = TestRunner.new path_to_input_test_file
  tr.execute
end
