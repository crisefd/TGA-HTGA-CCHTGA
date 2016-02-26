Then(/^the resulting matrix experiments should be$/) do |table|
  htga = HTGA.new
  htga.taguchi_array = [[0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 1, 1, 1, 1],
                        [0, 1, 1, 0, 0, 1, 1],
                        [0, 1, 1, 1, 1, 0, 0],
                        [1, 0, 1, 0, 1, 0, 1],
                        [1, 0, 1, 1, 0, 1, 0],
                        [1, 1, 0, 0, 1, 1, 0],
                        [1, 1, 0, 1, 0, 0, 1]]
  table = table.raw
  (0...table.size).each_index do |i|
    (0...table[0].size).each_index do |j|
      expect(table[i][j].to_i).to eq(htga.taguchi_array[i][j])
    end
  end
end
