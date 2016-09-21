from setuptools import setup
from rust_ext import build_rust, install_with_rust, RustModule

rust_modules = [
    RustModule(
            'youjo.hello',
            'hello/Cargo.toml',
    ),
    RustModule(
            'youjo.sort',
            'sort/Cargo.toml',
    ),
    RustModule(
            'youjo.math',
            'math/Cargo.toml',
    ),
]

setup(
        name='sort',
        version='0.0.1',
        cmdclass={
            'build_rust': build_rust,
            'install_lib': install_with_rust,
        },
        options={
            'build_rust': {
                'modules': rust_modules,
            }
        },
        zip_safe=False,
)
