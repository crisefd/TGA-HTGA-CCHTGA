
snr_test_vars = {}

Given(/^a chromosome with a fitness value of (\d+)$/) do |arg|
    snr_test_vars[:chromosome] = Chromosome.new.fitness = arg.to_f
end

Given(/^a best chromosome with a fitness value of (\d+)$/) do |arg|
    snr_test_vars[:best_chromosome] = Chromosome.new.fitness = arg.to_f
end


Then(/^the SNR for minimization should be "([^"]*)"$/) do |arg|
    snr_test_vars[:is_high_fit] = false
    ihtga = IHTGA.new is_high_fit: snr_test_vars[:is_high_fit], subsystem: Subsystem.new
    ihtga.best_chromosome = snr_test_vars[:best_chromosome]
    ihtga.calculate_snr snr_test_vars[:chromosome]
    expect(snr_test_vars[:chromosome].snr).to eq(arg.to_r.to_f)
    
end
