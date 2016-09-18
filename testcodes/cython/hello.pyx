from libc.stdio cimport printf


def hello(name: str):
    cdef bytes name_c = name.encode()
    printf(b"hello %s!\n", name_c)
