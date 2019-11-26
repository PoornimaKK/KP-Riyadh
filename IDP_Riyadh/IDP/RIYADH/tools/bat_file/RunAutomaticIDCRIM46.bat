@ECHO OFF
CLS
REM Here tape the name of your S2K project ("ICONIS" for instance)
REM --------------------------------------------------------------
set WorkingDirectory=%CD%
set S2KProjectName=${PROJECT}
REM Here tape the name of your S2K application ("ProjectExample_4_0" for instance)
REM ------------------------------------------------------------------------------
${level('S2KApplicationName','ATS_')}
REM Here tape the directory IDC where are ll2cs.exe and DataPrepUI.exe ("C:\Program Files\ALSTOM\ICONISTM4.0\ID" for instance).
REM ---------------------------------------------------------------------------------------------------------------------------
set IDC_DIR=D:\DataPrep\IDC
REM Here tape the full name of the file which describes the locales and roles of the project
REM If no locales and roles file is needed, just tape the keyword NO_LOCALES_AND_ROLES_FILE
REM ----------------------------------------------------------------------------------------------------
set LocalesRolesFile=NO_LOCALES_AND_ROLES_FILE
REM Here tape the full name of the file which describes the groups of the project
REM If no groups file is needed, just tape the keyword NO_GROUPS_FILE
REM -----------------------------------------------------------------------------------------
set GroupsFile=NO_GROUP_FILE
REM Here type the full name (with path) where are the ICONIS templates Built In as well as Templates_ICONIS.xml
REM The file name is not mandatory: Templates_ICONIS.xml will be used if no file name is specified.
REM If no Built In templates must be loaded, just type the keyword NO_TEMPLATES
REM -----------------------------------------------------------------------------------------------------------
set ICONIS_BUILTIN_DIR=D:\DataPrep\IDC\Templates\Templates_RIM46${SERVER_LEVEL}.xml
REM Here tape the directory where are the ICONIS templates Built In and Application object as well as Templates_ICONIS.xml and Templates_AppObj.xml ("C:\Program Files\ALSTOM\ICONISTM4.0\ID" for instance).
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
set ICONIS_TEMPLATE_DIR=D:\DataPrep\IDC\Templates\Templates_AppObj_RIM46${SERVER_LEVEL}.xml
REM Here tape the full name of the file used by DataPrepUI to compile dataprep ("IDCProjectExample.xml" for instance)
REM -----------------------------------------------------------------------------------------------------------------------------
set IDCCompileFile=%WorkingDirectory%\IDCRIM46_ATS_${SERVER_ID}${SERVER_LEVEL}.xml
REM Here tape the directory where is the AppObjectU400.xml file product by DataPrepUI after compilation
REM -----------------------------------------------------------------------------------------------
set IDC_output_name=D:\DataPrep\IDC\IconisAppl\AppObjectsRIM46_${SERVER_ID}${SERVER_LEVEL}.xml
REM Here tape the full name of IconisParam file
REM -------------------------------------------------------
set ICONISParamFile=%WorkingDirectory%\ParametersRIM46_${SERVER_ID}${SERVER_LEVEL}.xml
REM Here type the full name (with path) of AlarmParameters file
REM If no AlarmParameters file is available, just type the keyword NO_ALARMPARAM_FILE
REM --------------------------------------------------------------------------------------
set AlarmParamFile=NO_ALARMPARAM_FILE
REM Here tape the full name (with path) where is backup file to restore S2KConfig database
REM If no backup file is available, just tape the keyword NO_BACKUP_FILE
REM --------------------------------------------------------------------------------------
set S2KConfigBackup=UPDATEDB
REM Here tape the full name (with path) of the final backup file (to be saved)
REM --------------------------------------------------------------------------
set S2KConfigFinalBackup=D:\DataPrep\IDC\Appli\ATSRIM46_${SERVER_ID}.bak
REM Change, if needed, the directory where are scripts to launch
REM ------------------------------------------------------------
set scriptsDir=D:\DataPrep\IDC\AutomaticIDC\IDCScripts
REM Select if the log file is opened at the end of AutomaticIDC (type OPEN_REPORT or NOT_OPEN_REPORT)
REM --------------------------------------------------------------------------------------
set openReport=OPEN_REPORT
 
REM ================ POSITIVELY, DO NOT CHANGE THE SCRIPT BEYOND THIS LINE =====================
call "%scriptsDir%\AutomaticIDC.bat" %S2KProjectName% %S2KApplicationName% "%LocalesRolesFile%" "%GroupsFile%" "%S2KConfigBackup%" "%S2KConfigFinalBackup%" "%IDC_DIR%" "%ICONIS_BUILTIN_DIR%" "%ICONIS_TEMPLATE_DIR%" "%IDCCompileFile%" "%IDC_output_name%" "%ICONISParamFile%" "%scriptsDir%" "%AlarmParamFile%" "%openReport%"
 @ECHO ON

<%def name="level(property, value)" >
	% if SERVER_LEVEL == '_LV2' and COUNT == 2  : 
set ${property}=${value}${SERVER_ID}${SERVER_LEVEL}
	%else:
set ${property}=${value}${SERVER_ID}
	% endif
</%def>