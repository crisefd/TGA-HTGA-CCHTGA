Given(/^a population size \(M\) of (\d+)$/) do |arg1|
  @htga = HTGA.new
  @htga.pop_size = arg1.to_i
end

Given(/^the fitness values for the chromosomes are:$/) do |table|
  table = table.raw
  table = table[0]
  @htga.chromosomes = []
  table.each do |item|
    c = Chromosome.new
    c.fitness = item.to_f
    @htga.chromosomes << c
  end
end

When(/^I sort the chromosomes by fitness in decreasing order and select the better M chromosomes$/) do
  @htga.select_next_generation
end

Then(/^the fitness values of the parents for then next generation are:$/) do |table|
  table = table.raw
  table = table[0]
  @next_generation_chromosomes = []
  table.each do |item|
    c = Chromosome.new
    c.fitness = item.to_f
    @next_generation_chromosomes << c
  end
  k = 0
  expect(@htga.chromosomes.size).to eq(@next_generation_chromosomes.size)
  @next_generation_chromosomes.each do |chrom|
    expect(chrom.fitness).to eq(@htga.chromosomes[k].fitness)
    k += 1
  end
end
