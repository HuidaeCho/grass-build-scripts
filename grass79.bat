@echo off

rem Change this variable to override auto-detection of python.exe in PATH
set GRASS_PYTHON=C:\Python38\python.exe

rem For portable installation, use %~d0 for the changing drive letter
rem set GRASS_PYTHON=%~d0\Python38\python.exe

set GISBASE=%~dp0
set GRASS_PROJSHARE=%GISBASE%\share\proj

set PROJ_LIB=%GISBASE%\share\proj
set GDAL_DATA=%GISBASE%\share\gdal

rem XXX: Do we need these variables?
rem set GEOTIFF_CSV=%GISBASE%\share\epsg_csv
rem set FONTCONFIG_FILE=%GISBASE%\etc\fonts.conf

if not exist %GISBASE%\etc\fontcap (
	pushd .
	set GISRC=dummy
	cd %GISBASE%\lib
	%GISBASE%\bin\g.mkfontcap.exe
	popd
)

if not exist "%GRASS_PYTHON%" (
	set GRASS_PYTHON=
	for /f usebackq %%i in (`where python.exe`) do set GRASS_PYTHON=%%i
)
if "%GRASS_PYTHON%"=="" (
	echo.
	echo python.exe not found in PATH
	echo Please set GRASS_PYTHON in %~f0
	echo.
	pause
	goto:eof
)
rem XXX: Do we need PYTHONHOME?
rem for %%i in (%GRASS_PYTHON%) do set PYTHONHOME=%%~dpi

"%GRASS_PYTHON%" "%GISBASE%\etc\grass79.py" %*
if %ERRORLEVEL% geq 1 pause
