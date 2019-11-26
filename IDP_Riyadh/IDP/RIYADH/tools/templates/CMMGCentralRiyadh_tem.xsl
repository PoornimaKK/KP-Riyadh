<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP" exclude-result-prefixes="sys">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<xsl:param name="SERVER_ID"/>
<xsl:param name="DATE"/>

<xsl:variable name="junc"><xsl:value-of select="//Junction_Area[sys:sigarea/@id=$SERVER_ID and (NOOT_Strategy_Presence='true' or FCFS_Strategy_Presence='true')]/@Name" separator=";2,"/></xsl:variable>

<xsl:template match="/">
<OperatingMode xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Central" version="1" date="{$DATE}" comment="Mode Management" xsi:noNamespaceSchemaLocation="MMG_LineOPeratingMode.xsd">
	<States Initial="Manual" KeyInDico="YES">
		<State index="0" withdrawal="0" key="CManual">Manual</State>
		<State index="1" withdrawal="0" key="CAutomatic_without_timetable">Automatic without timetable</State>
		<State index="2" withdrawal="0" key="CAutomatic_with_timetable">Automatic with timetable</State>
	</States>
	<Modes>
		<Mode module="Junctions" comment="CmdDemux.JunctionArea">
			<Value value="{$junc}">NOOT</Value>
			<Value value="{$junc}">FCFS</Value>
		</Mode>
	</Modes>
	<iReferences/>
	<bstrReferences>
		<Module Reference="1">Junctions</Module>
	</bstrReferences>
	<Transitions>
		<Transition Initial="Manual;Automatic with timetable;Automatic without timetable" Final="Manual">
			<Junctions TimeOut="1">FCFS</Junctions>
		</Transition>
		<Transition Initial="Manual;Automatic with timetable;Automatic without timetable" Final="Automatic with timetable">
			<Junctions TimeOut="1">NOOT</Junctions>
		</Transition>
		<Transition Initial="Manual;Automatic with timetable;Automatic without timetable" Final="Automatic without timetable">
			<Junctions TimeOut="1">FCFS</Junctions>
		</Transition>
	</Transitions>
</OperatingMode>
</xsl:template>
</xsl:stylesheet>