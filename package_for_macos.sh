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

# Array of Python versions
versions=("3.9" "3.10" "3.11" "3.12")

# Loop over each Python version
for version in "${versions[@]}"; do
    echo "Building centrosome for Python $version"

    # Create and activate a dedicated python environment
    conda create -n centrosome-build python=$version -y
    conda activate centrosome-build

    # Install dependencies
    python -m pip install .

    # Delete build and dist folders to ensure clean build
    rm -fR build
    rm -fR dist

    # Build the source and binary packages
    python setup.py sdist
    python setup.py bdist_wheel

    # Move them to the release directory
    mv dist/*.tar.gz release/
    mv dist/*.whl release/

    # Remove the conda environment
    conda deactivate
    conda env remove -n centrosome-build -y
done
