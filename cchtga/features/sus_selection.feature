# language: en
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-04-25

Feature: SUS selection operation

    @test_sus_selection_positive_fitness
    Scenario: Test the SUS selection operation with positive fitness
        Given the positive fitness values of some chromosomes:
            | 1 | 15 | 23 | 1 | 5 | 7 | 8 |
        And the required number of selections is 3
        When I execute the SUS selection operation for miminization of positive fitness values
        Then there should be an array of pointers corresponding to the selected individuals

    @test_sus_selection_negative_fitness
    Scenario: Test the SUS selection operation with negative fitness
        Given the negative fitness values of some chromosomes:
            | -1 | -15 | -23 | -1 | -5 | -7 | -8 |
        And the required number of selections is 3
        When I execute the SUS selection operation for miminization of negative fitness values
        Then there should be an array of pointers corresponding to the selected individuals
