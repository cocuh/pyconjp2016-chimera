from libcpp.vector cimport vector
from libcpp cimport bool
from libcpp.string cimport string as cppstring
from cython.operator cimport dereference as deref
ctypedef unsigned char uint8_t

cdef extern from "core/SolverTypes.h" namespace "Glucose":
    cdef struct Lit:
        int x
        Lit(int)

    cdef cppclass lbool:
        lbool(uint8_t)
        bool operator== (lbool)
        bool operator!= (lbool)

cdef extern from "mtl/Vec.h" namespace "Glucose":
    cdef cppclass vec[T]:
        vec()
        vec(int, T)
        void push()
        void push(T)
        void glowTo(int)
        int size()
        void clear()
        T& operator[](int)

cdef extern from "core/Solver.h" namespace "Glucose":
    cdef cppclass Solver:
        vec[lbool] model;
        int verbosity
        Solver()
        bool addClause(vec[Lit])
        bool solve()
        bool solve(vec[Lit])
        bool okay()
        int nVars()
        int nClauses()
        void newVar()
        void setIncrementalMode()
        bool satisfied()
        lbool modelValue(int)
        void budgetOff()

cdef inline Lit mkLit(int var, bool sign):
    cdef Lit p
    cdef int x = var + var + <int>sign;
    p.x = var + var + <int>sign;
    return p


