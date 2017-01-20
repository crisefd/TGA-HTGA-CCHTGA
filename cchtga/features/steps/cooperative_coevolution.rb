class Spinach::Features::CooperativeCoevolution < Spinach::FeatureSteps
  step 'a set of subsystems with subchromosomes that can improve the current best chromosome' do
    @cchtga = CCHTGA.new(pop_size: 5, num_genes: 10, is_high_fit: false)
    chromosomes = []
    chromosomes.push Chromosome.new([ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ])
    chromosomes.push Chromosome.new([ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 ])
    chromosomes.push Chromosome.new([ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ])
    chromosomes.push Chromosome.new([ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ])
    chromosomes.push Chromosome.new([ 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ])
    chromosomes.push Chromosome.new([ 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 ])
    chromosomes.push Chromosome.new([ 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ])
    chromosomes.push Chromosome.new([ 8, 8, 8, 8, 8, 8, 8, 8, 8, 8 ])
    chromosomes.push Chromosome.new([ 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 ])
    chromosomes.push Chromosome.new([ 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 ])
    @cchtga.chromosomes = chromosomes
    subsystem_1 = Subsystem.new([ 0, 2, 4, 6, 8 ])
    subsystem_1.chromosomes = [ Chromosome.new([ 1, 1, 1, 1, 1 ]),
                                Chromosome.new([ 2, 2, 2, 2, 2 ]),
                                Chromosome.new([ 3, 3, 3, 3, 3 ]),
                                Chromosome.new([ 4, 4, 4, 4, 4 ]),
                                Chromosome.new([ 5, 5, 5, 5, 5 ]),
                                Chromosome.new([ 6, 6, 6, 6, 6 ]),
                                Chromosome.new([ 7, 7, 7, 7, 7 ]),
                                Chromosome.new([ 8, 8, 8, 8, 8 ]),
                                Chromosome.new([ 9, 9, 9, 9, 9 ]),
                                Chromosome.new([ 10, 10, 10, 10, 10 ]) ]
    subsystem_1.best_chromosomes_experiences = [ Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]) ]
    subsystem_1.best_chromosome = Chromosome.new([ 5, 5, 5, 5, 5 ])
    subsystem_2 = Subsystem.new([ 1, 3, 5, 7, 9 ])
    subsystem_2.chromosomes = [ Chromosome.new([ 1, 1, 1, 1, 1 ]),
                                Chromosome.new([ 2, 2, 2, 2, 2 ]),
                                Chromosome.new([ 3, 3, 3, 3, 3 ]),
                                Chromosome.new([ 4, 4, 4, 4, 4 ]),
                                Chromosome.new([ 5, 5, 5, 5, 5 ]),
                                Chromosome.new([ 6, 6, 6, 6, 6 ]),
                                Chromosome.new([ 7, 7, 7, 7, 7 ]),
                                Chromosome.new([ 8, 8, 8, 8, 8 ]),
                                Chromosome.new([ 9, 9, 9, 9, 9 ]),
                                Chromosome.new([ 10, 10, 10, 10, 10 ]) ]
    subsystem_2.best_chromosomes_experiences = [ Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]) ]
    subsystem_2.best_chromosome = Chromosome.new([ 4, 4, 4, 4, 4 ])
    @cchtga.subsystems = [ subsystem_1, subsystem_2 ]
    @cchtga.selected_func = lambda { |x| x.map { |xi| xi**2 }.inject(:+) }
    @cchtga.best_chromosome = Chromosome.new([ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
    @cchtga.best_chromosome.fitness = 10
  end

  step 'the cooperative coevolution is applied, the best chromosome should have been updated' do
    @cchtga.cooperative_coevolution
    expect(@cchtga.subsystems.last.best_chromosome).to eq (Chromosome.new([0, 0, 0, 0, 0]))
    expect(@cchtga.best_chromosome).to eq(Chromosome.new([0, 0, 0, 0, 0, 0, 0, 0, 0, 0]))
    expect(@cchtga.best_chromosome.fitness).to eq(0)
  end
  
  step 'a set of subsystems with a subchromosome that can improve a current best experience' do
    @cchtga = CCHTGA.new(pop_size: 5, num_genes: 10, is_high_fit: false)
    chromosomes = []
    chromosomes.push Chromosome.new([ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ])
    chromosomes.push Chromosome.new([ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 ])
    chromosomes.push Chromosome.new([ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ])
    chromosomes.push Chromosome.new([ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ])
    chromosomes.push Chromosome.new([ 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ])
    chromosomes.push Chromosome.new([ 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 ])
    chromosomes.push Chromosome.new([ 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 ])
    chromosomes.push Chromosome.new([ 8, 8, 8, 8, 8, 8, 8, 8, 8, 8 ])
    chromosomes.push Chromosome.new([ 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 ])
    chromosomes.push Chromosome.new([ 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 ])
    @cchtga.chromosomes = chromosomes
    subsystem_1 = Subsystem.new([ 0, 2, 4, 6, 8 ])
    subsystem_1.chromosomes = [ Chromosome.new([ 1, 1, 1, 1, 1 ]),
                                Chromosome.new([ 2, 2, 2, 2, 2 ]),
                                Chromosome.new([ 3, 3, 3, 3, 3 ]),
                                Chromosome.new([ 4, 4, 4, 4, 4 ]),
                                Chromosome.new([ 5, 5, 5, 5, 5 ]),
                                Chromosome.new([ 6, 6, 6, 6, 6 ]),
                                Chromosome.new([ 7, 7, 7, 7, 7 ]),
                                Chromosome.new([ 8, 8, 8, 8, 8 ]),
                                Chromosome.new([ 9, 9, 9, 9, 9 ]),
                                Chromosome.new([ 10, 10, 10, 10, 10 ]) ]
    subsystem_1.best_chromosomes_experiences = [ Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]) ]
    subsystem_1.best_chromosome = Chromosome.new([ 5, 5, 5, 5, 5 ])
    subsystem_2 = Subsystem.new([ 1, 3, 5, 7, 9 ])
    subsystem_2.chromosomes = [ Chromosome.new([ 1, 1, 1, 1, 1 ]),
                                Chromosome.new([ 2, 2, 2, 2, 2 ]),
                                Chromosome.new([ 3, 3, 3, 3, 3 ]),
                                Chromosome.new([ 4, 4, 4, 4, 4 ]),
                                Chromosome.new([ 5, 5, 5, 5, 5 ]),
                                Chromosome.new([ 6, 6, 6, 6, 6 ]),
                                Chromosome.new([ 7, 7, 7, 7, 7 ]),
                                Chromosome.new([ 8, 8, 8, 8, 8 ]),
                                Chromosome.new([ 9, 9, 9, 9, 9 ]),
                                Chromosome.new([ 10, 10, 10, 10, 10 ]) ]
    subsystem_2.best_chromosomes_experiences = [ Chromosome.new([ 3, 3, 3, 3, 3 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]),
                                                 Chromosome.new([ 0, 0, 0, 0, 0 ]) ]
    subsystem_2.best_chromosome = Chromosome.new([ 4, 4, 4, 4, 4 ])
    @cchtga.subsystems = [ subsystem_1, subsystem_2 ]
    @cchtga.selected_func = lambda { |x| x.map { |xi| xi**2 }.inject(:+) }
    @cchtga.best_chromosome = Chromosome.new([ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
    @cchtga.best_chromosome.fitness = 10
  end
  
  step 'the cooperative coevolution is applied, the best experience should have been updated' do
    @cchtga.cooperative_coevolution
    expect(@cchtga.subsystems.last.best_chromosome).to eq (Chromosome.new([0, 0, 0, 0, 0]))
    expect(@cchtga.subsystems.last.best_chromosomes_experiences.first).to eq (Chromosome.new([1, 1, 1, 1, 1]))
  end
end
