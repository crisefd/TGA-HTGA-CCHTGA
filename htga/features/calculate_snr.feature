# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-2-22

Feature: Calculate the SNR value for a given chromosome

  Scenario: Find the SNR of the smaller-the better caracteristic (minimization)
  Given the chromosome
  |32|36|37|38|4|
  Then the SNR should be -31.29 dB

  Scenario: Find the SNR of the larger-the better caracteristic (maximization)
  Given the chromosome
  |30|34|38|39|42|
  Then the SNR should be -31.33 dB
