C, C++ and Fortran boilerplate to factor code across multiple projects.

For a template which already has this installed as submodule use: <https://github.com/cirosantilli/cpp-template>.

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
