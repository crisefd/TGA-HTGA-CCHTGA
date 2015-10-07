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
# Tested on oa_permut(3,4,2) given in paper
# Tested on Taguchi L64 array oa_permut(2,63,6)

# Reference: Leung, Y.-W.; Yuping Wang, "An orthogonal genetic algorithm
# with quantization % for global numerical optimization," Evolutionary
# Computation, IEEE Transactions on , vol.5, % no.1, pp.41,53, Feb 2001,
# doi: 10.1109/4235.910464
#
# This is a Ruby implementation by Cristhian Fuertes cristhian.fuertes@correounivalle.edu.co
# of the original implementation in Matlab by
# Natasha Y Jeppu, natasha.jeppu@gmail.com


require 'rubygems'
require 'bundler/setup'
require 'matrix'
$output = ""
$file_name = ""
def oa_permut(q, n, j)
  if n != (q**j - 1)/(q - 1) then
    p "Does not satisfy criteria ..."
    return nil
  end
  $file_name = "L#{n + 1}"
  row = q**j
  col = (q**j - 1)/(q - 1)
  #puts "row=#{row} col=#{col}"
  _A = Matrix.build(row, col){|r, c| 0}
  #Compute de basic columns
  for k in 0...j
    _J = ((q **k ) - 1)/(q - 1)
    #p _J
    for i in 0...row
      m =  (i/(q ** (j + -1 *(k + 1)))) % q
      #p m
      _A.send(:[]=, i, _J, m)
    end
  end
  #print_matrix(_A)
  #puts "==========================="
  for k in 1...j
    _J = (q ** k - 1)/(q - 1)
    for s in 0..._J
      for t in 0...(q - 1)
        x = _J + (s + 1)  * (q - 1) + t
      #  p "#{x} = #{_J} + (#{s} + 1) * (#{q} - 1) + #{t}"
        replace_column(_A,s,t + 1,_J,q, x)
      end
    end
  end
  _A = _A.map{|e| e % q}
  _A
end

def replace_column(_A,s,t,_J,q, x)
  col_s = _A.column(s)
  col_J = _A.column(_J)
  col_s = t * col_s
  col = col_s + col_J
  col = col.map { |e|  e % q}
  for i in 0..._A.row_size
    _A.send(:[]=, i, x, col[i])
  end
end

def print_matrix(_A)
  matrix_file = open("taguchi_orthogonal_matrices/#{$file_name}", 'w')
  for i in 0..._A.row_size
    for j in 0..._A.column_size
      $output += "#{_A[i,j]};"
    end
    $output += "\n"
  end
  matrix_file.write($output)
  matrix_file.close

end

if __FILE__ == $PROGRAM_NAME
  q = ARGV[0].to_i
  n = ARGV[1].to_i
  j = ARGV[2].to_i

  _A = oa_permut(q, n, j)
  print_matrix(_A)
end
