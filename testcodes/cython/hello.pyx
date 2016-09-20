cimport libc.stdio

def hello(name: str):
    cdef bytes name_c = name.encode()
    libc.stdio.printf(b"hello %s!\n", name_c)
