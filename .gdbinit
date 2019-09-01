source ~/.gdbinit.d/glm_pretty_printer.py

# https://sourceware.org/gdb/wiki/STLSupport
# you may download python by:
#   svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python
python
import sys
sys.path.insert(0, '/usr/local/source/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
