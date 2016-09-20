from libcpp.memory cimport shared_ptr
from libcpp.vector cimport vector
from libcpp cimport bool as cppbool
from libcpp.string cimport string as cppstring
from cython.operator cimport dereference as deref

from minisat cimport *

cdef class AllSAT:
    cdef int lit_num
    cdef shared_ptr[Solver] solver
    def __cinit__(self):
        self.lit_num = 0

    def __init__(self, vector[vector[int]]clauses):
        self.solver = shared_ptr[Solver](new Solver())
        self._gen_coustraint(clauses)

    def _gen_coustraint(self, clauses):
        cdef vec[Lit] lits
        for c in clauses:
            lits.clear()
            for l in c:
                var = abs(l) - 1
                sign = l < 0
                while var >= deref(self.solver).nVars():
                    deref(self.solver).newVar()
                lits.push(mkLit(var, sign))
            deref(self.solver).addClause(lits)

    def _append_blocking_clause(self):
        cdef vec[Lit] lits
        cdef cppbool b
        lits.clear()
        for idx in range(deref(self.solver).nVars()):
            if deref(self.solver).model[idx] != lbool(<uint8_t>2):
                b = deref(self.solver).model[idx]!=lbool(<uint8_t>0)
                lits.push(mkLit(idx, b))
        deref(self.solver).addClause(lits)

    def stringify_model(self):
        res = ''
        for idx in range(deref(self.solver).nVars()):
            if deref(self.solver).model[idx] == lbool(<uint8_t>0):
                res += '1'
            elif deref(self.solver).model[idx] == lbool(<uint8_t>1):
                res += '0'
            else:
                res += '?'
        return res

    def solve(self):
        return deref(self.solver).solve()


    def enumerate(self, debug_print=False):
        count = 0
        deref(self.solver).verbosity = 1 if debug_print else 0
        cdef vec[Lit] blocking_clause
        models = []
        while deref(self.solver).solve():
            blocking_clause.clear()
            for idx in range(deref(self.solver).nVars()):
                is_true = deref(self.solver).model[idx] == lbool(<uint8_t>0)
                blocking_clause.push(mkLit(idx, is_true))
            deref(self.solver).addClause(blocking_clause)

            count += 1

            models.append(self.stringify_model())
        return models

