# language: en
# author:Cristhian Fuertes
# email: cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-05-03

Feature: randomg grouping of variables

    @test_random_grouping_of_variables
    Scenario: perform random grouping operation
        Given a chromosome with number of genes 200:
        When the random grouping operation is apply
        Then each of the resulting subsystems should have the same number of variables & the sum should be equal to the total number of variables
