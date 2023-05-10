@ECHO OFF
setlocal

IF "%ANACONDA_HOME%"=="" ECHO Please set environment variable ANACONDA_HOME. && exit /b

REM Create release folder
rmdir /s /q release
mkdir release

REM
REM Python 3.9
REM

REM Create and activate a dedicated python 3.9 env
call conda create -n centrosome-build python=3.9 -y
call conda activate centrosome-build

REM Install dependencies
poetry install

REM Delete build and dist folders
rmdir /s /q build
rmdir /s /q dist

REM Build the binary package
python setup.py bdist_wheel

REM Move it to release
move /Y dist\*.whl release

REM Remove the conda environment
call conda deactivate
call conda env remove -n centrosome-build
IF EXIST "%ANACONDA_HOME%"\envs\centrosome-build rmdir /s /q "%ANACONDA_HOME%"\envs\centrosome-build

REM
REM Python 3.10
REM

REM Create and activate a dedicated python 3.10 env
call conda create -n centrosome-build python=3.10 -y
call conda activate centrosome-build

REM Install dependencies
poetry install

REM Delete build and dist folders
rmdir /s /q build
rmdir /s /q dist

REM Build the binary package
python setup.py bdist_wheel

REM Move it to release
move /Y dist\*.whl release

REM Remove the conda environment
call conda deactivate
call conda env remove -n centrosome-build
IF EXIST "%ANACONDA_HOME%"\envs\centrosome-build rmdir /s /q "%ANACONDA_HOME%"\envs\centrosome-build

REM
REM Python 3.11
REM

REM Create and activate a dedicated python 3.11 env
call conda create -n centrosome-build python=3.11 -y
call conda activate centrosome-build

REM Install dependencies
poetry install

REM Delete build and dist folders
rmdir /s /q build
rmdir /s /q dist

REM Build the binary package
python setup.py bdist_wheel

REM Move it to release
move /Y dist\*.whl release

REM Remove the conda environment
call conda deactivate
call conda env remove -n centrosome-build
IF EXIST "%ANACONDA_HOME%"\envs\centrosome-build rmdir /s /q "%ANACONDA_HOME%"\envs\centrosome-build
