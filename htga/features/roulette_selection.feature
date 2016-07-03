# language: en
# encoding: utf-8
# file: roulette_selection.feature
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2015-15-11
Feature: Roulette selection operation

    @test_roulette_selection_positive_fitness
    Scenario: Test the roulette selection operation with positive fitness
        Given the positive fitness values of some chromosomes:
            | 1 | 15 | 23 | 1 | 5 | 7 | 8 |
        When I execute the roulette selection operation for maximization of positive fitness values
        Then The calculated probabilities must be:
            | 0.172 | 0.290 | 0.376 | 0.549 | 0.705 | 0.854 | 1.0 |

    @test_roulette_selection_negative_fitness
    Scenario: Test the roulette selection operation with negative fitness
        Given the negative fitness values of some chromosomes:
            | -1 | -15 | -23 | -1 | -5 | -7 | -8 |
        When I execute the roulette selection operation for maximization of negative fitness values
        Then The calculated probabilities must be:
            | 0.106 | 0.280 | 0.492 | 0.599 | 0.724 | 0.859 | 1.0 |
