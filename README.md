C, C++ and Fortran boilerplate.

For a template which already has this installed as submodule use: <https://github.com/cirosantilli/cpp-template>.

Intended usage: include as a submodule, and symlink into files you want to use, which can be automated with `./install`. See [Install](#install) for more details.

#Usage from main project

Clone the main project with the `--recursive` flag:

    git clone --recursive https://github.com/USER/RESPOSITORY.git

If you forgot to use `--recursive` when cloning do:

    git submodule init
    git submodule update

List all commands with:

    make help

Automatic install of dependencies is available for certain systems with:

    ./configure

If this is not the case for you system, the command will inform you which dependencies are needed.

If automatic install is not available for your system, you may want to run on a VirtualBox Vagrant virtual machine with:

    vagrant up

Compile and run with:

    make run

Run tests with:

    make test

Clean up generated files with:

    make clean

#Configure

There are many configuration options which can be set on a per project basis with configuration files without altering boilerplate files.

Those files are not included in the boilerplate because they are meant to be modified.

The configuration files are:

- `Makefile_params`
- `Makefile_targets`
- `Vagrantfile_params`

All configuration options are documented in the configuration file templates at: <https://github.com/cirosantilli/cpp-template>

#Vim

The `.vimrc` offers the following mappings:

- `<F5>`: `make`
- `<F6>`: `make run`

We recommend that you use a plug-in that auto sources that file such as: <https://github.com/MarcWeber/vim-addon-local-vimrc>

#Install

Install on an existing project with:

    git submodule add https://github.com/cirosantilli/latex-submodule shared
    cd `shared`
    ./install

This generates two kinds of files symlinks from the main repository to this submodule, e.g.:

    Makefile -> boilerplate/Makefile_one
    .gitignore -> boilerplate/.gitignore

Your existing files won't be overwritten.
