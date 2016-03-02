


Given(/^as a test function the sum of squares of z$/) do
  @htga = HTGA.new
  @htga.selected_func = lambda do |x|
    x.inject(0){ |sum, z| sum + z**2 }
  end
end

Given(/^as a test function the sum of squares of z minus sixteen times z$/)do
  @htga = HTGA.new
  @htga.selected_func = lambda do |x|
    x.inject(0){ |sum, z| sum + z**2 - 16*z }
  end
end

Given(/^the chromosome x being$/) do |table|
  table = table.raw

  @chromosome_x = Chromosome.new
  table[0].each do |item|
    @chromosome_x << item.to_i
  end
    @htga.num_genes = @chromosome_x.size
end

Given(/^the chromosome y being$/) do |table|
  table = table.raw
  @chromosome_y = Chromosome.new
  table[0].each do |item|
    @chromosome_y << item.to_i
  end
end


Then(/^the optimal chromosome should be$/) do |table|
  table = table.raw
  expected_chromosome = Chromosome.new
  table[0].each do |item|
    expected_chromosome << item.to_i
  end
  @htga.select_taguchi_array
  calculated_chromosome = @htga.generate_optimal_chromosome @chromosome_x, @chromosome_y
  expect(calculated_chromosome).to eq(expected_chromosome)
end
