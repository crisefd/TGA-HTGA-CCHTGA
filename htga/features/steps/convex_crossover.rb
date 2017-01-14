class Spinach::Features::ConvexCrossover < Spinach::FeatureSteps
  step 'population of 4 chromosomes with continuous variables' do
    @input = { pop_size: 4, continuous: true, num_genes: 6 }
  end

  step 'a set of 2 chromosomes selected for crossover using roulette selection' do
    selected_indexes = mock('Array')
    selected_indexes.expects(:sample).times(4).returns(0, 1, 0, 1)
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
    @htga.stubs(:random).with(0...6).returns(2)
    @htga.stubs(:random).with(0..10).returns(5)
    @htga.stubs(:evaluate_chromosome).returns(nil)
    @htga.cross_individuals @input[:selected_indexes]
  end

  step 'the 4 newly added chromosomes should be the convex combination of their parents' do
    old_chromo_1 = @htga.chromosomes[0]
    old_chromo_2 = @htga.chromosomes[1]
    new_chromo_1 = @htga.chromosomes[4]
    new_chromo_2 = @htga.chromosomes[5]
    new_chromo_3 = @htga.chromosomes[6]
    new_chromo_4 = @htga.chromosomes[7]
    expect(new_chromo_1[2]).to eq(-6.5)
    expect(new_chromo_3[2]).to eq(-6.5)
    expect(new_chromo_1[3, 6]).to eq(old_chromo_2[3, 6])
    expect(new_chromo_2[3, 6]).to eq(old_chromo_1[3, 6])
    expect(new_chromo_1).to eq(new_chromo_3)
    expect(new_chromo_2).to eq(new_chromo_4)
  end
end
