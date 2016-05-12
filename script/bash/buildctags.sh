#/bin/bash
ctags -R --sort=foldcase --links=yes --c++-kinds=+p --c-kinds=+p --exclude=build --exclude=cmake --exclude=CMake
