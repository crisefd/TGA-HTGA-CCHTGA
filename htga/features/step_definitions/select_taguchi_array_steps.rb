
Given(/^that the population size is (\d+)$/) do |pop_size|
  @htga = HTGA.new
  @htga.pop_size = pop_size.to_i
  @htga.select_taguchi_array
end

Then(/^the selected Taguchi array should be L(\d+)$/) do |arg|
  row_count = arg.to_i
  expect(@htga.taguchi_array.size).to eq(row_count)
end
