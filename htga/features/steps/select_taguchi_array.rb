class Spinach::Features::SelectTaguchiArray < Spinach::FeatureSteps
  step 'that the size fo the chromosome is 5' do
    @htga = HTGA.new( num_genes: 5)
  end

  step 'the selected Taguchi array should be L8' do
    @htga.select_taguchi_array
    expect(@htga.taguchi_array.size).to eq(8)
  end

  step 'that the size fo the chromosome is 15' do
    @htga = HTGA.new( num_genes: 15)
  end

  step 'the selected Taguchi array should be L16' do
    @htga.select_taguchi_array
    expect(@htga.taguchi_array.size).to eq(16)
  end

  step 'that the size fo the chromosome is 55' do
    @htga = HTGA.new( num_genes: 55)
  end

  step 'the selected Taguchi array should be L64' do
    @htga.select_taguchi_array
    expect(@htga.taguchi_array.size).to eq(64)
  end
end
