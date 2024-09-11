# centrosome

Forked from https://github.com/CellProfiler/centrosome to add support for newer versions of Python and some of the dependencies.

## Installation

To install pre-built packages for Python 3.9 - 3.12:

```sh
$ conda create -n centrosome-env python  # python=3.11 for specific version
$ conda activate centrosome-env
$ pip install --extra-index-url https://ia-res.ethz.ch/pypi centrosome
```

For other Python versions, an attempt will be made to compile the dependencies at installation time.

To test the installation, run:

```sh
$ python -c "import centrosome; print(centrosome.__version__)"
1.3.0
```

To build a source distribution and a wheel package from the [source code](https://github.com/aarpon/centrosome):

```sh
$ python setup.py sdist
$ python setup.py bdist_wheel
```

