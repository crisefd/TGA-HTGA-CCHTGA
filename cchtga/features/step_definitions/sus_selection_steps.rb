
sus_test_vars = {}

Given(/^the positive fitness values of some chromosomes:$/) do |table|
  table = table.raw
  chromosomes = []
  table.first.each do |item| 
      chromo = Chromosome.new
      chromo.fitness = item.to_f
      chromosomes << chromo
    end
  sus_test_vars[:pos_chromosomes] = chromosomes
end

Given(/^the required number of selections is (\d+)$/) do |arg1|
  num_required_selects = arg1.to_i
  sus_test_vars[:num_required_selects] = num_required_selects
end

When(/^I execute the SUS selection operation for miminization of positive fitness values$/) do
  sus_test_vars[:pointers] = SUS::sample(sus_test_vars[:pos_chromosomes], 
                                                   sus_test_vars[:num_required_selects],
                                                   is_negative_fit: false)
end

Then(/^there should be an array of pointers corresponding to the selected individuals$/) do

  expect(sus_test_vars[:pointers].size).to eq(sus_test_vars[:num_required_selects])
end


Given(/^the negative fitness values of some chromosomes:$/) do |table|
  table = table.raw
  chromosomes = []
  table.first.each do |item| 
      chromo = Chromosome.new
      chromo.fitness = item.to_f
      chromosomes << chromo
    end
  sus_test_vars[:neg_chromosomes] = chromosomes
end

When(/^I execute the SUS selection operation for miminization of negative fitness values$/) do
   sus_test_vars[:pointers] = SUS::sample(sus_test_vars[:neg_chromosomes], 
                                                   sus_test_vars[:num_required_selects],
                                                   is_negative_fit: true)
end