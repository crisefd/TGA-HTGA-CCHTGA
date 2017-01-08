class Spinach::Features::ConvexMutation < Spinach::FeatureSteps
  step 'a set of 10 chromosomes with continuous variables' do
    @input = { continuous: true, num_genes: 3 }
  end
  
  step 'the domain is [-11, 7]^6' do
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
    chromosomes.push Chromosome.new [-2, -2, -2]
    @input[:chromosomes] = chromosomes
    @input[:lower_bounds] = [ -11, -11, -11, -11, -11, -11 ]
    @input[:upper_bounds] = [ 7, 7, 7, 7, 7, 7 ]
  end

  step 'a mutation rate of 10%' do
    @input[:mut_rate] = 0.1
  end

  step 'the mutation operation is apply over the chromosomes' do
    @htga = HTGA.new @input
    @htga.chromosomes = @input[:chromosomes]
    @htga.stubs(:evaluate_chromosome).returns(nil)
    # Kernel.expects(:rand).with(0.0..1.0).returns(0.11, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    @htga.mutate_individuals
  end

  step 'one chromosome should have been mutated' do
    pending 'hard to test'
  end

  step 'the changed genes in it must be closer stepwise' do
    pending 'hard to test'
  end
end
