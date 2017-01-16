class Spinach::Features::GenerateInitialPopulation < Spinach::FeatureSteps
  step 'a population size of 30' do
    @input = { continuous: true }
    @input[:pop_size] = 30
  end

  step 'the number of genes is 10' do
    @input[:num_genes] = 10
  end

  step 'the domain is [-11, 5]^10' do
    @input[:lower_bounds] = Array.new 10, -11
    @input[:upper_bounds] = Array.new 10, 5
  end

  step 'the random values are discrete' do
    @input[:beta_values] = 'discrete'
  end

  step 'the random values are from a uniform distribution' do
    @input[:beta_values] = 'uniform distribution'
  end

  step 'The initial population is generated, each chromosome should be correct' do
    htga = HTGA.new @input
    htga.selected_func = lambda { |x| x.inject(:+) }
    htga.init_population
    htga.chromosomes.each do |chromo|
      chromo.each { |gene| expect(gene).to be_between(-11, 5).inclusive }
      expect(chromo.fitness).to be_between(-110, 50).inclusive
    end
  end
end
