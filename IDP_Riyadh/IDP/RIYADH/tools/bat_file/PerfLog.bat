% if ATS_EQUIPMENT_TYPE == 'Data_Logger_Computer' :
	${bat_file("ICONISDLG","IconisTM4")}
% endif
% if ATS_EQUIPMENT_TYPE == 'Workstation' :
	${bat_file("IconisHMI")}
% endif
% if ATS_EQUIPMENT_TYPE == 'Central Server' :
	${bat_file("IconisServer","IconisTM4")}
% endif

<%def name="bat_file(name,folder='IconisHMI')">
logman stop ${name}
logman delete ${name}
@FOR /F "tokens=1 delims=." %%A IN ("%Time%") DO SET PerfTime=%%A
@FOR /F "tokens=2" %%A IN ("%date%") DO SET PerfDate=%%A
logman create counter ${name} -cf D:\DataPrep\Output\System\ByComputer\PerfLog_${MACHINE_NAME}.conf -v mmddhhmm -cnf 24:00:00 -si 15 -f csv -o D:\${folder}\PerfLogs\${folder} -b %PerfDate% %PerfTime%
logman start ${name}
</%def>