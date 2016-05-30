# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-04-29

Feature: Update best chromosome with jth part of subsystem


    Scenario: Test the replacement of the jth part of subsystem j best chromosome in global best chromosome for a minimization problem
        Given the global best chromosome:
            | 1 | 15 | 13 | 1 | 5 | 7 | 8 | 6 | -1 |
        And the subsystem with the variables:
            | 1 | 3 | 8 |
        And the subsystem's best chromosome:
            | -6 | -6 | -6 |
        And the objective function is the sum of xi
        And the objective functions is to be minimize
        When the update of best chromosome operation is apply
        Then the updated global chromosome should be:
            | 1 | -6 | 13 | -6 | 5 | 7 | 8 | 6 | -6 |
