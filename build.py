from pathlib import Path
from setuptools import setup, Extension
from Cython.Build import cythonize
import numpy as np


def build_extensions():
    # Define the directory containing the Cython modules
    centrosome_dir = Path("centrosome")

    # Prepare the include directory for all extensions
    numpy_includes = np.get_include()

    # Start with the main extension that must be first
    extensions = [
        Extension(
            name="centrosome._propagate",
            sources=[str(centrosome_dir / "_propagate.pyx")],
            include_dirs=[numpy_includes, "centrosome/include"]
        )
    ]

    # Add other Cython modules from the centrosome directory, excluding '_propagate' that was already processed
    for pyx_file in centrosome_dir.glob("*.pyx"):
        module_name = pyx_file.stem
        if module_name != "_propagate":
            extensions.append(
                Extension(
                    name=f"centrosome.{module_name}",
                    sources=[str(pyx_file)],
                    language="c++",
                    include_dirs=[numpy_includes, "centrosome/include"]
                )
            )

    # Cythonize all extensions
    cythonized_extensions = cythonize(extensions)

    # Return the cythonized extensions
    return cythonized_extensions


if __name__ == "__main__":
    setup(
        name="centrosome",
        packages=["centrosome"],
        ext_modules=build_extensions(),
        version="1.2.2",
        license="BSD 3-Clause"
    )
