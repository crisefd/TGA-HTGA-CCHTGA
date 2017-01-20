class Spinach::Features::RandomGrouping < Spinach::FeatureSteps
  step 'a chromosome with an odd number of genes' do
    @input = { num_genes: 95 }
  end
  
  step 'a chromosome with an even number of genes' do
    @input = { num_genes: 96 }
  end

  step "the random grouping is apply, each subsystems should've the same size and the sum should be equal to the total number of variables" do
    cchtga = CCHTGA.new @input
    cchtga.divide_variables
    cchtga.random_grouping
    genes_per_group = cchtga.subsystems.first.size
    cchtga.subsystems.each do |subsystem|
      expect(genes_per_group).to eq(subsystem.size)
    end
    expect(genes_per_group * cchtga.subsystems.size).to eq(@input[:num_genes])
  end
end
