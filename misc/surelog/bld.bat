@echo on

REM gcc requires path with slashes not backslashes
python -c "print(r'%PREFIX%'.replace('\\','/'))" > temp.txt
set /p BASH_PREFIX=<temp.txt
python -c "print(r'%BUILD_PREFIX%'.replace('\\','/'))" > temp.txt
set /p BASH_BUILD_PREFIX=<temp.txt
del temp.txt


set CXXFLAGS="%CXXFLAGS% -I%BASH_BUILD_PREFIX%/include"
set LDFLAGS="%CXXFLAGS% -L%BASH_BUILD_PREFIX%/lib"
set CC="x86_64-w64-mingw32-gcc"

make
make install
