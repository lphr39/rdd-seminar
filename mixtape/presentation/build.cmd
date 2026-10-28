@echo off
setlocal
cd /d "%~dp0"
if not exist "build" mkdir "build"
python build_tables.py
if errorlevel 1 exit /b 1
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build rdd_seminar.tex
if errorlevel 1 exit /b 1
biber --input-directory=build --output-directory=build rdd_seminar
if errorlevel 1 exit /b 1
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build rdd_seminar.tex
if errorlevel 1 exit /b 1
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=build rdd_seminar.tex
if errorlevel 1 exit /b 1
copy /y "build\rdd_seminar.pdf" "rdd_seminar.pdf" >nul
if errorlevel 1 exit /b 1
echo Built rdd_seminar.pdf
exit /b 0
