# Implementation of a Traditional Genetic Algorithm, the Hybrid-Taguchi Genetic Algorithm and the Cooperative Coevolutive Hybrid-Taguchi Genetic Algorithm

## References
- [TGA](http://eisc.univalle.edu.co/~angarcia/ce/ce_clases/ce-02_GA.pdf)
- [HTGA](https://pdfs.semanticscholar.org/9798/536bb2654af9f0fe668a28694ae3ea514b88.pdf)
- [CCHTGA](http://www.nt.ntnu.no/users/skoge/prost/proceedings/ifac2014/media/files/2299.pdf)

## Installation in Unix Systems
### ASDF Version Manager

- Please follow the installation instructions outlined [here](https://asdf-vm.com/#/core-manage-asdf-vm)
- Then proceed to install [ruby plugin](https://asdf-vm.com/#/core-manage-asdf-vm)


### Ruby (2.7.0 version)

- Install the version

`$ asdf install ruby 2.7.0`

- Set this version either as global or local

`$ asdf global ruby 2.7.0`

`$ asdf local ruby 2.7.0`


### Required Gems

- Install the dependencies with

`$ bundler install`

## Running

- You run the genetic algorithms with

`$ ruby <algorithm> <path to ini test file(s)>`

The available values for `<algorithm>` are `tga`, `htga`, `cchtga`, `tga_knapsack` and `htga_knapsack`

`<path to ini test file(s)>` is usually a .ini file or subdirectory in the `test_cases/` directory

For example: `$ ruby htga test_cases/htga/dummy/f2_test.ini`

- Running the tests

You go to each of the algorithms folders and execute: `$ bundle exec cucumber`


