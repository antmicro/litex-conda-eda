@echo on

set CPU_COUNT=2
python -c "print(r'%PREFIX%'.replace('\\','/'))" > temp.txt
set /p BASH_PREFIX=<temp.txt
del temp.txt

echo PREFIX := %BASH_PREFIX%>Makefile.conf

make -C fasm-plugin install
make -C xdc-plugin install
