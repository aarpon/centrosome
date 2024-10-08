from __future__ import absolute_import
import glob
import os.path
import sys

import numpy as np
import setuptools
import setuptools.command.build_ext
import setuptools.command.test

try:
    import Cython
    import Cython.Build

    __cython = True
except ImportError:
    __cython = False


class BuildExtension(setuptools.command.build_ext.build_ext):
    def build_extensions(self):
        numpy_includes = np.get_include()

        for extension in self.extensions:
            if (
                hasattr(extension, "include_dirs")
                and numpy_includes not in extension.include_dirs
            ):
                extension.include_dirs.append(numpy_includes)

            extension.include_dirs.append("centrosome/include")

        setuptools.command.build_ext.build_ext.build_extensions(self)


class Test(setuptools.command.test.test):
    user_options = [("pytest-args=", "a", "Arguments to pass to py.test")]

    def initialize_options(self):
        setuptools.command.test.test.initialize_options(self)

        self.pytest_args = []

    def finalize_options(self):
        setuptools.command.test.test.finalize_options(self)

        self.test_args = []

        self.test_suite = True

    def run_tests(self):
        import pytest

        errno = pytest.main(self.pytest_args)

        sys.exit(errno)


if __cython:
    __suffix = "pyx"
    __extkwargs = {
        "language": "c++",
        "define_macros": [("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")]
    }
else:
    __suffix = "cpp"
    __extkwargs = {}

# Determine the compiler flags based on the operating system
if sys.platform.startswith('win'):
    # Windows specific flags for MSVC
    extra_compile_args = ['/wd4267']
else:
    # Linux/Unix/MacOS, using GCC or Clang
    extra_compile_args = ['-Wno-error=int-conversion']

__extensions = [
    setuptools.Extension(
        name="centrosome._propagate",
        sources=[
            "centrosome/_propagate.{}".format("c" if __suffix == "cpp" else __suffix)
        ],
        define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")] if __suffix == "pyx" else None,
        extra_compile_args=extra_compile_args,
    )
]

for pyxfile in glob.glob(os.path.join("centrosome", "*.pyx")):
    name = os.path.splitext(os.path.basename(pyxfile))[0]

    if name == "_propagate":
        continue

    __extensions += [
        setuptools.Extension(
            name="centrosome.{}".format(name),
            sources=["centrosome/{}.{}".format(name, __suffix)],
            **__extkwargs,
            extra_compile_args=extra_compile_args,
        )
    ]

if __suffix == "pyx":
    __extensions = Cython.Build.cythonize(__extensions, language_level="3")

setuptools.setup(
    author="Nodar Gogoberidze",
    author_email="ngogober@broadinstitute.org",
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Science/Research",
        "License :: OSI Approved :: BSD License",
        "Operating System :: OS Independent",
        "Programming Language :: C",
        "Programming Language :: C++",
        "Programming Language :: Cython",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Topic :: Scientific/Engineering :: Bio-Informatics",
        "Topic :: Scientific/Engineering",
    ],
    cmdclass={"build_ext": BuildExtension, "test": Test},
    description="An open source image processing library",
    ext_modules=__extensions,
    extras_require={
        "dev": ["black>=22.3.0", "pre-commit>=3.6.0"],
        "test": ["pytest>=8.0.0"],
    },
    install_requires=[
        "deprecation>=2.1",
        "matplotlib>=3.9.2",
        "numpy<=2.00",
        "pillow>=10.4.0",
        "scikit-image>=0.24.0",
        "scipy>1.14.0",
    ],
    tests_require=[
        "pytest",
    ],
    keywords="",
    license="BSD",
    long_description="This version is forked by Aaron Ponti @ ETH Zurich to add support for newer versions of Python and dependencies.",
    name="centrosome",
    packages=["centrosome"],
    setup_requires=["cython", "numpy", "pytest", "wheel",],
    url="https://github.com/CellProfiler/centrosome",
    version="1.3.0",
)
