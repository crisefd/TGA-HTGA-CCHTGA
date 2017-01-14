class Spinach::Features::ConvexMutation < Spinach::FeatureSteps
  step 'a set of 10 chromosomes with continuous variables' do
    @input = { continuous: true, num_genes: 3 }
    chromosomes = []
    chromosomes.push Chromosome.new [3, 3, 3]
    chromosomes.push Chromosome.new [4, 4, 4]
    chromosomes.push Chromosome.new [5, 5, 5]
    chromosomes.push Chromosome.new [6, 6, 6]
    chromosomes.push Chromosome.new [7, 7, 7]
    chromosomes.push Chromosome.new [2, 2, 2]
    chromosomes.push Chromosome.new [1, 1, 1]
    chromosomes.push Chromosome.new [0, 0, 0]
    chromosomes.push Chromosome.new [-1, -1, -1]
    chromosomes.push Chromosome.new [-2, -2, -11]
    @input[:chromosomes] = chromosomes
  end

  step 'a mutation rate of 10%' do
    @input[:mut_rate] = 0.1
  end

  step 'the mutation operation is apply over the chromosomes' do
    @htga = HTGA.new @input
    @htga.chromosomes = @input[:chromosomes]
    @htga.stubs(:evaluate_chromosome).at_least_once().returns(nil)
    @htga.stubs(:random).with(0...3).twice().returns(0, 2)
    @htga.stubs(:random).with(0..10).once().returns(7)
    @htga.stubs(:random).with(0.0..1.0).times(10).returns(0.11, 0.2, 0.3, 0.4, 0.5, 
                                                          0.6, 0.7, 0.8, 0.9, 0.09)
    @htga.mutate_individuals
  end

  step 'one chromosome should have been mutated' do
    expect(@htga.chromosomes.size).to eq(11)
  end

  step 'the changed genes in it must be closer stepwise' do
    diff = (@htga.chromosomes.last()[2] - @htga.chromosomes.last()[0]).abs
    expect(diff).to be <= 9
  end
end
