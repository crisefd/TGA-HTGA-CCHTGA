class Spinach::Features::HasBestFitNotImproved < Spinach::FeatureSteps
  step 'a minimization problem with nil previous best chromosome' do
    @cchtga = CCHTGA.new(is_high_fit: false)
    @cchtga.prev_best_chromosome = nil
  end

  step 'a minization problem with best chromosome with a fitness greater than that of the previous best chromosome' do
    @cchtga = CCHTGA.new(is_high_fit: false)
    best_chromo_mock = mock('Chromosome')
    prev_best_chromo_mock = mock('Chromosome')
    best_chromo_mock.expects(:fitness).returns(-1)
    prev_best_chromo_mock.expects(:fitness).returns(-10)
    @cchtga.best_chromosome = best_chromo_mock
    @cchtga.prev_best_chromosome = prev_best_chromo_mock
  end

  step 'a minimization problem with previous best chromosome with a fitness greater than that of the best chromosome' do
    @cchtga = CCHTGA.new(is_high_fit: false)
    best_chromo_mock = mock('Chromosome')
    prev_best_chromo_mock = mock('Chromosome')
    best_chromo_mock.expects(:fitness).returns(-10)
    prev_best_chromo_mock.expects(:fitness).twice().returns(-1)
    @cchtga.best_chromosome = best_chromo_mock
    @cchtga.prev_best_chromosome = prev_best_chromo_mock
  end

  step 'the answer should be true' do
    answer = @cchtga.has_best_fit_not_improved?
    expect(answer).to be true
  end

end
