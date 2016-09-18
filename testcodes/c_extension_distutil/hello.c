#include<Python.h>

static PyObject *
hello(PyObject *self, PyObject *args)
{
    const char *name;
    if (!PyArg_ParseTuple(args, "s", &name)){return NULL;}

    printf("Hello %s!\n", name);
    Py_RETURN_NONE;
}

static PyMethodDef methods[] = {
    {"hello", (PyCFunction)hello, METH_VARARGS, "hello function\n"},
};

static struct PyModuleDef moduledef = {PyModuleDef_HEAD_INIT,"hello", NULL, 0, methods, NULL, NULL, NULL, NULL,};

PyMODINIT_FUNC
PyInit_hello(void)
{
#if PY_MAJOR_VERSION >= 3
    PyObject *module = PyModule_Create(&moduledef);
#else
    PyObject *module = Py_initModule("hello", methods);
#endif
    return module;
}


