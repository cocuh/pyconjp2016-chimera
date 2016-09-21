#![crate_type = "dylib"]
#[macro_use]
extern crate cpython;

use std::thread;
use std::sync::{Arc, Mutex};
use cpython::{PyResult, Python, PyList, ToPyObject};

py_module_initializer!(sort, initsort, PyInit_sort, |py, m| {
    try!(m.add(py, "__doc__", "sleep sort"));
    try!(m.add(py, "sleep_sort", py_fn!(py, sleep_sort(py_args: PyList))));
    Ok(())
});


fn sleep_sort(py: Python, py_args: PyList) -> PyResult<PyList> {

    // convert Python object to Rust object
    let args: Vec<u32> = py_args.iter(py)
        .map(|x| x.extract(py))
        .filter(|x| x.is_ok())
        .map(|x| x.ok().unwrap())
        .collect::<Vec<_>>();

    // generate workers
    let result = Arc::new(Mutex::new(Vec::<u32>::new()));
    let workers = args.into_iter().map(|x| {
            let result = result.clone();
            thread::spawn(move || {
                thread::sleep_ms(x * 100);
                let mut result = result.lock().unwrap(); // Rust's COOL mutex!!
                result.push(x);
            })
        })
        .collect::<Vec<_>>();

    // join worker threads
    workers
        .into_iter()
        .map(|x| {
            x.join();
        })
        .collect::<Vec<_>>();

    // convert Rust object to Python object
    let res = result.lock().unwrap().to_py_object(py);
    Ok(res)
}
