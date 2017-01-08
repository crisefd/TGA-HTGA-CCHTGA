
Given(/^that the size fo the chromosome is (\d+)$/) do |size|
  @htga = HTGA.new
  @htga.num_genes = size.to_i
  @htga.select_taguchi_array
end

Then(/^the selected Taguchi array should be L(\d+)$/) do |arg|
  row_count = arg.to_i
  expect(@htga.taguchi_array.size).to eq(row_count)
end
