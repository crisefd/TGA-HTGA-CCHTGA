# language: en
# file: init_population.feature
# author: Oscar Tigreros
# email:  oscar.tigreros@correounivalle.edu.co
# creation date: 2016-04-23
# last modified:
# version: 0.2
# licence: GPL

Given(/^the chromosomes :$/) do |table|
  table = table.raw
  @new_generation_clone = []
  @chromosome_x = Chromosome.new
  @chromosome_y = Chromosome.new
  @chromosome_w = Chromosome.new
  @chromosome_z = Chromosome.new
  i = 0
  table.each do |item|
    if i >= 0
      @chromosome_x << item[0].to_i
      @chromosome_y << item[1].to_i
      @chromosome_w << item[2].to_i
      @chromosome_z << item[3].to_i
    end
    i += 1
  end
end

When(/^new generation is inserted$/) do
  @tga = TGA.new num_genes: 4, selected_func: 12, pop_size: 200,
                 upper_bounds: [5, 5, 5, 5], lower_bounds: [-11, -11, -11, -11],
                 continuous: false
  @tga.new_generation << @chromosome_x.clone
  @tga.new_generation << @chromosome_y.clone
  @tga.new_generation << @chromosome_w.clone
  @tga.new_generation << @chromosome_z.clone
  # p @chromosome_x
  # p @chromosome_y
  # p @chromosome_w
  # p @chromosome_z

  @new_generation_clone = @tga.new_generation.clone
  @tga.init_population
  @tga.insert_new_generation
end

Then(/^the population size, most kept the same size. With the new chromosomes.$/)do
  count = 0
  (0...@tga.chromosomes.size).each do |i|
    if @tga.chromosomes[i] == @new_generation_clone[0] ||
       @tga.chromosomes[i] == @new_generation_clone[1] ||
       @tga.chromosomes[i] == @new_generation_clone[2] ||
       @tga.chromosomes[i] == @new_generation_clone[3]
      count += 1
    end
  end
  expect(count).to eq(4)
  expect(@tga.chromosomes.size).to eq(@tga.pop_size)
end
