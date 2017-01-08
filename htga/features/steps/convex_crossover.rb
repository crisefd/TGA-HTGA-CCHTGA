class Spinach::Features::ConvexCrossover < Spinach::FeatureSteps
  step 'population of 4 chromosomes with continuous variables' do
    @input = { pop_size: 4, continuous: true, num_genes: 6 }
  end

  step 'a set of 2 chromosomes selected for crossover using roulette selection' do
    selected_indexes = mock('Array')
    selected_indexes.expects(:sample).times(4).returns(0, 1, 2, 3)
    selected_indexes.expects(:size).returns(2)
    @input[:selected_indexes] = selected_indexes
  end

  step 'the domain is [-11, 7]^6' do
    chromosomes = []
    chromosomes.push Chromosome.new [-7, -7, -7, 7, 7, 7]
    chromosomes.push Chromosome.new [-6, -6, -6, 6, 6, 6]
    chromosomes.push Chromosome.new [-5, -5, -5, 5, 5, 5]
    chromosomes.push Chromosome.new [-4, -4, -4, 4, 4, 4]
    @input[:chromosomes] = chromosomes
    @input[:lower_bounds] = [ -11, -11, -11, -11, -11, -11 ]
    @input[:upper_bounds] = [ 7, 7, 7, 7, 7, 7 ]
  end

  step 'the crossover operation is applied' do
    @htga = HTGA.new @input
    @htga.chromosomes = @input[:chromosomes]
    # Kernel.expects(:rand).with(0...6).returns(2)
    @htga.cross_individuals @input[:selected_indexes]
  end

  step 'the 4 newly added chromosomes should be the convex combination of their parents' do
    pending('hard to test')
    p @htga.chromosomes
    expect(@htga.chromosomes.size).to eq(8)
  end
end
