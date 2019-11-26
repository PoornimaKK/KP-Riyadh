<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP" exclude-result-prefixes="sys xs">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<xsl:template match="/">
	<ICONIS_KERNEL_PARAMETER_DESCRIPTION_OTHER xsi:noNamespaceSchemaLocation="SyPD_Kernel.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<TrackPortions>
			<xsl:apply-templates select="$sysdb//Stopping_Area[Original_Area_List/Original_Area/@Original_Area_Type='Platform']"/>
		</TrackPortions>
	</ICONIS_KERNEL_PARAMETER_DESCRIPTION_OTHER>
</xsl:template>

<xsl:template match="Stopping_Area">
	<xsl:variable name="platform" select="//Platform[@ID=current()/Original_Area_List/Original_Area[@Original_Area_Type='Platform']/@ID]"/>
	<xsl:variable name="dir" select="if(contains($platform[1]/@Name,'UP_')) then 'Left' else 'Right'"/>
	<xsl:variable name="Platform_Approach_Distance" select="if(Platform_Approach_Distance) then Platform_Approach_Distance else 0"/>
	<xsl:variable name="KP" select="if($dir='Left') then number($platform[1]/Kp_Begin/@Value) - $Platform_Approach_Distance else number($platform[1]/Kp_End/@Value) + $Platform_Approach_Distance"/>
	<xsl:variable name="block" select="//Block[(Kp_Begin&lt;=$KP and Kp_End&gt;=$KP) and Track_ID=$platform/Track_ID][1]"/>
	<xsl:variable name="ssid1" select="//ATC_Equipment[@ID=//Signalisation_Area[Block_ID_List/Block_ID=$block/@ID]/sys:zc/@id]/SSID"/>
	<xsl:variable name="ssid" select="if($ssid1) then $ssid1[1] else '0'"/>
	<xsl:if test="$block">
		<TrackPortion ID="{$block/@ID}" Name="{concat('TI_',$block/@Name ,'_1.TrackPortion')}">
			<KpBegin><xsl:value-of select="$block/Kp_Begin"/></KpBegin>
			<tp><xsl:value-of select="concat('TI_',$block/@Name ,'.TrackPortion')"/></tp>
			<tpOrder>1</tpOrder>
			<KpEnd><xsl:value-of select="$Platform_Approach_Distance"/></KpEnd>
			<Sector><xsl:value-of select="$ssid"/></Sector>
			<FixedBlockOnly><xsl:value-of select="if($ssid = '0') then 'True' else 'False'"/></FixedBlockOnly>
		</TrackPortion>
		<TrackPortion ID="{10000+$block/@ID}" Name="{concat('TI_',$block/@Name ,'_2.TrackPortion')}">
			<tp><xsl:value-of select="concat('TI_',$block/@Name ,'.TrackPortion')"/></tp>
			<KpBegin><xsl:value-of select="$Platform_Approach_Distance"/></KpBegin>
			<KpEnd><xsl:value-of select="$block/Kp_End"/></KpEnd>
			<Sector><xsl:value-of select="$ssid"/></Sector>
			<tpOrder>2</tpOrder>
			<FixedBlockOnly><xsl:value-of select="if($ssid = '0') then 'True' else 'False'"/></FixedBlockOnly>
		</TrackPortion>
	</xsl:if>
</xsl:template>

<xsl:param name="sysdb" select="/docs/ATS_SYSTEM_PARAMETERS"/>
</xsl:stylesheet>