# language: en
# author: Cristhian Fuertes
# email: cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-05-08

Given(/^a chromosome with number of genes (\d+):$/) do |arg1|
  @cchtga = CCHTGA.new num_genes: arg1.to_i
end

When(/^the random grouping operation is apply$/) do
  @cchtga.divide_variables
  @cchtga.random_grouping
end

Then(/^each of the resulting subsystems should have the same number of variables & the sum should be equal to the total number of variables$/) do
  size_of_subsystem = @cchtga.subsystems.first.size
  sum_size_subsystem = 0
  @cchtga.subsystems.each do |subsystem|
    expect(subsystem.size).to eq(size_of_subsystem)
    sum_size_subsystem += subsystem.size
  end
  expect(sum_size_subsystem).to eq(@cchtga.num_genes)
end
