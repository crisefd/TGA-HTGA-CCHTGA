# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-04-30

Feature: Update subsystem's best chromosome


    Scenario: Test the update of a subsystem best chromosome for a minimization problem without negative fitness values
        Given a subsystem's best chromosome:
            | 8 | 6 | 1 |
        And the subsystem's current population:
            | 1 | 3 | 2 |
            | 3 | 4 | 9 |
            | 1 | 7 | 7 |
        And the objective function for this problem is the sum of xi
        And the objective functions for this problem is to be minimize
        When the update of subsystem's best chromosome operation is apply
        Then the updated subsystems's best chromosome should be:
            | 1 | 3 | 2 |
