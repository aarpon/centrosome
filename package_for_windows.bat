@ECHO OFF
setlocal

IF "%ANACONDA_HOME%"=="" ECHO Please set environment variable ANACONDA_HOME. && exit /b

REM Create release folder
rmdir /s /q release
mkdir release

REM Loop through the Python versions using a for loop
FOR %%V IN (3.9, 3.10, 3.11, 3.12) DO (
    ECHO Building centrosome for Python %%V

    REM Create and activate a dedicated Python environment
    call conda create -n centrosome-build python=%%V -y
    call conda activate centrosome-build

    REM Install dependencies
    call poetry install

    REM Delete build and dist folders
    IF EXIST build rmdir /s /q build
    IF EXIST dist rmdir /s /q dist

    REM Build the binary package
    call python setup.py bdist_wheel

    REM Move it to release
    IF NOT EXIST release mkdir release
    move /Y dist\*.whl release\

    REM Remove the conda environment
    call conda deactivate
    call conda env remove -n centrosome-build -y
    IF EXIST "%ANACONDA_HOME%\envs\centrosome-build" rmdir /s /q "%ANACONDA_HOME%\envs\centrosome-build"
)