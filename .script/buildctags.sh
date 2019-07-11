#/bin/bash
ctags -R --sort=foldcase --excmd=number --fields=ksSi --links=yes --language-force=c++ --c++-kinds=+p --c-kinds=+p --exclude=build --exclude=cmake --exclude=CMake
