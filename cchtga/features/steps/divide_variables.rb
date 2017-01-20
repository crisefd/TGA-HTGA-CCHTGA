class Spinach::Features::DivideVariables < Spinach::FeatureSteps
  step 'a chromosomes with an odd number of genes' do
    @input = { num_genes: 95 }
  end
  
  step 'a chromosomes with an even number of genes' do
    @input = { num_genes: 96 }
  end

  step 'the variables are divided, the size of the original chromosome divided by the number of subsystem should yield a divisor of number of genes' do
    cchtga = CCHTGA.new @input
    cchtga.divide_variables
    divisor = @input[:num_genes] / cchtga.subsystems.size 
    expect(@input[:num_genes] % divisor).to eq(0)
  end
end
