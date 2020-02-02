# frozen_string_literal: true

# language: en
# program: execute.rb
# creation date: 2016-03-25
# last modified: 2016-11-06

require_relative 'htga/htga'
require_relative 'htga/htga_knapsack/htga_knapsack'
require_relative 'tga/tga'
require_relative 'tga/tga_knapsack/tga_knapsack'
require_relative 'cchtga/cchtga'

# Manager class for running tests
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
class TestRunner
  # Main method to execute tests
  # @param [Array<String>] paths_to_input_test_files
  # @param [String] algorithm_name
  # @return [nil]
  def execute(paths_to_input_test_files, algorithm_name)
    @start_time = Time.now
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

  # Reads input test files
  # @param [String] path_to_input_test_file
  # @return [Hash]
  def load_input_test_file(path_to_input_test_file)
    input_hash = {}
    file = File.open path_to_input_test_file, 'r'
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

  # Writes the output of a test to a file
  # @param [Hash] output_hash
  # @param [String] path_to_input_test_file
  # @param [Integer] run
  # @return [nil]
  def write_ouput_file(output_hash, path_to_input_test_file, run)
    splitted_path = path_to_input_test_file.split '/'
    input_file_name = splitted_path[-1].split('.')[0]
    path_to_output_file =
      "#{splitted_path.slice(0..-2).join('/')}/#{input_file_name}-OUTPUT.csv"
    File.delete(path_to_output_file) if File.exist?(path_to_output_file) && run.zero?
    file = File.open path_to_output_file, 'a'
    if run.zero?
      if @algorithm_name != 'cchtga'
        file.puts 'best fitness,generation of best fitness,function evaluations of best fitness,optimal value,relative error'
      else
        file.puts 'best fitness,generation of best fitness,function evaluations of best fitness,optimal value,relative error,subsystems'
      end
    end
    file.puts "#{output_hash[:best_fit]},#{output_hash[:gen_of_best_fit]},#{output_hash[:func_evals_of_best_fit]},#{output_hash[:optimal_func_val]},#{output_hash[:relative_error]},#{output_hash[:num_subsystems]}"
    file.close
  end

  # Processes the input test file lines
  # @param [String] first_word
  # @param [String] second word
  # @param [Hash]
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
        raise '#minization bad keyword, expected yes or no'
      end
    when 'continuous'
      if second_word == 'yes'
        hash = { continuous: true }
      elsif second_word == 'no'
        hash = { continuous: false }
      else
        raise '#continuous bad keyword, expected yes or no'
      end
    when 'negative fitnesses'
      if second_word == 'yes'
        hash = { is_negative_fit: true }
      elsif second_word == 'no'
        hash = { is_negative_fit: false }
      else
        raise '#negative_fitness bad keyword, expected yes or no'
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
      raise "Invalid beta values #{second_word}" unless ['discrete',
                                                         'uniform distribution']
                                                        .include?(second_word)
      hash = { beta_values: second_word.to_s }
    when 'max number of generations'
      hash = { max_generation: second_word.to_i }
    when 'optimum'
      hash = { optimal_func_val: second_word.to_f }
    when 'upper bounds'
      begin
        if second_word == 'pi'
          second_word = Math::PI.to_s
        elsif second_word == '-pi'
          second_word = (-1 * Math::PI).to_s
        end
        bound = Float second_word
        hash = { upper_bounds: Array.new(input_hash[:num_genes], bound) }
      rescue StandardError
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
      rescue StandardError
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

# Manager class for running tests with Knapsack 0-1 problem
# @author Cristhian Fuertes
# @author Oscar Tigreros
class KnapsackTestRunner < TestRunner
  # Main method to execute tests
  # @param [Array<String>] paths_to_input_test_files
  # @param [String] algorithm_name
  # @return [nil]
  def execute(paths_to_input_test_files, algorithm_name)
    @start_time = Time.now
    @algorithm_name = algorithm_name
    paths_to_input_test_files.each do |path|
      input_hash = load_input_test_file path
      0.upto(@num_runs - 1) do |run|
        p "========== RUN #{run} ============="
        output_hash = {}
        if algorithm_name == 'htga_knapsack'
          htga = HTGAKnapsack.new input_hash
          output_hash = htga.execute
        elsif algorithm_name == 'tga_knapsack'
          tga = TGAKnapsack.new input_hash
          output_hash = tga.execute
        end
        write_ouput_file output_hash, path, run
      end
    end
  end

  # Reads input test files
  # @param [String] path_to_input_test_file
  # @return [Hash]
  def load_input_test_file(path_to_input_test_file)
    input_hash = { is_negative_fit: false, is_high_fit: true }
    lines = IO.readlines path_to_input_test_file
    k = 0
    while k < lines.size
      line = lines[k]
      splitted_line = line.split(':')
      splitted_line << 'placeholder' if splitted_line.size == 1
      second_word = splitted_line[1].gsub(/\A\p{Space}*|\p{Space}*\z/, '')
      first_word = splitted_line[0].gsub(/\A\p{Space}*|\p{Space}*\z/,
                                         '').gsub(/\s+/, ' ')
      if !input_hash[:num_constraints].nil? && first_word == 'weights'
        temp = lines[(k + 1)...(input_hash[:num_constraints] + k + 1)].join
        weights_str = temp.gsub("\n", '').gsub(' ', '')
        weights = eval(weights_str)
        input_hash.merge!(weights: weights)
        k += input_hash[:num_constraints] + 1
        next
      end
      input_hash.merge! return_hash(first_word, second_word, input_hash)
      k += 1
    end
    input_hash
  end

  # Method to process the input test file lines
  # @param [String] first_word
  # @param [String] second word
  # @param [Hash] input_hash
  def return_hash(first_word, second_word, _input_hash)
    hash = {}
    case first_word
    when 'population size'
      hash = { pop_size: second_word.to_i }
    when 'number of genes'
      hash = { num_genes: second_word.to_i }
    when 'mutation rate'
      hash = { mut_rate: second_word.to_f }
    when 'crossover rate'
      hash = { cross_rate: second_word.to_f }
    when 'number of constraints'
      hash = { num_constraints: second_word.to_i }
    when 'max weights'
      hash = { max_weight: eval(second_word) }
    when 'values'
      hash = { values: eval(second_word) }
    when 'max number of generations'
      hash = { max_generation: second_word.to_i }
    when 'optimum'
      hash = { optimal_func_val: second_word.to_f }
    else
      @num_runs = second_word.to_i
    end
    hash
  end
end

if __FILE__ == $PROGRAM_NAME
  p ARGV
  raise "Invalid number of arguments #{ARGV.size}, expected 2 " if ARGV.size != 2
  algorithm_name = ARGV[0].downcase
  algorithms = %w[tga htga cchtga tga_knapsack htga_knapsack]
  raise "#{algorithm_name} is not a valid name" unless algorithms
                                                       .include?(algorithm_name)
  path =
    if File.directory? ARGV[1].to_s
      Dir["#{path}/*.ini"]
    else
      [ARGV[1].to_s]
    end
  tr =
    if algorithm_name.match(/_knapsack$/)
      KnapsackTestRunner.new
    else
      TestRunner.new
    end
  tr.execute path, algorithm_name
end
