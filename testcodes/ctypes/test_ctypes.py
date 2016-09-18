import ctypes

libc = ctypes.CDLL('/usr/lib/libc.so.6')
libc.printf(b"Hello %s!\n", b"Youjo")
