<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP" exclude-result-prefixes="sys">
  <xsl:output method="xml" indent="yes" encoding="UTF-8" use-character-maps="quotes" />
  <xsl:character-map name="quotes">
      <xsl:output-character character="&#34;" string="&amp;quot;"/>
   </xsl:character-map>

<xsl:template match="/">
<Deployment xsi:noNamespaceSchemaLocation="Deployment.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">	
	<DataPrepSource Version="1.0.0" Simultaneous="1">
		<DataPrepComputer Path="D:\DataPrep\ISD"/>
		<DataPrepComputer Path="D:\DataPrep\Output" Zip="1"/>
	</DataPrepSource>
	<Computers>
		% for workstation in ['Workstation','Workstation_OffLineTools','Overview_Display_System']:
			<xsl:apply-templates select="//ATS_Equipment[ATS_Equipment_Type='${workstation}']" mode="WorkStation"/>
		% endfor
		% for server in ['Server','Central Server','Local Server']:
			<xsl:apply-templates select="//ATS_Equipment[ATS_Equipment_Type='${server}']" mode="Server"/>
		% endfor
		<xsl:apply-templates select="//ATS_Equipment[ATS_Equipment_Type='Data_Logger_Computer' or ATS_Equipment_Type='Archiving']" mode="DataLogg"/>
	</Computers>
</Deployment>
</xsl:template>

<!-- Template to generate the deployment commands for ATS_Equipment type: Workstation, Workstation_OffLineTools and Overview_Display_System -->
<xsl:template match="ATS_Equipment" mode="WorkStation">
	<Computer Name="{@Name}" IP="{IP_Address_Light_Grey}" Description="{ATS_Equipment_Type}" ToReboot="">
		<!-- Installation Commands -->
		${Install('D:\DataPrep\ISD\ISSetupPrerequisites\{DCF61643-479F-42DE-80C5-C6E89714B1DF}\\vcredist_x86.exe /q /norestart','C++ redistribuable Installation')}
		${Install('D:\DataPrep\ISD\SetupS2KServer.exe  /s /v&quot;/qn&quot;','S2K Software installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupDataInterfacing.msi /quiet','Data Interfacing installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupU400.msi /quiet','U400 installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupUO.msi /quiet','UO installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupHMI_Riyadh.msi /quiet','Iconis HMI installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupHILC.msi /quiet','Iconis HILC installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupIServer.msi /quiet Runtime=&quot;1&quot;','Iconis IServer installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupHDW.msi /quiet Runtime=&quot;1&quot;','Iconis HDW installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupTABc.msi /quiet Runtime=&quot;1&quot;','Iconis TABc installation')}
		${Install('D:\DataPrep\Output\System\ByComputer\PerfLog_<xsl:value-of select="@Name"/>.bat','D:\DataPrep\Output\System\ByComputer','PerfLog Installation')}
		${Install('D:\DataPrep\Output\System\ByComputer\PerfLogBandwith_<xsl:value-of select="ATS_Equipment_Type"/>_<xsl:value-of select="@Name"/>.bat','D:\DataPrep\Output\System\ByComputer','PerfLog Bandwith Installation')}
		<!-- UnInstallation Commands -->
		${Uninstall('logman stop IconisHMIBandwith','PerfLog Bandwith uninstallation')}
		${Uninstall('logman delete IconisHMIBandwith','PerfLog Bandwith uninstallation')}
		${Uninstall('logman stop IconisHMI','PerfLog uninstallation')}
		${Uninstall('logman delete IconisHMI','PerfLog uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTABc.msi /quiet Runtime=&quot;1&quot;','Iconis TABc uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupHDW.msi /quiet Runtime=&quot;1&quot;','Iconis HDW uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupIServer.msi /quiet Runtime=&quot;1&quot;','Iconis IServer installation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupHILC.msi /quiet','Iconis HILC uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupHMI_Riyadh.msi /quiet','Iconis HMI uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupUO.msi /quiet','UO uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupU400.msi /quiet','U400 uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupDataInterfacing.msi /quiet','Data Interfacing uninstallation')}
		${Uninstall('D:\DataPrep\ISD\SetupS2KServer.exe  /s /v&quot;/qn&quot;','S2K Software uninstallation')}
	</Computer>
</xsl:template>

<!-- Template to generate the deployment commands for ATS_Equipment type: Server, Central Server and Local Server  -->
<xsl:template match="ATS_Equipment" mode="Server">
	<xsl:variable name="Server_ID" select="if (Signalisation_Area_ID) then (Signalisation_Area_ID) else (Signalisation_Area_ID_List/Signalisation_Area_ID)"/>
	<xsl:variable name="Server_Type" select="//Signalisation_Area[@ID=$Server_ID]/Server_Type"/>
	<Computer Name="{@Name}" IP="{IP_Address_Light_Grey}" Description="{ATS_Equipment_Type}" ToReboot="">	
		<DataPrep>
			<DataPrepSingle Path="D:\DataPrep\IDC\Appli\ATSRIM46_{$Server_ID}.bak" Zip="1"/>
			<DataPrepSingle Path="D:\DataPrep\IMC\IMCProject.bak" Zip="1"/>					
		</DataPrep>
		<!-- Installation Commands -->
		${Install('D:\DataPrep\ISD\ISSetupPrerequisites\{DCF61643-479F-42DE-80C5-C6E89714B1DF}\\vcredist_x86.exe /q /norestart','C++ redistribuable Installation')}
		${Install('D:\DataPrep\ISD\SetupS2KServer.exe  /s /v&quot;/qn&quot;','S2K Software installation')}
		${Install('cmd.exe /C mkdir \Dataprep\IMC\Database','Create IMC directory','D:\\')}
		${Install('sqlcmd -Q &quot;restore database IMCProject from disk=&apos;D:\DataPrep\IMC\IMCProject.bak&apos;&quot;','IMC Database import','D:\\')}
		${Install('cmd.exe /C mkdir \Dataprep\IconisTM4\Database','Create S2KConfig DB directory','D:\\')}
		${Install('sqlcmd -Q &quot;restore database S2KConfig from disk=&apos;D:\DataPrep\IDC\Appli\ATSRIM46_<xsl:value-of select="$Server_ID"/>.bak &apos;&quot;','S2KConfig Database import','D:\\')}
		${Install('D:\DataPrep\Output\System\ByComputer\PerfLog_<xsl:value-of select="@Name"/>.bat','PerfLog Installation','D:\DataPrep\Output\System\ByComputer')}
		${Install('D:\DataPrep\Output\System\ByComputer\PerfLogBandwith_<xsl:value-of select="@Name"/>.bat','PerfLog Bandwith Installation','D:\DataPrep\Output\System\ByComputer')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupDataInterfacing.msi /quiet','Data Interfacing installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupKernelBasic.msi /quiet','Kernel Basic installation')}
		<xsl:if test="$Server_Type='Level_2'">
			${Install('msiexec /i D:\DataPrep\ISD\SetupKernelExtended.msi /quiet','Kernel Extended installation')}
		</xsl:if>
		${Install('msiexec /i D:\DataPrep\ISD\SetupU400.msi /quiet','U400 installation')}
		<xsl:if test="$Server_Type='Level_2'">
			${Install('msiexec /i D:\DataPrep\ISD\SetupUO.msi /quiet','UO installation')}
		</xsl:if>
		${Install('msiexec /i D:\DataPrep\ISD\SetupRiyadh.msi /quiet','Riyadh installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupTopology.msi /quiet Runtime=&quot;1&quot;','Iconis Topology installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupSigRule.msi /quiet Runtime=&quot;1&quot;','Iconis SigRule installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupMMG.msi /quiet Runtime=&quot;1&quot;','Iconis MMG installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupIconisToolBox.msi /quiet Runtime=&quot;1&quot;','Iconis ToolBox installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupAlarmsEvents.msi /quiet Runtime=&quot;1&quot;','Iconis AlarmEvents installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupTFA.msi /quiet Runtime=&quot;1&quot;','Iconis TFA installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupMBT.msi /quiet Runtime=&quot;1&quot;','Iconis MBT installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupDZM.msi /quiet Runtime=&quot;1&quot;','Iconis DZM installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupMTM.msi /quiet Runtime=&quot;1&quot;','Iconis MTM installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupFBT.msi /quiet Runtime=&quot;1&quot;','Iconis FBT installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupTUM.msi /quiet Runtime=&quot;1&quot;','Iconis TUM installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupICM.msi /quiet Runtime=&quot;1&quot;','Iconis ICM installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupTDSToolBox.msi /quiet Runtime=&quot;1&quot;','Iconis TDSToolBox installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupRSM.msi /quiet Runtime=&quot;1&quot;','Iconis RSM installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupIPD.msi /quiet Runtime=&quot;1&quot;','Iconis IPD installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupStarter.msi /quiet','Iconis Starter installation')}
		<xsl:if test="$Server_Type='Level_2'">
			${Install('msiexec /i D:\DataPrep\ISD\SetupATR.msi /quiet Runtime=&quot;1&quot;','Iconis ATR installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupARS.msi /quiet Runtime=&quot;1&quot;','Iconis ARS installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupSOQ.msi /quiet Runtime=&quot;1&quot;','Iconis SOQ installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupTABServerOTM.msi /quiet Runtime=&quot;1&quot;','Iconis TABs/TABServerOTM installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupTABServer.msi /quiet Runtime=&quot;1&quot;','Iconis TABs/TABServer installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupIServer.msi /quiet Runtime=&quot;1&quot;','Iconis IServer installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupTPM.msi /quiet Runtime=&quot;1&quot;','Iconis TPM installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupTTC.msi /quiet Runtime=&quot;1&quot;','Iconis TTC installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupDBLoader.msi /quiet Runtime=&quot;1&quot;','Iconis DBLoader installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupJSH.msi /quiet Runtime=&quot;1&quot;','Iconis JSH installation')}
		</xsl:if>
		<xsl:if test="$Server_Type='Level_1'">
			${Install('msiexec /i D:\DataPrep\ISD\SetupCCM.msi /quiet Runtime=&quot;1&quot;','Iconis CCM installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupRSMU400.msi /quiet Runtime=&quot;1&quot;','Iconis RSMU400 installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupZCI.msi /quiet Runtime=&quot;1&quot;','Iconis ZCI installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupBaseline2-12.msi /quiet Runtime=&quot;1&quot;','Baseline 2.12 installation')}
		</xsl:if>
		<xsl:if test="$Server_Type='Level_2'">
			${Install('msiexec /i D:\DataPrep\ISD\SetupTMM.msi /quiet Runtime=&quot;1&quot;','Iconis TMM installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupPTD.msi /quiet Runtime=&quot;1&quot;','Iconis PTD installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupHSM.msi /quiet Runtime=&quot;1&quot;','Iconis HSM installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupIDR.msi /quiet Runtime=&quot;1&quot;','Iconis IDR installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupTPB.msi /quiet Runtime=&quot;1&quot;','Iconis TPB installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupTTR.msi /quiet Runtime=&quot;1&quot;','Iconis TTR installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupOPCM.msi /quiet Runtime=&quot;1&quot;','OPCM installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupHSME.msi /quiet Runtime=&quot;1&quot;','HMSE installation')}
			${Install('msiexec /i D:\DataPrep\ISD\SetupSTA.msi /quiet Runtime=&quot;1&quot;','STA installation')}
		</xsl:if>
		${Install('msiexec /i D:\DataPrep\ISD\SetupWSH.msi /quiet Runtime=&quot;1&quot;','WSH installation')}
		<!-- UnInstallation Commands -->
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupWSH.msi /quiet Runtime=&quot;1&quot;','WSH uninstallation')}
		<xsl:if test="$Server_Type='Level_2'">
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupSTA.msi /quiet Runtime=&quot;1&quot;','STA uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupHSME.msi /quiet Runtime=&quot;1&quot;','HSME uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupOPCM.msi /quiet Runtime=&quot;1&quot;','OPCM uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTTR.msi /quiet Runtime=&quot;1&quot;','Iconis TTR uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTPB.msi /quiet Runtime=&quot;1&quot;','Iconis TPB uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupIDR.msi /quiet Runtime=&quot;1&quot;','Iconis IDR uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupHSM.msi /quiet Runtime=&quot;1&quot;','Iconis HSM uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupPTD.msi /quiet Runtime=&quot;1&quot;','Iconis PTD uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTMM.msi /quiet Runtime=&quot;1&quot;','Iconis TMM uninstallation')}
		</xsl:if>
		<xsl:if test="$Server_Type='Level_1'">
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupBaseline2-12.msi /quiet Runtime=&quot;1&quot;','Baseline 2.12 uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupZCI.msi /quiet Runtime=&quot;1&quot;','Iconis ZCI uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupRSMU400.msi /quiet Runtime=&quot;1&quot;','Iconis RSMU400 uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupCCM.msi /quiet Runtime=&quot;1&quot;','Iconis CCM uninstallation')}
		</xsl:if>
		<xsl:if test="$Server_Type='Level_2'">
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupJSH.msi /quiet Runtime=&quot;1&quot;','Iconis JSH uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupSOQ.msi /quiet Runtime=&quot;1&quot;','Iconis SOQ uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTABServerOTM.msi /quiet Runtime=&quot;1&quot;','Iconis TABs uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTABServer.msi /quiet Runtime=&quot;1&quot;','Iconis TABs uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTTC.msi /quiet Runtime=&quot;1&quot;','Iconis TTC uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupDBLoader.msi /quiet Runtime=&quot;1&quot;','Iconis DBLoader uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupARS.msi /quiet Runtime=&quot;1&quot;','Iconis ARS uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupATR.msi /quiet Runtime=&quot;1&quot;','Iconis ATR uninstallation')}
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTPM.msi /quiet Runtime=&quot;1&quot;','Iconis TPM uninstallation')}
		</xsl:if>
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupStarter.msi /quiet','Iconis Starter uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupRSM.msi /quiet Runtime=&quot;1&quot;','Iconis RSM uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupIPD.msi /quiet Runtime=&quot;1&quot;','Iconis IPD uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupICM.msi /quiet Runtime=&quot;1&quot;','Iconis ICM uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTDSToolBox.msi /quiet Runtime=&quot;1&quot;','Iconis TDSToolBox uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTUM.msi /quiet Runtime=&quot;1&quot;','Iconis TUM uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupFBT.msi /quiet Runtime=&quot;1&quot;','Iconis FBT uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupMTM.msi /quiet Runtime=&quot;1&quot;','Iconis MTM uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupDZM.msi /quiet Runtime=&quot;1&quot;','Iconis DZM uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupMBT.msi /quiet Runtime=&quot;1&quot;','Iconis MBT uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTFA.msi /quiet Runtime=&quot;1&quot;','Iconis TFA uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupAlarmsEvents.msi /quiet Runtime=&quot;1&quot;','Iconis AlarmsEvents uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupIconisToolBox.msi /quiet Runtime=&quot;1&quot;','IconisToolBox uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupMMG.msi /quiet Runtime=&quot;1&quot;','Iconis MMG uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupSigRule.msi /quiet Runtime=&quot;1&quot;','Iconis SigRule uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupTopology.msi /quiet Runtime=&quot;1&quot;','Iconis Topology uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupRiyadh.msi /quiet','Riyadh uninstallation')}
		<xsl:if test="$Server_Type='Level_2'">
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupUO.msi /quiet','UO uninstallation')}
		</xsl:if>
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupU400.msi /quiet','U400 uninstallation')}
		<xsl:if test="$Server_Type='Level_2'">
			${Uninstall('msiexec /x D:\DataPrep\ISD\SetupKernelExtended.msi /quiet','Kernel Extended uninstallation')}
		</xsl:if>
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupKernelBasic.msi /quiet','Kernel Basic uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupDataInterfacing.msi /quiet','Data Interfacing uninstallation')}
		${Uninstall('Logman stop IconisTM4Bandwith','PerfLog Bandwith uninstallation')}
		${Uninstall('Logman delete IconisTM4Bandwith','PerfLog Bandwith uninstallation')}
		${Uninstall('Logman stop IconisServer','PerfLog uninstallation')}
		${Uninstall('Logman stop IconisServer','PerfLog uninstallation')}
		${Uninstall('sqlcmd -Q &quot;drop database IMCProject&quot;','IMC Database drop')}
		${Uninstall('sqlcmd -Q &quot;drop database S2KConfig&quot;','S2KConfig Database drop')}
		${Uninstall('D:\DataPrep\ISD\SetupS2KServer.exe  /s /v&quot;/qn&quot;','S2K Software uninstallation')}
	</Computer>
</xsl:template>

<!-- Template to generate the deployment commands for ATS_Equipment type: Data Logger Computer  -->
<xsl:template match="ATS_Equipment" mode="DataLogg">
	<Computer Name="{@Name}" IP="{IP_Address_Light_Grey}" Description="{ATS_Equipment_Type}" ToReboot="">
		<DataPrep>
			<DataPrepSingle Path="D:\DataPrep\IDC\Appli\ATS_{@Name}.bak" Zip="1"/>
		</DataPrep>
		<!-- Installation Commands -->
		${Install('D:\DataPrep\ISD\ISSetupPrerequisites\{DCF61643-479F-42DE-80C5-C6E89714B1DF}\\vcredist_x86.exe /q /norestart','C++ redistribuable Installation')}
		${Install('D:\DataPrep\ISD\SetupS2KServer.exe  /s /v&quot;/qn&quot;','S2K Software installation')}
		${Install('cmd.exe /C mkdir \Dataprep\IconisTM4\Database','Create S2KConfig DB directory','D:\\')}
		${Install('sqlcmd -Q &quot;restore database S2KConfig from disk=&apos;D:\DataPrep\IDC\Appli\ATS_<xsl:value-of select="@Name"/>.bak &apos;&quot;','S2KConfig Database import','D:\\')}
		${Install('D:\DataPrep\Output\System\ByComputer\PerfLog_<xsl:value-of select="@Name"/>.bat','PerfLog Installation','D:\DataPrep\Output\System\ByComputer')}
		${Install('D:\DataPrep\Output\System\ByComputer\PerfLogBandwith_<xsl:value-of select="@Name"/>.bat','PerfLog Bandwith Installation','D:\DataPrep\Output\System\ByComputer')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupDataInterfacing.msi /quiet','Data Interfacing installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupKernelExtended.msi /quiet','Kernel Extended installation')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupSOQ.msi /quiet Runtime=&quot;1&quot;','Iconis SOQ installation')}
		${Install('cmd.exe /C mkdir \Temp\Archiving','Create Archiving directory','D:\\')}
		${Install('cmd.exe /C mkdir \IconisARC\Archiving','Create Archiving directory','D:\\')}
		${Install('cmd.exe /C mkdir \IconisARC\Log','Create Log directory','D:\\')}
		${Install('msiexec /i D:\DataPrep\ISD\SetupStarter.msi /quiet','Iconis Starter installation')}
		<!-- UnInstallation Commands -->
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupStarter.msi /quiet','Iconis Starter uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupSOQ.msi /quiet Runtime=&quot;1&quot;','Iconis SOQ uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupKernelExtended.msi /quiet','Kernel Extended uninstallation')}
		${Uninstall('msiexec /x D:\DataPrep\ISD\SetupDataInterfacing.msi /quiet','Data Interfacing uninstallation')}
		${Uninstall('Logman stop IconisTM4Bandwith','PerfLog Bandwith uninstallation')}
		${Uninstall('Logman delete IconisTM4Bandwith','PerfLog Bandwith uninstallation')}
		${Uninstall('Logman stop IconisDLG','PerfLog uninstallation')}
		${Uninstall('Logman delete IconisDLG','PerfLog uninstallation')}
		${Uninstall('sqlcmd -Q &quot;drop database S2KConfig&quot;','S2KConfig Database drop')}
		${Uninstall('D:\DataPrep\ISD\SetupS2KServer.exe  /s /v&quot;/qn&quot;','S2K Software uninstallation')}	
	</Computer>			
</xsl:template>
</xsl:stylesheet>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->

<%def name="Install(commandline, Description, WorkingDirectory='False')">
	<InstallCommand>
		<xsl:attribute name="CommandLine">${commandline}</xsl:attribute>
		<xsl:attribute name="Description">${Description}</xsl:attribute>
		% if WorkingDirectory != 'False':
			<xsl:attribute name="WorkingDirectory">${WorkingDirectory}</xsl:attribute>
		% endif
	</InstallCommand>
</%def>

<%def name="Uninstall(commandline, Description, WorkingDirectory='False')">
	<UnInstallCommand>
		<xsl:attribute name="CommandLine">${commandline}</xsl:attribute>
		<xsl:attribute name="Description">${Description}</xsl:attribute>
		% if WorkingDirectory != 'False':
			<xsl:attribute name="WorkingDirectory">${WorkingDirectory}</xsl:attribute>
		% endif
	</UnInstallCommand>
</%def>
