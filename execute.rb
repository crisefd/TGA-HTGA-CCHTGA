# language: english
# encoding: utf-8
# Program: execute.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-03-25

require_relative 'htga/htga'


# Manager class for running tests
class TestRunner

  def initialize(all_tests: true)
    @all_tests = all_tests
  end

  def execute(path_to_input_test_file)
    if @all_tests
      ;
    else
      input_hash = load_input_test_file path_to_input_test_file
      1.upto(@num_runs) do |run|
        htga = HTGA.new input_hash
        output_hash = htga.execute
        write_ouput_file output_hash, path_to_input_test_file, run
      end
    end
  end

  def load_input_test_file(path_to_input_test_file)
    input_hash = {}
    file = open path_to_input_test_file, 'r'
    file.each_line do |line|
      splitted_line = line.split(':')
      second_word = splitted_line[1].gsub(/\A\p{Space}*|\p{Space}*\z/, '')
      first_word = splitted_line[0].gsub(/\A\p{Space}*|\p{Space}*\z/,
                                         '').gsub(/\s+/, ' ')
      input_hash.merge! return_hash(first_word, second_word)
    end
    p "input_hash #{input_hash}"
    p "num_runs #{@num_runs}"
    file.close
    input_hash
  end

  def write_ouput_file(output_hash, path_to_input_test_file, run)
    splitted_path = path_to_input_test_file.split '/'
    test_dir = splitted_path.first
    input_file_name = splitted_path.last
    path_to_output_file = "#{test_dir}/#{input_file_name}-OUTPUT.csv"
    file = open path_to_output_file, 'a'
    if run == 1
      file.puts "best fitness,generation of best fitness,function evaluations of
                 best fitness"
    end
    file.puts "#{output_hash[:best_fit]},#{output_hash[:gen_of_best_fit]},
               #{output_hash[:func_evals_of_best_fit]}"
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
    when 'negative fitnesses'
      if second_word == 'yes'
        hash = { is_negative_fit: true }
      elsif second_word == 'no'
        hash = { is_negative_fit: false }
      else
        fail '#negative_fitness bad keyword, expected yes or no'
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
      hash = { beta_values:  second_word.to_s }
    when 'max number of generations'
      hash = { max_generation: second_word.to_i }
    when 'upper bounds'
      begin
        bound = Float second_word
        hash = { upper_bounds: Array.new(@input_hash[:num_genes], bound) }
      rescue
        bound = second_word.gsub(/[\[\] ]/, '').split(',').map!(&:to_f)
        hash = { upper_bounds: bound }
      end
    when 'lower bounds'
      begin
        bound = Float second_word
        hash = { lower_bounds: Array.new(@input_hash[:num_genes], bound) }
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
  arg = ARGV[0].to_s
  path_to_input_test_file = "test_cases/#{arg}"
  tr = TestRunner.new all_tests: false
  tr.execute path_to_input_test_file
end
