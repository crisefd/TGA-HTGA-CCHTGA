class Spinach::Features::SelectNextGeneration < Spinach::FeatureSteps
  step 'a population of D chromosomes with negative fitness values' do
    @input = { }
    fit_data = [ 0, -3, -30, -2, -15, -16, -17, -32, -45, -5 ]
    chromosomes = [ ]
    fit_data.each do |fit|
      chromo = mock(:Chromosome)
      chromo.expects(:fitness).at_least_once.returns(fit)
      chromosomes << chromo
    end
    @input[:chromosomes] = chromosomes
  end

  step 'optimization problem being a minimization one' do
    @input[:pop_size] = 5
    @input[:is_high_fit] = false
  end
  
  step 'optimization problem being a maximization one' do
    @input[:pop_size] = 5
    @input[:is_high_fit] = true
  end

  step 'the chromosomes are sort in increasing order to select the better M chromosomes (D > M)' do
    @htga = HTGA.new @input
    @htga.chromosomes = @input[:chromosomes]
    @htga.select_next_generation
  end

  step 'the number of chromosomes for the next generation should be M' do
    expect(@htga.chromosomes.size).to eq(@input[:pop_size])
  end

  step 'a population of D chromosomes with positive fitness values' do
    @input = { }
    fit_data = [ 0, 3, 30, 2, 15, 16, 17, 32, 45, 5 ]
    chromosomes = [ ]
    fit_data.each do |fit|
      chromo = mock(:Chromosome)
      chromo.expects(:fitness).at_least_once.returns(fit)
      chromosomes << chromo
    end
    @input[:chromosomes] = chromosomes
  end
end
