
mutation_test_vars = {}

Given(/^the size ten chromosome:$/) do |table|
  table = table.raw
  chromosome = Chromosome.new
  table.first.each{ |item| chromosome << item.to_f }
  mutation_test_vars[:chromosome] = chromosome
end

Given(/^the upper bounds:$/) do |table|
  table = table.raw
  upper_bounds = []
  table.first.each{ |item| upper_bounds << item.to_f }
  mutation_test_vars[:upper_bounds] = upper_bounds
end

Given(/^the lower bounds:$/) do |table|
   table = table.raw
   lower_bounds = []
   table.first.each{ |item| lower_bounds << item.to_f }
   mutation_test_vars[:lower_bounds] = lower_bounds

end

Given(/^the best experience of current chromosome:$/) do |table|
  table = table.raw
  best_experience = Chromosome.new
  table.first.each{ |item| best_experience << item.to_f }
  mutation_test_vars[:best_experience] = best_experience
end

Given(/^the current best chromosome is:$/) do |table|
  table = table.raw
  best_chromosome = Chromosome.new
  table.first.each{ |item| best_chromosome << item.to_f }
  mutation_test_vars[:best_chromosome] = best_chromosome
end

Given(/^The probability of mutation is set to "([^"]*)"$/) do |arg|
  prob = arg.to_f
  mutation_test_vars[:mutation_prob] = prob
end

When(/^the mutation operation is apply$/) do
  ihtga = IHTGA.new upper_bounds: mutation_test_vars[:upper_bounds],
                    lower_bounds: mutation_test_vars[:lower_bounds],
                    subsystem: Subsystem.new,
                    mutation_prob: mutation_test_vars[:mutation_prob]
  
  ihtga.subsystem.best_chromosomes_experiences = [ mutation_test_vars[:best_experience] ]
  ihtga.best_chromosome = mutation_test_vars[:best_chromosome]
  
  
  mutation_test_vars[:mutated_chromosome] = ihtga.mutate mutation_test_vars[:chromosome].clone, 0
end

Then(/^half of the gene values of the mutated chromosome must be less than or equal than previous gene value minus one$/) do
  mutated_chromosome = mutation_test_vars[:mutated_chromosome]
  original_chromosome = mutation_test_vars[:chromosome]
  p "mutated_chromosome = #{mutated_chromosome}"
  p "original_chromosome = #{original_chromosome}"
  count = 0
  mutated_chromosome.each_with_index do |gene, i|
    if original_chromosome[i] - gene <= 1
      count += 1
    end
  end
  p "count = #{count}"
  expect(count).to eq(original_chromosome.size / 2)
end

