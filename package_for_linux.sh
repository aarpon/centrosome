# Copyright (c) 2022 - 2023 D-BSSE, ETH Zurich.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
#  limitations under the License.
#

# Create release folder
rm -fR release
mkdir release

if [[ -z "$ANACONDA_HOME" ]]; then
    echo "Please set environment variable ANACONDA_HOME." 1>&2
    exit 1
fi

# Source conda.sh
source $ANACONDA_HOME/etc/profile.d/conda.sh

#
# Python 3.9
#

# Create and activate a dedicated python 3.9 env
conda create -n centrosome-build python=3.9 -y
conda activate centrosome-build

# Install dependencies
poetry install

# Delete build and dist folders
rm -fR build
rm -fR dist

# Build the binary package
python setup.py bdist_wheel

# Move it to release
mv dist/*.whl release/

# Remove the conda environment
conda deactivate
conda env remove -n centrosome-build -y

#
# Python 3.10
#

# Create and activate a dedicated python 3.10 env
conda create -n centrosome-build python=3.10 -y
conda activate centrosome-build

# Install dependencies
poetry install

# Delete build and dist folders
rm -fR build
rm -fR dist

# Build the binary package
python setup.py bdist_wheel

# Move it to release
mv dist/*.whl release/

# Remove the conda environment
conda deactivate
conda env remove -n centrosome-build -y

#
# Python 3.11
#

# Create and activate a dedicated python 3.11 env
conda create -n centrosome-build python=3.11 -y
conda activate centrosome-build

# Install dependencies
poetry install

# Delete build and dist folders
rm -fR build
rm -fR dist

# Build the source and binary packages
python setup.py sdist
python setup.py bdist_wheel

# Move them to release
mv dist/*.tar.gz release/
mv dist/*.whl release/

# Remove the conda environment
conda deactivate
conda env remove -n centrosome-build -y

#
# Python 3.12
#

# Create and activate a dedicated python 3.12 env
conda create -n centrosome-build python=3.12 -y
conda activate centrosome-build

# Install dependencies
poetry install

# Delete build and dist folders
rm -fR build
rm -fR dist

# Build the source and binary packages
python setup.py sdist
python setup.py bdist_wheel

# Move them to release
mv dist/*.tar.gz release/
mv dist/*.whl release/

# Remove the conda environment
conda deactivate
conda env remove -n centrosome-build -y

