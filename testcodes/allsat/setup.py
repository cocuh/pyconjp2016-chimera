from distutils.core import setup, Extension
from Cython.Build import cythonize
import os
import glob

os.environ['CC']='g++'

SAT_SOLVER_NAME = 'minisat'

source_files = [
    filename
    for filename
    in glob.glob('./{}/core/*.cc'.format(SAT_SOLVER_NAME)) + glob.glob('./{}/simp/SimpSolver.cc'.format(SAT_SOLVER_NAME))
    if not 'Main' in filename
]

modules = [
    Extension(
        'allsat',
        sources=['allsat.pyx'] + source_files,
        language='c++',
        extra_compile_args=['-std=c++11', '-w'],
        include_dirs=['./{}'.format(SAT_SOLVER_NAME)]
    )
]


setup(
    name="allsat",
    ext_modules=cythonize(modules),
)
