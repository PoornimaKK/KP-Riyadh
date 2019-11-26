ECHO OFF

shift
set solution_Dir=%~dp0

shift
set AssemblyVersionFile=%~0

set IconisVersionFile="%solution_Dir%BuildTools\Version\IconisConcatenedVersion.txt"

echo %AssemblyVersionFile%
echo %IconisVersionFile%

"%solution_Dir%BuildTools\Version\BuildTask.exe" "%AssemblyVersionFile%" %IconisVersionFile% "LVL_1"

echo AssemblyVersion update from IconisConcatenedVersion
