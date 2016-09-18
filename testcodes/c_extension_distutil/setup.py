from distutils.core import setup, Extension

module = Extension('hello', sources=['hello.c'])

setup(
    name='hello',
    version='0.01',
    ext_modules = [module],
)
