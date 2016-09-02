# language: english
# encoding: utf-8
# Program: execute.rb
# Authors: Cristhian Fuertes,  Oscar Tigreros
# Email: cristhian.fuertes@correounivalle.edu.co,
#        oscar.tigreros@correounivalle.edu.co
# Creation date: 2016-03-25

require_relative 'htga/htga'
require_relative 'tga/tga'
require_relative 'cchtga/cchtga'

# Manager class for running tests
class TestRunner
  # Main method to execute tests
  # @param [Array<String>] paths_to_input_test_files
  # @param [String] algorithm_name
  # @return [void]
  def execute(paths_to_input_test_files, algorithm_name)
    @algorithm_name = algorithm_name
    paths_to_input_test_files.each do |path|
      input_hash = load_input_test_file path
      0.upto(@num_runs - 1) do |run|
        p "========== RUN #{run} ============="
        output_hash = {}
        if algorithm_name == 'htga'
          htga = HTGA.new input_hash
          output_hash = htga.execute
        elsif algorithm_name == 'cchtga'
          cchtga = CCHTGA.new input_hash
          output_hash = cchtga.execute
        elsif algorithm_name == 'tga'
          tga = TGA.new input_hash
          output_hash = tga.execute
        end
        write_ouput_file output_hash, path, run
      end
    end
  end

  # Method to read input test files
  # @param [String] path_to_input_test_file
  # @return [Hash]
  def load_input_test_file(path_to_input_test_file)
    input_hash = {}
    file = open path_to_input_test_file, 'r'
    file.each_line do |line|
      splitted_line = line.split(':')
      second_word = splitted_line[1].gsub(/\A\p{Space}*|\p{Space}*\z/, '')
      first_word = splitted_line[0].gsub(/\A\p{Space}*|\p{Space}*\z/,
                                         '').gsub(/\s+/, ' ')
      input_hash.merge! return_hash(first_word, second_word, input_hash)
    end
    file.close
    input_hash
  end

  # Method to write the output of a test
  # @param [Hash] output_hash
  # @param [String] path_to_input_test_file
  # @param [Integer] run
  # @return [void]
  def write_ouput_file(output_hash, path_to_input_test_file, run)
    splitted_path = path_to_input_test_file.split '/'
    input_file_name = splitted_path[-1].split('.')[0]
    path_to_output_file = "#{splitted_path.slice(0..-2).join('/')}/#{input_file_name}-OUTPUT.csv"
    file = open path_to_output_file, 'w'
    if run == 0
      if @algorithm_name != 'cchtga'
        file.puts "best fitness,generation of best fitness,function evaluations of best fitness,optimal value,relative error"
      else
        file.puts "best fitness,generation of best fitness,function evaluations of best fitness,optimal value,relative error,subsystems"
      end
    end
    file.puts "#{output_hash[:best_fit]},#{output_hash[:gen_of_best_fit]},#{output_hash[:func_evals_of_best_fit]},#{output_hash[:optimal_func_val]},#{output_hash[:relative_error]},#{output_hash[:num_subsystems]}"
    file.close
  end


  # Method to process the input test file lines
  # @param [String] first_word
  # @param [String] second word
  # @param [Hash] input_hash
  def return_hash(first_word, second_word, input_hash)
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
      fail "Invalid beta values #{second_word}" unless second_word == 'discrete' ||
                                                       second_word == 'uniform distribution'
      hash = { beta_values:  second_word.to_s }
    when 'max number of generations'
      hash = { max_generation: second_word.to_i }
    when 'upper bounds'
      begin
        if second_word == 'pi'
          second_word = Math::PI.to_s
        elsif second_word == '-pi'
          second_word = (-1 * Math::PI).to_s
        end
        bound = Float second_word
        hash = { upper_bounds: Array.new(input_hash[:num_genes], bound) }
      rescue
        bound = second_word.gsub(/[\[\] ]/, '').split(',').map!(&:to_f)
        hash = { upper_bounds: bound }
      end
    when 'lower bounds'
      begin
        if second_word == 'pi'
          second_word = Math::PI.to_s
        elsif second_word == '-pi'
          second_word = (-1 * Math::PI).to_s
        end
        bound = Float second_word
        hash = { lower_bounds: Array.new(input_hash[:num_genes], bound) }
      rescue
        if second_word == 'pi'
          second_word = Math::PI.to_s
        elsif second_word == '-pi'
          second_word = (-1 * Math::PI).to_s
        end
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
  fail "Invalid number of arguments #{ARGV.size}, expected 2 " if ARGV.size != 2
  algorithm_name = ARGV[0].downcase
  fail "#{name_algorithm} is not a valid name" unless algorithm_name == 'tga' ||
                                                      algorithm_name == 'htga' ||
                                                      algorithm_name == 'cchtga'
  path = ARGV[1].to_s
  if File.directory? path
    path = Dir["#{path}/*.ini"]
  else
    path = [path]
  end
  tr = TestRunner.new
  tr.execute path, algorithm_name
end
