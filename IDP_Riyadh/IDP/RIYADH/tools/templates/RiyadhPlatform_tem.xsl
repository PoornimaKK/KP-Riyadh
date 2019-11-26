<%inherit file="/Object_tem.mako"/>
<%! class_ = "RiyadhPlatform" %>
<%block name="classes">
	<Class name="RiyadhPlatform">
		<Objects>
			<xsl:apply-templates select="$sysdb//Stopping_Area[sys:sigarea/@id=$SERVER_ID and (Original_Area_List/Original_Area/@Original_Area_Type='Platform')]"/>
		</Objects>
	</Class>
</%block>
<xsl:template match="Stopping_Area">
	<xsl:variable name="stationid" select="Station_ID"/>
	<xsl:variable name="blockid" select="sys:blockid/@id"/>
	<xsl:variable name="pf" select="//Platform[@ID=current()/*/*[@Original_Area_Type='Platform']/@ID]/@Name"/>
	<xsl:variable name="evzonsec" select="for $i in ($sysdb//Evacuation_Zone_Sec[Basic_Multitrack_Zone_ID_List/Basic_Multitrack_Zone_ID = //Basic_Multitrack_Zone[Elementary_Zone_ID_List/Elementary_Zone_ID = //Elementary_Zone[Elementary_Zone_Block_ID_List/Block_ID=$blockid]/@ID]/@ID]/@Name) return (concat('EZSS_',$i))"/>
	<Object name="{@Name}.Riyadh" rules="update_or_create">
		<Properties>
			${prop('GenericAreaID','<xsl:value-of select="@Name"/>')}
			${prop('RegulationPointID','<xsl:value-of select="@Name"/>.ATR')}
			${prop('HoldSkipPointID','<xsl:value-of select="@Name"/>.HoldSkip')}
			${prop('PV_EVSStatus','<xsl:value-of select="$evzonsec[1]"/>')}
			${prop('StationID','<xsl:value-of select="//Station[@ID=$stationid]/@Name"/>')}
			${prop('ISMPlatformInfo','ATS-ISM.PlatformInfo.<xsl:value-of select="$pf"/>')}
			${prop('SCADAPlatformInfo','ATS-SCADA.PlatformInfo.<xsl:value-of select="$pf"/>')}
		</Properties>
	</Object>
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>