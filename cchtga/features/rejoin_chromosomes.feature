# language: en
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-08-01

Feature: Rejoin the subchromosomes into chromosomes  

  @test_rejoin_operation
  Scenario: Rejoin the subchromosomes into chrosmosomes 
    Given the subsystem with chromosomes:
      | 1 | 5 | -4 |
      | 1 | 1 | 4 | 
      | 4 | 4 | 0 |
    And this subsystem has the variables:
      | 0 | 2 | 5 | 
    And if the systems chromosomes are:
      | 2 | 4 | 1 | 9 | 8 | 7 |
      | 3 | 0 | 4 | 5 | 9 | 2 |
      | 0 | 1 | 8 | 4 | 5 | 2 |
    When the rejoin operation is apply
    Then the systems's chromosomes should be:
      | 1 | 4 | 5 | 9 | 8 | -4 |
      | 1 | 0 | 1 | 5 | 9 | 4 |
      | 4 | 1 | 4 | 4 | 5 | 0 |