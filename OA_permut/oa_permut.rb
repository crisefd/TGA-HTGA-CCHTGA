

require 'rubygems'
require 'bundler/setup'
require 'matrix'

# @author Cristhian Fuertes
# @author Oscar Tigreros
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
# This is a Ruby implementation by Cristhian Fuertes and Oscar Tigreros,
# cristhian.fuertes@correounivalle.edu.co oscar.tigreros@correounivalle.edu.co
# based on the original implementation in Matlab by
# Natasha Y Jeppu, natasha.jeppu@gmail.com
# visit http://www.mathworks.com/matlabcentral/fileexchange/47218-orthogonal-array
module OAPermut
  # @attr [String] ouput, this contains the output string to be writen in files
  @@output = ''
  # @attr [String] file_name, this contains the name of the file to be writen
  @@file_name = ''

  # Main function for the algorithm
  # @param [Integer] q, the number of levels of the Array
  # @param [Integer] n, a number that satisfy the equation N = (Q^J - 1)/(Q - 1)
  # @param [Integer] j, a number that satisfy the equation J = ln(N(Q - 1) + 1)/ln(Q - 1)
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
    for k in 0...j
      _J = ((q**k) - 1) / (q - 1)
      for i in 0...row
        m = (i / (q**(j + -1 * (k + 1)))) % q
        _A.send(:[]=, i, _J, m)
      end
    end
    # Compute the non basic columns
    for k in 1...j
      _J = (q**k - 1)/(q - 1)
      for s in 0..._J
        for t in 0...(q - 1)
          x = _J + (s + 1) * (q - 1) + t
          OAPermut.replace_column(_A, s, t + 1, _J, q, x)
        end
      end
    end
    _A = _A.map{ |e| e % q }
    _A
  end

  # Auxiliar function for the algorithm, it is tasked with printing the matrix
  # on a file
  # @param [Matrix] matrix, the matrix object to be printed
  def self.print_matrix(matrix)
    matrix_file = open("../carpeta/#{@@file_name}", 'w')
    for i in 0...matrix.row_size
      for j in 0...matrix.column_size
        @@output += "#{matrix[i, j]};"
      end
      @@output += "\n"
    end
    matrix_file.write(@@output)
    matrix_file.close
  end

private
  # Auxiliar function for the algorithm, it is tasked with replacing a column with
  # another column in a matrix
  def self.replace_column(_A, s, t, _J, q, x)
    col_s = _A.column(s)
    col_J = _A.column(_J)
    col_s = t * col_s
    col = col_s + col_J
    col = col.map { |e|  e % q}
    for i in 0..._A.row_size
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
