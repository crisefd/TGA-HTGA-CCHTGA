# encoding: utf-8
# language: en
# Program: oa_permut.rb
# creation date: 2015-10-05
# last modified: 2016-11-06

require 'rubygems'
require 'bundler/setup'
require 'matrix'

# Module for the Orthogonal Array Permutation algorithm
# Generate an Orthogonal Array using simple permutation method. The
# algorithm was provided in the paper Leung et al.
#
# Calling OA_PERMUT(Q,N,J)
#
# Q = the number of levels
# N = the number of factors or columns
# J is selected such that number of rows is equal to Q^J and
# N = (Q^J - 1)/(Q-1)
#
# Tested on Taguchi L8 oa_permut(2,7,3), L16 oa_permut(2,15,4) and L32 array oa_permut(2,31,5)
# Reference: Leung, Y.-W.; Yuping Wang, "An orthogonal genetic algorithm
# with quantization % for global numerical optimization," Evolutionary
# Computation, IEEE Transactions on , vol.5, % no.1, pp.41,53, Feb 2001,
# doi: 10.1109/4235.910464
#
# This is a Ruby implementation 
# based on the original implementation in Matlab by
# Natasha Y Jeppu, natasha.jeppu@gmail.com
# visit http://www.mathworks.com/matlabcentral/fileexchange/47218-orthogonal-array
# @author Cristhian Fuertes <cristhian.fuertes@correounivalle.edu.co>
# @author Oscar Tigreros <oscar.tigreros@correounivalle.edu.co>
module OAPermut

  # @!attribute ouput 
  #	@return [String] The output string to be writen in a file
  @@output = ''
  # @!attribute file_name
  #	@return [String] The name of the file to be writen in
  @@file_name = ''

  # Main function for the algorithm
  # @param [Integer] q The number of levels of the Array
  # @param [Integer] n A number that satisfy the equation N = (Q^J - 1)/(Q - 1)
  # @param [Integer] j A number that satisfy the equation J = ln(N(Q - 1) + 1)/ln(Q - 1)
  # @return [Matrix] The generated Taguchi array
  def self.oa_permut(q, n, j)
    @@output = ''
    @@file_name = ''
    if n != (q**j - 1) / (q - 1)
      p 'Does not satisfy criteria ...'
      return nil
    end
    @@file_name += "L#{n + 1}"
    row = q**j
    col = (q**j - 1) / (q - 1)
    _A = Matrix.build(row, col ){ |r, c| 0 }
    # Compute de basic columns
    (0...j).each do |k|
      _J = ((q**k) - 1) / (q - 1)
      (0...row).each do |i|
        m = (i / (q**(j + -1 * (k + 1)))) % q
        _A.send(:[]=, i, _J, m)
      end
    end
    # Compute the non basic columns
    (1...j).each do |k|
      _J = (q**k - 1) / (q - 1)
      (0..._J).each do |s|
        (0...(q - 1)).each do |t|
          x = _J + (s + 1) * (q - 1) + t
          OAPermut.replace_column(_A, s, t + 1, _J, q, x)
        end
      end
    end
    _A = _A.map{ |e| e % q }
    _A
  end

  # Prints the array values in file
  # @param [Matrix] matrix the matrix object to be printed
  # @return [nil]
  def self.print_matrix(matrix)
    matrix_file = open("../taguchi_orthogonal_arrays/#{@@file_name}", 'w')
    (0...matrix.row_size).each do |i|
      (0...matrix.column_size).each do |j|
        @@output += "#{matrix[i, j]};"
      end
      @@output += "\n"
    end
    matrix_file.write(@@output)
    matrix_file.close
  end

private
  # Replaces a column with another column in a matrix
  # @param [Matrix] _A
  # @param [Integer] s
  # @param [Integer] t
  # @param [Integer] _J
  # @param [Integer] q
  # @param [Integer] x
  def self.replace_column(_A, s, t, _J, q, x)
    col_s = _A.column(s)
    col_J = _A.column(_J)
    col_s = t * col_s
    col = col_s + col_J
    col = col.map { |e|  e % q}
    (0..._A.row_size).each do |i|
      _A.send(:[]=, i, x, col[i])
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  q = ARGV[0].to_i
  n = ARGV[1].to_i
  j = ARGV[2].to_i

  matrix = OAPermut.oa_permut(q, n, j)
  OAPermut.print_matrix(matrix)
end
