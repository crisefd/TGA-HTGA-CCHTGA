# Implementation of a Traditional Genetic Algorithm, the Hybrid-Taguchi Genetic Algorithm and the Cooperative Coevolutive Hybrid-Taguchi Genetic Algorithm

## References
- [TGA](http://eisc.univalle.edu.co/~angarcia/ce/ce_clases/ce-02_GA.pdf)
- [HTGA](https://pdfs.semanticscholar.org/9798/536bb2654af9f0fe668a28694ae3ea514b88.pdf)
- [CCHTGA](http://www.nt.ntnu.no/users/skoge/prost/proceedings/ifac2014/media/files/2299.pdf)

## Installation in Ubuntu
### RVM (Ruby Version Manager)

- Getting mpapis public key

`$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3`

- Download an install with curl

`$ \curl -sSL https://get.rvm.io | bash -s stable --ruby`

- Source (you should probably add this to your .bashrc or .bash_profile)

`$ source ~/.rvm/scripts/rvm`

### Ruby (2.2.1 version)

- Update sources lists

`$ apt-get update`

- Install with RVM

`$ rvm install 2.2.1`

- Install documentation for that version (optional)

`$ rvm docs generate-ri`

- Select the version

`$ rvm use 2.2.1`

### Required Gems

- First install bundler

`$ gem install bundler`

- Now go to the project's root folder and install the rest of the gems with

`$ bundler install`

## Running

- You run the genetic algorithms with

`$ ruby <algorithm> <path to ini test file(s)>`

The available values for `<algorithm>` are `tga`, `htga`, `cchtga`, `tga_knapsack` and `htga_knapsack`

`<path to ini test file(s)>` is usually a .ini file or subdirectory in the `test_cases/` directory

For example: `$ ruby htga test_cases/htga/dummy/f2_test.ini`

- Running the tests

You go to each of the algorithms folders and execute: `$ bundle exec cucumber`


