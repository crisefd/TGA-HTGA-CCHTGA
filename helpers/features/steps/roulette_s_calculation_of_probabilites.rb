class Spinach::Features::RouletteSCalculationOfProbabilites < Spinach::FeatureSteps
  step 'a set of chromosomes with positive fitness values' do
    @are_there_negative_fit = false
    @input = { }
    chromosomes = []
    fit_data = [ 1, 15, 23, 1, 5, 7, 8 ]
    fit_data.each do |fit|
      chromo = Chromosome.new
      chromo.fitness = fit
      chromosomes << chromo
    end
    @input[:chromosomes] = chromosomes
  end
  
  step 'a set of chromosomes with negative fitness values' do
    @are_there_negative_fit = true
    @input = { }
    chromosomes = []
    fit_data = [ -1, -15, -23, -1, -5, -7, -8 ]
    fit_data.each do |fit|
      chromo = Chromosome.new
      chromo.fitness = fit
      chromosomes << chromo
    end
    @input[:chromosomes] = chromosomes
  end

  step 'the array of probabilites is calculated, this should be sorted in ascending order, composed of float numbers between 0.0 and 1.0 with the last one being equal to 1.0' do
    Roulette::calculate_probabilities @input[:chromosomes]
    if @are_there_negative_fit
      expected_probs = [ 0.107, 0.280, 0.490, 0.598, 0.724, 0.859, 1.0 ]
    else
      expected_probs =  [ 0.171,  0.290, 0.377, 0.549, 0.706, 0.854, 1.0 ]
    end
    resulted_probs = []
    @input[:chromosomes].each do |chromo| 
      resulted_probs << (chromo.prob * 1000).floor / 1000.0
    end
    resulted_probs.each_index do |i|
      diff = (resulted_probs[i] - expected_probs[i]).abs
      expect(diff).to be <= 0.003
    end
  end
end
