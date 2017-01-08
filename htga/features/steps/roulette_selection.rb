class Spinach::Features::RouletteSelection < Spinach::FeatureSteps
  step 'a population of 20 chromosomes' do
    @input = { }
    chromosomes = []
    prob_data = [ 0.02, 0.029, 0.32, 0.321, 0.38, 0.41, 0.42, 0.42223, 0.43, 0.5, 
                  0.55, 0.61, 0.65, 0.68, 0.71, 0.73, 0.81, 0.83, 0.93, 1.0 ]
    prob_data.each do |prob| 
      chromo = mock('Chromosome')
      chromo.expects(:prob).at_least_once().returns(prob)
      chromosomes << chromo
    end
    @input[:pop_size] = 20
    @input[:chromosomes] = chromosomes
  end

  step 'a 20% crossover rate' do
    @input[:cross_rate] = 0.2
  end

  step '4 chromosomes are expected to be selected' do
    htga = HTGA.new @input
    htga.chromosomes = @input[:chromosomes]
    Kernel.expects(:rand).with(0.0..1.0).returns(0.02, 0.32, 0.43, 1.0)
    Roulette.expects(:calculate_probabilities).returns(nil)
    selected = htga.roulette_select
    expect(selected.size).to eq(4)
  end
end
