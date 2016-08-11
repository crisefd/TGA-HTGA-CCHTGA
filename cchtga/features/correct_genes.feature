# language: en
# encoding: utf-8
# author: Cristhian Fuertes
# email:  cristhian.fuertes@correounivalle.edu.co
# creation date: 2016-04-27
Feature: Correct genes operation

    Scenario: Test gene correction rule for upper bound in cchtga
        Given the best chromosome:
            | 1 | 15 | 13 | 1 | 5 | 7 | 8 | 6 |
        And the upper bounds fo the best chromosome are:
            | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
        And the lower bounds of the best chromosome are:
            | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
        When the correct gene rule is apply
        Then the corrected chromosome should be:
            | 1 | 5 | 7 | 1 | 5 | 7 | 8 | 6 |

    Scenario: Test gene correction rule for lower bound in cchtga
        Given the best chromosome:
            | 1 | 15 | 13 | 1 | -5 | 7 | 8 | -6 |
        And the upper bounds fo the best chromosome are:
            | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
        And the lower bounds of the best chromosome are:
            | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
        When the correct gene rule is apply
        Then the corrected chromosome should be:
            | 1 | 5 | 7 | 1 | 7 | 7 | 8 | 8 |

    Scenario: Test the gene correction with several recursive calls
        Given the best chromosome:
            | 1 | 21 | 13 | 1 | -15 | 32 | 7 | 8 |
        And the upper bounds fo the best chromosome are:
            | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
        And the lower bounds of the best chromosome are:
            | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
        When the correct gene rule is apply
        Then the corrected genes in chromosome should be in between the upper and lower bounds
