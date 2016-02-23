Given(/^the chromosome$/) do |table|
  table = table.raw
  @chromosome = Chromosome.new
  table[0].each do |item|
    @chromosome << item.to_f
  end
end

Then(/^the SNR for minimization should be (.+?) dB$/) do |arg1|
  expected_snr = arg1.to_f
  HTGA.calculate_snr(@chromosome, smaller_the_better: true)
  calculated_snr = @chromosome.snr
  expect(calculated_snr.round(2)).to eq(expected_snr)
end

Then(/^the SNR for maximization should be (.+?) dB$/) do |arg1|
  expected_snr = arg1.to_f
  HTGA.calculate_snr(@chromosome, smaller_the_better: false)
  calculated_snr = @chromosome.snr
  expect(calculated_snr.round(2)).to eq(expected_snr)
end
