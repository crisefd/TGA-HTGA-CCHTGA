# language: en
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-2-22

Feature: Calculate the SNR value for a given chromosome

  Scenario: Find the SNR of the smaller-the better caracteristic
  Given the chromosome
  |32|36|37|38|40|
  Then the SNR for minimization should be -31.29 dB

  Scenario: Find the SNR of the smaller-the better caracteristic
  Given the chromosome
  |30|34|38|39|42|
  Then the SNR for minimization should be -31.33 dB

  Scenario: Find the SNR of the larger-the better caracteristic
  Given the chromosome
  |32|36|37|38|40|
  Then the SNR for maximization should be 31.20 dB

  Scenario: Find the SNR of the larger-the better caracteristic
  Given the chromosome
  |30|34|38|39|42|
  Then the SNR for maximization should be 31.09 dB
