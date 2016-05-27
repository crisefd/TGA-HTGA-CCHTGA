
snr_test_vars = {}

Given(/^the chromosome:$/) do |table|
    table = table.raw
    chromosome = Chromosome.new
    table.first.each { |item| chromosome << item.to_f }
    snr_test_vars[:chromosome] = chromosome
end

Given(/^a best chromosome with a fitness value of (\d+)$/) do |arg|
    best_chromosome = Chromosome.new
    best_chromosome.fitness = arg.to_f
    snr_test_vars[:best_chromosome] = best_chromosome
end


Then(/^the SNR for minimization should be "([^"]*)"$/) do |arg|
    snr_test_vars[:is_high_fit] = false
    ihtga = IHTGA.new is_high_fit: snr_test_vars[:is_high_fit], 
                      subsystem: Subsystem.new,
                      selected_func: 11
                      
    ihtga.best_chromosome = snr_test_vars[:best_chromosome]
    ihtga.calculate_snr snr_test_vars[:chromosome]
    expect(snr_test_vars[:chromosome].snr).to eq(arg.to_r.to_f)
    
end
