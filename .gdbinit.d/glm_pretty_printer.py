# modified from https://gitlab.uni-koblenz.de/MedVis/PFE_Tree-like_Structures/blob/public_master/gdb_prettyprinter.py
# usage for debugging with gdb:
# gdb -x gdb_prettyprinter.py bin/*your_executable*
# (gdb) break *linenumber*
# (gdb) run
# (gdb) print *name_of_the_variable*

# incase i forgot:
# start python interactive mode in gdb : pi
#                                        import gdb.types
# get gdb.Value : val = gdb.parse_and_eval("exp")
# get gdb.Type from gdb.Value : btype = gdb.types.get_basic_type(val.type)

import gdb.printing
import numpy

_type_letters = {
    gdb.TYPE_CODE_FLT: "f",
    gdb.TYPE_CODE_INT: "i",
    gdb.TYPE_CODE_BOOL: "b"
}

def _vec_info(v):

    # modern glm::vec prototype is vec<int, T, Q>
    T = v.type.template_argument(1)
    letter = _type_letters.get(T.code, "t")
    length = v.type.sizeof // T.sizeof

    # gdb.type.array is upper bound inclusive
    V = v.address.cast(T.array(length-1).pointer()).dereference()
    # print(V.__class__)
    items = list(float(V[i]) for i in range(length))
    return letter, length, items

class VecPrinter:
    def __init__(self, v):
        self.v = v

    def to_string(self):
        letter, length, items = _vec_info(self.v)
        return "{}vec{}: {}".format(letter, length, str(numpy.matrix(items)))


class MatPrinter:
    def __init__(self, v):
        self.v = v

    def to_string(self):
        V = self.v["value"]
        columns = []
        for i in range(V.type.range()[1] + 1):
            letter, length, items = _vec_info(V[i])
            columns.append(items)
        return "{}mat{}x{}: \n{}".format(
            letter, len(columns), length, str(numpy.matrix(columns)))

def build_pretty_printer():
    pp = gdb.printing.RegexpCollectionPrettyPrinter("glm_pp")
    pp.add_printer("glm::vec", "^glm::vec<.*>$", VecPrinter)
    pp.add_printer("glm::mat", "^glm::mat<.*>$", MatPrinter)
    # pp.add_printer("glm::vec", "^glm::tvec\d<[^<>]*>$", VecPrinter)
    # pp.add_printer("glm::mat", "^glm::tmat\dx\d<[^<>]*>$", MatPrinter)
    return pp

numpy.set_printoptions(precision=6, suppress=True)
gdb.printing.register_pretty_printer(gdb.current_objfile(), build_pretty_printer())
print('glm::vec pretty-printing enabled')
print('glm::mat pretty-printing enabled')
