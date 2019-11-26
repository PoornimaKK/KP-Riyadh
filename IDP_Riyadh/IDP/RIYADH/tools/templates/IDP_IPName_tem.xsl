<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP" exclude-result-prefixes="sys">
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<!--  Generation Date -->
<xsl:param name="DATE"/>

<!-- Global variables declared -->
<xsl:variable name="locale1" select="//Loc[@Def='-1']/@LCID"/>
<xsl:variable name="locale2" select="//Loc[@Def='0']/@LCID"/>

<xsl:template match="/">
<ATS_SYSTEM_PARAMETERS xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="IPName.xsd"> 
	${versions_xml()}
	<Lines>
		<xsl:apply-templates select="$sysdb//Line"/>
	</Lines>
	<DataProject>
		<Model_Installation/>
		<Product_Type>ICONIS</Product_Type>
		<Name_Project><xsl:value-of select="$sysdb//Project[@ID='1']/@Name"/></Name_Project>
		<Version><xsl:value-of select="$sysdb//Project[@ID='1']/Database_Version"/></Version>
		<Date_Creation><xsl:value-of select="$DATE"/></Date_Creation>
		<TimeZone>Romance Standard Time</TimeZone>
		<MUI><xsl:value-of select="$locale2"/></MUI>
		<Install_VirusScan>YES</Install_VirusScan>
		<REPOSITORY_VirusScan><xsl:value-of select="$sysdb//ATS_Equipment[ATS_Equipment_Type='Off_Line_Tools']/@Name"/></REPOSITORY_VirusScan>
		<Workgroup>ICONIS</Workgroup>
		<Users>
			<User ID="1" Name="iconis" Password="iconis" Group="Administrators"></User>
		</Users>
		<NTP>
			<Install>YES</Install>
			<External_Master_Clock_Prefer><xsl:value-of select="$sysdb//External_Master_Clock[External_Master_Clock_Type='Main']/IP_Address"/></External_Master_Clock_Prefer>
			<xsl:variable name="ip_add_1" select="if (//ATS_Equipment[ATS_Equipment_Type='Gateway']) then (//ATS_Equipment[ATS_Equipment_Type='Gateway']/IP_Address_Light_Grey) else (//ATS_Equipment[ATS_Equipment_Type='FEP']/IP_Address_Light_Grey)"/>
			<External_Master_Clock><xsl:value-of select="$ip_add_1[1]"/></External_Master_Clock>
			<TIS_Master_Clock_Prefer><xsl:value-of select="$ip_add_1[1]"/></TIS_Master_Clock_Prefer>
			<xsl:variable name="ip_add_2" select="if ($ip_add_1[2]) then ($ip_add_1) else (//ATS_Equipment[ATS_Equipment_Type='FEP']/IP_Address_Light_Grey)"/>
			<TIS_Master_Clock><xsl:value-of select="$ip_add_2[2]"/></TIS_Master_Clock>
			<xsl:variable name="fepip" select="//ATS_Equipment[ATS_Equipment_Type='FEP']/IP_Address_Light_Grey"/>
			<SNMP_Manager IP_Address="{$fepip[1]}">YES</SNMP_Manager>
		</NTP>
	</DataProject>
</ATS_SYSTEM_PARAMETERS>
</xsl:template>

<xsl:template match="Line">
	<xsl:variable name="lineid" select="@ID"/>
	<Line ID="{@ID}" Name="{@Name}">
		<xsl:variable name="sigarea" select="ATS_Central_Server_Area_ID_List/Signalisation_Area_ID"/>
		<xsl:variable name="atsid" select="$sysdb//Signalisation_Area[@ID=$sigarea]/sys:ats/@id"/>
		<xsl:variable name="t_room" select="//ATS_Equipment[Signalisation_Area_ID_List/Signalisation_Area_ID=$sigarea]/Technical_Room_ID"/>
		<Technical_Rooms>
			<xsl:apply-templates select="$sysdb//Technical_Room[@ID=distinct-values($t_room)]">
				<xsl:with-param name="atsid" select="$atsid"/>
				<xsl:with-param name="t_room" select="$t_room"/>
				<xsl:with-param name="lineid" select="$lineid"/>
			</xsl:apply-templates>
		</Technical_Rooms>
	</Line>
</xsl:template>

<xsl:template match="Technical_Room">
	<xsl:param name="atsid"/>
	<xsl:param name="t_room"/>
	<xsl:param name="lineid"/>
	<Technical_Room ID="{@ID}" Name="{@Name}">
		<ATSs>
			<xsl:apply-templates select="$sysdb//ATS[@ID=distinct-values($atsid)]">
				<xsl:with-param name="t_room" select="$t_room"/>
				<xsl:with-param name="atsid" select="$atsid"/>
				<xsl:with-param name="lineid" select="$lineid"/>
			</xsl:apply-templates>
		</ATSs>
	</Technical_Room>
</xsl:template>

<xsl:template match="ATS">
	<xsl:param name="atsid"/>
	<xsl:param name="t_room"/>
	<xsl:param name="lineid"/>
	<ATS ID="{@ID}" Name="{@Name}">
		<ATS_Equipments>
			<xsl:apply-templates select="$sysdb//ATS_Equipment[Technical_Room_ID=distinct-values($t_room)]">
				<xsl:with-param name="atsid" select="$atsid"/>
				<xsl:with-param name="lineid" select="$lineid"/>
			</xsl:apply-templates>
		</ATS_Equipments>
	</ATS>
</xsl:template>

<xsl:template match="ATS_Equipment">
	<xsl:param name="atsid"/>
	<xsl:param name="lineid"/>
	<xsl:if test="not(ATS_Equipment_Type = 'Printer')">
		<ATS_Equipment ID="{@ID}" Name="{@Name}">
			<xsl:variable name="sid" select="Signalisation_Area_ID"/>
			<xsl:variable name="atseqptype" select="if (ATS_Equipment_Type = 'Data_Logger_Computer') then ('Archiving') else if (ATS_Equipment_Type = 'FEP' and $sysdb//Signalisation_Area[@ID=$sid]/Server_Type='Level_1') then ('Server_LV1') else (ATS_Equipment_Type)"/>
			<ATS_Equipment_Type><xsl:value-of select="$atseqptype"/></ATS_Equipment_Type>
	        <IP_Address_Light_Grey><xsl:value-of select="IP_Address_Light_Grey"/></IP_Address_Light_Grey>
	        <IP_Address_Dark_Grey><xsl:value-of select="IP_Address_Dark_Grey"/></IP_Address_Dark_Grey>
	        <Subnet_Mask_Light_Grey><xsl:value-of select="Subnet_Mask_Light_Grey"/></Subnet_Mask_Light_Grey>
	        <Subnet_Mask_Dark_Grey><xsl:value-of select="Subnet_Mask_Dark_Grey"/></Subnet_Mask_Dark_Grey>
	        <xsl:if test="ATS_Equipment_Type = 'FEP'">
				<IP_Address_Blue><xsl:value-of select="$sysdb//ATS[@ID=$atsid]/IP_Address_Blue"/></IP_Address_Blue>
				<IP_Address_Red><xsl:value-of select="$sysdb//ATS[@ID=$atsid]/IP_Address_Red"/></IP_Address_Red>
				<Subnet_Mask_Blue>255.255.255.0</Subnet_Mask_Blue>
				<Subnet_Mask_Red>255.255.255.0</Subnet_Mask_Red>
				<Routes>
					<Route Gateway_IP="192.168.4.1" Interface_IP="10.1.0.0" Interface_Mask="255.255.0.0"/>
					<Route Gateway_IP="192.168.2.2" Interface_IP="10.2.0.0" Interface_Mask="255.255.0.0"/>
					<Route Gateway_IP="192.168.4.1" Interface_IP="10.69.0.0" Interface_Mask="255.255.0.0"/>
					<Route Gateway_IP="192.168.2.2" Interface_IP="10.65.0.0" Interface_Mask="255.255.0.0"/>
					<xsl:apply-templates select="//ATS_FEP[@ID=$atsid]/WITH_MASK"/>
				</Routes>
			</xsl:if>
			<Printers>
				<xsl:if test="ALSTOM_Code != 'NA' or ALSTOM_Code != ''">
					<Printer>
						<xsl:variable name="model" select="if (ALSTOM_Code = 'DTR0000214062') then ('HP-P2025n') else if (ALSTOM_Code = 'DTR0000223699') then ('HP-P3015') else if (ALSTOM_Code = 'DTR0000120181') then ('HP-P4700') else if (ALSTOM_Code = 'DTR0000223609') then ('HP-P4525n') else null "/>
						<Printer Name="{@Name}" Model="{$model}" IP_Address="{IP_Address_Light_Grey}" Interface_Mask="{Subnet_Mask_Light_Grey}" Gateway="{Default_Gateway_Light_Grey}"/>
					</Printer>
				</xsl:if>	
			</Printers>
			<xsl:if test="ATS_Equipment_Type='Workstation' or ATS_Equipment_Type='Workstation_OffLineTools'">
				<xsl:variable name="wksdn" select="if (Workstation_DisplayNumber) then (Workstation_DisplayNumber) else '1'"/>
				<Display Width="1680" Height="1050" Screens_Number="{$wksdn}"/>
				<Settings Regional="{$locale2}"/>	
			</xsl:if>
			<xsl:if test="ATS_Equipment_Type!='Workstation' and ATS_Equipment_Type!='Workstation_OffLineTools' and ATS_Equipment_Type!='Off_Line_Tools'">
				<Settings Regional="{$locale1}"/>	
			</xsl:if>	
			<xsl:if test="ATS_Equipment_Type='Off_Line_Tools'">
				<Settings Regional="{$locale2}"/>
			</xsl:if>	
		</ATS_Equipment>
	</xsl:if>
</xsl:template>

<xsl:template match="WITH_MASK">
	<Route Gateway_IP="192.168.4.1" Interface_IP="{@IP}" Interface_Mask="{@MASK}"/>
	<Route Gateway_IP="192.168.2.2" Interface_IP="{@IP}" Interface_Mask="{@MASK}"/>
</xsl:template>

<xsl:param name="sysdb" select="/docs/ATS_SYSTEM_PARAMETERS"/>
</xsl:stylesheet>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="versions_xml"/>