C, C++ and Fortran boilerplate to factor code across multiple projects.

For a template which already has this installed as submodule use: <https://github.com/cirosantilli/cpp-template>.

# Usage from main project

Clone the main project with the `--recursive` flag:

    git clone --recursive https://github.com/USER/RESPOSITORY.git

If you forgot to use `--recursive` when cloning do:

    git submodule init
    git submodule update

List all commands with:

    make help

Automatic install of dependencies may be available on each project through targets of type:

    make deps

Compile and run with:

    make run

Run tests with:

    make test

Clean up generated files with:

    make clean

# Install

Install on an existing project with:

    git submodule add https://github.com/cirosantilli/latex-submodule shared
    cd `shared`
    ./install

This generates two kinds of files:

- symlinks which you are unlikely to modify, e.g.:

        Makefile -> boilerplate/Makefile_one
        .gitignore -> boilerplate/.gitignore

    Those files can be customized through external configuration files, e.g. `Makefile_params` and configures `Makefile`.

- regular file templates which your are likely to modify:

    - `Makefile_params`
    - `Makefile_targets`

`git add` all the generated files you want to keep.
