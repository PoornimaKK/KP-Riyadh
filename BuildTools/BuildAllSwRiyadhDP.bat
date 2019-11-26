@echo off



set BuildToolsDir=%cd%
cd %~dp0
cd ..
set SwRiyadhDir=%cd%
cd %BuildToolsDir%
set SolName=Sw_Riyadh_DP.sln
set ProjName=Sw_RiyadhDP

@echo CURRENT DIR = %BuildToolsDir%
@echo PROJECT   = %SwRiyadhDir%
@echo SOLUTION  = %SolName%

:question
@echo Do you want to build :
@echo      0 : Out
@echo      1 : Sw_RiyadhDP


set /P resp=Your choice : 

if %resp%==0 goto fin

@echo -----------    Set Visual 2010 environment   -----------
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86

if %resp%==1 goto choix1

goto question

:choix1
REM pause

REM *************************************
REM Clean Solution

@echo -----------    Clean solution   -----------

@echo -----------    Clean folders    -----------
del /F /Q /S "%SwRiyadhDir%\IconisBin8\PRODUCT"
del /F /Q /S "%SwRiyadhDir%\IconisBin8\ReleaseU"

@echo -----------    Clean by msbuild -----------
msbuild "%SwRiyadhDir%\%SolName%"  /t:Clean /p:Configuration="Unicode Release";Platform="Win32" /l:FileLogger,Microsoft.Build.Engine;logfile="%BuildToolsDir%\BuildAllRiyadhIDP.log"

REM *************************************
REM Start Build

@echo -----------    Create the global version file   -----------
cd "%SwRiyadhDir%\BuildTools\Version"
perl -w "%SwRiyadhDir%\BuildTools\Version\ConcatVersion.pl" "1" "ICONIS_LVL_1_VERSIONNB" "%SwRiyadhDir%\BuildTools\Version\IconisVersions_Riyadh_IDP.h"
cd %BuildToolsDir%

@echo -----------    Add the version number in vdproj   -----------
set IconisVersionHeader="%SwRiyadhDir%\BuildTools\Version\IconisConcatenedVersion.txt"

"%SwRiyadhDir%\BuildTools\Version\BuildTask.exe" "%SwRiyadhDir%\IDP_Riyadh\SetupIDP_Riyadh\SetupIDP_Riyadh.vdproj" %IconisVersionHeader% "LVL_1"

@echo -----------    Build solution   -----------
REM old method
REM kwinject -o "%BuildToolsDir%\%ProjName%_Cpp.out" msbuild  "%SwRiyadhDir%\%SolName%" /t:Build /p:Configuration="Unicode Release";Platform="Win32" /l:FileLogger,Microsoft.Build.Engine;logfile="%BuildToolsDir%\BuildAllRiyadhHMI.log";append=true /verbosity:n
REM kwcsprojparser -o "%BuildToolsDir%\%ProjName%_CS.out" msbuild  "%SwRiyadhDir%\%SolName%" /t:Build /p:Configuration="Unicode Release";Platform="Win32" /l:FileLogger,Microsoft.Build.Engine;logfile="%BuildToolsDir%\BuildAllRiyadhHMI.log";append=true /verbosity:n

REM kwinject -o "%BuildToolsDir%\%ProjName%_Cpp.out" devenv "%SwRiyadhDir%\%SolName%" /build "Unicode Release|Win32" /out "%BuildToolsDir%\BuildAllRiyadhHMI.log"
REM kwcsprojparser "%SwRiyadhDir%\%SolName%" --config "Unicode Release|Win32" --output "%BuildToolsDir%\%ProjName%_CS.out"

devenv "%SwRiyadhDir%\%SolName%" /build "Unicode Release|Win32" /out "%BuildToolsDir%\BuildAllRiyadhIDP.log"

REM @echo -----------    Build vdproj   -----------
REM old method
REM devenv "%SwRiyadhDir%\%SolName%" /build "Unicode Release" /project "IDP_Riyadh\SetupIDP_Riyadh\SetupIDP_Riyadh.vdproj" /out "%BuildToolsDir%\BuildAllRiyadhIDP.log"



goto :eof


:fin
goto :eof