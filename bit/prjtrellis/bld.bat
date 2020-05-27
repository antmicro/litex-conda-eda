@echo on

python -c "print(r'%PREFIX%'.replace('\\','/'))" > temp.txt
set /p BASH_PREFIX=<temp.txt
del temp.txt

REM Install boost with vcpkg
git clone --branch 2019.11 https://github.com/microsoft/vcpkg.git --single-branch
cd vcpkg
echo set(VCPKG_BUILD_TYPE release)>> triplets/x64-windows.cmake
powershell -Command "bootstrap-vcpkg.bat -disableMetrics"
if errorlevel 1 exit 1
vcpkg install boost-filesystem:x64-windows boost-program-options:x64-windows boost-thread:x64-windows boost-python:x64-windows boost-dll:x64-windows
if errorlevel 1 exit 1

REM Compile and install libtrellis
cd ..\libtrellis
cmake -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-windows -DBUILD_PYTHON=ON -DBUILD_SHARED=ON -DSTATIC_BUILD=OFF "-DCMAKE_INSTALL_PREFIX=%BASH_PREFIX%" .
if errorlevel 1 exit 1
find .. -name '*trellis*'
cmake --build . --target install --config Release
if errorlevel 1 exit 1
