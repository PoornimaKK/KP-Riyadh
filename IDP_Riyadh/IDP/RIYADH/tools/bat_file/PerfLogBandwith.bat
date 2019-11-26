% if ATS_EQUIPMENT_TYPE == 'Data_Logger_Computer' or  ATS_EQUIPMENT_TYPE == 'Central Server':
	${bat_file("IconisTM4")}
% endif
% if ATS_EQUIPMENT_TYPE == 'Workstation' :
	${bat_file("IconisHMI")}
% endif

<%def name="bat_file(name)">
logman stop ${name}Bandwith
logman delete ${name}Bandwith
logman create counter ${name}Bandwith -cf D:\DataPrep\Output\System\ByComputer\PerfLogBandwith_${MACHINE_NAME}.conf -v mmddhhmm -cnf 24:00:00 -si 5 -f csv -o D:\${name}\PerfLogs\${name}_Bandwith
logman start ${name}Bandwith
</%def>