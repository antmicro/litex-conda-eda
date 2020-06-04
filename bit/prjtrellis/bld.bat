@echo on

python -c "print(r'%PREFIX%'.replace('\\','/'))" > temp.txt
set /p BASH_PREFIX=<temp.txt
del temp.txt

REM Install boost with vcpkg
git clone --branch 2019.11 https://github.com/microsoft/vcpkg.git --single-branch
cd vcpkg
echo set(VCPKG_BUILD_TYPE release)>> triplets/x64-windows-static.cmake
powershell -Command "bootstrap-vcpkg.bat -disableMetrics"
if errorlevel 1 exit 1
vcpkg install boost-filesystem:x64-windows-static boost-program-options:x64-windows-static boost-thread:x64-windows-static boost-python:x64-windows-static boost-dll:x64-windows
if errorlevel 1 exit 1

REM Compile and install libtrellis
cd ..\libtrellis
cmake -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-windows-static -DBUILD_PYTHON=ON -DBUILD_SHARED=OFF -DSTATIC_BUILD=OON "-DCMAKE_INSTALL_PREFIX=%BASH_PREFIX%" .
if errorlevel 1 exit 1
find .. -name '*trellis*'
cmake --build . --target install --config Release
md %PREFIX%\lib\trellis
cp %SRC_DIR%/Release/pytrellis.lib %PREFIX%/lib/trellis/
cp %SRC_DIR%/Release/trellis.lib %PREFIX%/lib/trellis/
if errorlevel 1 exit 1
