<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP" exclude-result-prefixes="sys">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<!-- Get the date from command line -->
<xsl:param name="SERVER_ID"/>
<xsl:param name="SERVER_LEVEL"/>
<xsl:param name="IS_BOTH_LEVEL"/>
<xsl:param name="DATE"/>

<xsl:template match="/">
<IDC Project="{//Project/@Name}" Generation_Date="{$DATE}" xsi:noNamespaceSchemaLocation="IDC.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    ${versions_xml()}
	<Enumerates>
		<File name="Enummgnt.xml"/>
	</Enumerates>
	<xsl:variable name="CBIs" select="//Signalisation_Area[@ID=$SERVER_ID]/sys:cbi"/>
	<xsl:variable name="ZCs" select="//Signalisation_Area[@ID=$SERVER_ID]/sys:zc"/>
	<Parameters>
		<!--xsl:if test="$IS_BOTH_LEVEL='YES'">
			<File name="Riyadh\HMIStringInformation_{$SERVER_ID}{$SERVER_LEVEL}.xml"/>
		</xsl:if-->
		<xsl:if test="$SERVER_LEVEL = '_LV1'">
			${gen_file([('Riyadh\TPBerthTUView_{$SERVER_ID}.xml'),
				('Riyadh\TPBerthTUGeneralView_{$SERVER_ID}.xml'),
				('Riyadh\HMITrainAttributes.xml'),
				('Riyadh\PSDStatus_{$SERVER_ID}.xml'),
				('Riyadh\HMITrainRSMCommand.xml'),
				('Riyadh\HMITrainAlarmMonitored.xml'),
				('Riyadh\HMITrainAlarmTriggered.xml'),
				('Riyadh\DynamicEBRSMCommand.xml'),
				('Riyadh\HMIStringInformation_{$SERVER_ID}{$SERVER_LEVEL}.xml'),
				('Group\Group_HMITrainAlarmMonitored.xml'),
				('Group\Group_HMITrainAlarmTriggered.xml')
				])}
				${iter_equip('Riyadh\WashingMachine','$CBIs')}
				${iter_equip('CBI\Interlocking','$CBIs')}
				${iter_equip('Riyadh\EvacuationZoneSecCause','$ZCs')}
				<File name="Riyadh\GenericAreaRiyadh_{$SERVER_ID}.xml"/>
				<File name="Riyadh\RiyadhLV1_{$SERVER_ID}.xml"/>
				
		</xsl:if>
		<xsl:if test="$SERVER_LEVEL = '_LV2'">
			${gen_file([('Riyadh\OPCClient_Riyadh_SRV_{$SERVER_ID}_LV2.xml'),
				('Riyadh\OPCClient_Riyadh_SCADA_{$SERVER_ID}_LV2.xml'),
				('Riyadh\ISMPlatformInfo_{$SERVER_ID}.xml'),
				('Riyadh\ISMTrainInfo_{$SERVER_ID}.xml'),
				('Riyadh\SCADAPlatformInfo_{$SERVER_ID}.xml'),
				('Riyadh\WashPoint_{$SERVER_ID}.xml'),
				('Riyadh\AntiBunching_{$SERVER_ID}.xml'),
				('Riyadh\EvacuationZone_{$SERVER_ID}.xml'),
				('Riyadh\RSCommandLV2.xml'),
				('Riyadh\StationRestriction_{$SERVER_ID}.xml'),
				('Riyadh\RiyadhPlatform_{$SERVER_ID}.xml'),
				('Group\Group_RiyadhPlatform_{$SERVER_ID}.xml'),
				('Riyadh\RiyadhLV2_{$SERVER_ID}.xml'),
				('Riyadh\InServicePropertyBagTrain.xml'),
				('Riyadh\TransferTrack_{$SERVER_ID}.xml'),
				('Riyadh\HMITrainAlarmTriggered.xml'),
				('Riyadh\AlarmRiyadhLV2_{$SERVER_ID}.xml'),
				('Group\Group_AlarmRiyadhLV2_{$SERVER_ID}.xml'),
				('Group\Group_HMITrainAlarmTriggered.xml'),
				('Riyadh\Junction_{$SERVER_ID}.xml'),
				('Riyadh\OPCMModule_{$SERVER_ID}.xml'),
				('Riyadh\SCADATrainInfo_{$SERVER_ID}.xml'),
				('Riyadh\DepotStablingDoors_{$SERVER_ID}.xml'),
				('Riyadh\DepotModule_{$SERVER_ID}.xml')
				])}
		</xsl:if>
	</Parameters>
	<SigRules>
		<xsl:if test="$SERVER_LEVEL = '_LV1'">
			<File name="SigRule\SigRules_PSDStatus_{$SERVER_ID}.xml" check="N"/>
			${iter_equip('SigRule\SigRules_WashingMachine','$CBIs', 'False')}
			${iter_equip('SigRule\SigRules_EvacuationZoneSecCause','$ZCs', 'True')}
			<File name="SigRule\SigRules_HMITrainRSMCommand.xml" check="N"/>
			<File name="Riyadh\SigRules_DynamicEBRSMCommand_{$SERVER_ID}.xml"/>
		</xsl:if>
		<xsl:if test="$SERVER_LEVEL = '_LV2'">
			<File name="SigRule\SigRules_AntiBunching_{$SERVER_ID}.xml" check="N"/>
		</xsl:if>
	</SigRules>
	<Export directory="D:\DataPrep\IDC\IconisAppl">
		<ObjectModel FileName="AppObjectsRIM46_{$SERVER_ID}{$SERVER_LEVEL}.xml"/>
	</Export>
</IDC>
</xsl:template>
</xsl:stylesheet>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="versions_xml"/>
<%def name="gen_file(list_files)">
	% for item  in list_files :
		<File name="${item}"/> 
	% endfor
</%def>
<%def name="iter_equip(file,equp, chk='False')">
	<xsl:for-each select="${equp}">
		<File name="${file}_{@id}.xml">
		%	if (chk=='True') :
			<xsl:attribute name="check">N</xsl:attribute>
		%	endif
		</File>
	</xsl:for-each>
</%def>