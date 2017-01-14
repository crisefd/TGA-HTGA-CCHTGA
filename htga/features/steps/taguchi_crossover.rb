class Spinach::Features::TaguchiCrossover < Spinach::FeatureSteps
  step 'set of chromosomes with binary values' do
    @input = { continuous: false, num_genes: 7, pop_size: 4, 
               is_high_fit: false, cross_rate: 0.5 }
    chromosomes = []
    chromosomes.push Chromosome.new [0, 1, 1, 1, 0, 1, 0]
    chromosomes.push Chromosome.new [1, 0, 1, 1, 0, 0, 0]
    chromosomes.push Chromosome.new [1, 1, 1, 1, 0, 0, 0]
    chromosomes.push Chromosome.new [0, 0, 0, 0, 1, 1, 1]
    @input[:chromosomes] = chromosomes
  end

  step '2 chromosomes are selected for crossover' do
    @htga = HTGA.new @input
    @htga.taguchi_array = [[0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 1, 1, 1, 1],
                           [0, 1, 1, 0, 0, 1, 1],
                           [0, 1, 1, 1, 1, 0, 0],
                           [1, 0, 1, 0, 1, 0, 1],
                           [1, 0, 1, 1, 0, 1, 0],
                           [1, 1, 0, 0, 1, 1, 0],
                           [1, 1, 0, 1, 0, 0, 1]]
    @htga.stubs(:random).with(0...4).twice().returns(3, 2)
    @htga.chromosomes = @input[:chromosomes]
    @htga.generate_offspring_by_taguchi_method
  end
  
  step 'the objective function is the sum of squares of x' do
    @htga.selected_func = lambda { |x| x.map { |xi| xi**2 }.inject(:+) }
  end


  step 'the optimal combination of these 2, should be added to the set.' do
    expect(@htga.chromosomes.size).to eq(5)
    expect(@htga.chromosomes.last).to eq(Chromosome.new [0, 0, 0, 0, 0, 0, 0])
    expect(@htga.chromosomes.last.fitness).to eq(0)
  end
end
