# language: en
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-08-01

rejoin_chromosomes_test = {}

Given(/^the subsystem with chromosomes:$/) do |table|
  table = table.raw
  chromosomes = []
  table.each do |items|
    chromo = Chromosome.new
    items.each do |item|
      chromo << item.to_f      
    end
    chromosomes << chromo
  end
  rejoin_chromosomes_test[:subsystem] = Subsystem.new
  rejoin_chromosomes_test[:subsystem].chromosomes = chromosomes
end

Given(/^this subsystem has the variables:$/) do |table|
  table = table.raw
  table.first.each do |item|
    rejoin_chromosomes_test[:subsystem] << item.to_i
  end
end

Given(/^if the systems chromosomes are:$/) do |table|
  chromosomes = []
  table = table.raw
  table.each do |items|
    chromosome = Chromosome.new
    items.each do |item|
      chromosome << item.to_f
    end
    chromosomes << chromosome
  end
  rejoin_chromosomes_test[:chromosomes] = chromosomes
end

When(/^the rejoin operation is apply$/) do
  cchtga = CCHTGA.new
  cchtga.chromosomes = rejoin_chromosomes_test[:chromosomes]
  cchtga.rejoin_chromosomes rejoin_chromosomes_test[:subsystem]
  rejoin_chromosomes_test[:result_chromosomes] = cchtga.chromosomes
end

Then(/^the systems's chromosomes should be:$/) do |table|
  table = table.raw
  expected_chromosomes = []
  table.each do |items|
    chromosome = Chromosome.new
    items.each do |item|
      chromosome << item.to_f
    end
    expected_chromosomes << chromosome
  end
  expect(rejoin_chromosomes_test[:result_chromosomes]).to eq(expected_chromosomes)
end

