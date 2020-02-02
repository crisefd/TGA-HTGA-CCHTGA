# language: en
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-04-30

Feature: Update subsystem's best experiences of chromosomes


    Scenario: Test the update of a subsystem's  best experiences of chromosomes for a minimization problem without negative fitness values
        Given the subsystem's population of chromosomes:
            | 4 | 3 | 2 |
            | 5 | 4 | 9 |
            | 7 | 7 | 7 |
        And the current subsystem's best experiences of chromosomes:
            | 2 | 1 | 1 |
            | 6 | 9 | 9 |
            | 8 | 8 | 8 |
        And the objective function for this problem is the sum of zi
        And the objective function value for this problem is to be minimize
        When the update of subsystem's best experiences of chromosomes operation is apply
        Then the updated subsystems's best experiences of chromosomes should be:
            | 2 | 1 | 1 |
            | 5 | 4 | 9 |
            | 7 | 7 | 7 |
