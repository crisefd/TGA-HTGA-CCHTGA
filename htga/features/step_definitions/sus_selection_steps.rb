
pointers = []
num_required_selects = 0
Given(/^the required number of selections is (\d+)$/) do |arg1|
  num_required_selects = arg1.to_i
end

When(/^I execute the SUS selection operation for maximization of positive fitness values$/) do
  pointers = Selection::SUS.sample(@chromosomes, num_required_selects, is_negative_fit: false)
end

Then(/^there should be an array of pointers corresponding to the selected individuals$/) do

  expect(pointers.size).to eq(num_required_selects)
end
