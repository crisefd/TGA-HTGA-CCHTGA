# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-05-26

Feature: Calculate the SNR value for a given chromosome

  Scenario: Find the SNR of the smaller-the better caracteristic
  Given the chromosome:
  |2|3|3|3|4|
  And a best chromosome with a fitness value of 12
  Then the SNR for minimization should be "1/1225"