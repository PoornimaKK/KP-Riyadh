<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "SCADAInterface"
	name="SCADAPlatformInfo"
%>
<%block name="classes">
	<Class name="SCADAPlatformInfo">
		<Objects>
			<xsl:apply-templates select="$sysdb//Platform[@ID=//Stopping_Area[sys:sigarea/@id=$SERVER_ID]/*/*[@Original_Area_Type='Platform']/@ID]"/>
		</Objects>
	</Class>
</%block>

<xsl:template match="Platform">
	<xsl:variable name="sa" select="//Stopping_Area[*/*[@Original_Area_Type='Platform']/@ID=current()/@ID]"/>
	<xsl:variable name="kpb" select="//Block[@ID=$sa/sys:blockid/@id]/Kp_Begin"/>
	<xsl:variable name="blckid" select="if ($sa/Direction='Up') then (//Block[@ID=$sa/sys:blockid/@id and Kp_Begin=min($kpb)]/@ID) else (//Block[@ID=$sa/sys:blockid/@id and Kp_Begin=max($kpb)]/@ID)"/>
	<xsl:variable name="evzonsec" select="for $i in ($sysdb//Evacuation_Zone_Sec[Basic_Multitrack_Zone_ID_List/Basic_Multitrack_Zone_ID = //Basic_Multitrack_Zone[Elementary_Zone_ID_List/Elementary_Zone_ID = //Elementary_Zone[Elementary_Zone_Block_ID_List/Block_ID=$blckid]/@ID]/@ID]/@Name) return (concat('EZS_',$i))"/>
	<Object name="ATS-SCADA.PlatformInfo.{@Name}" rules="update_or_create">
		<Properties>
			${prop('SharedOnIdentifier','ATS-SCADA.PlatformInfo.<xsl:value-of select="@Name"/>')}
			${prop('PV_EVSStatus','<xsl:value-of select="$evzonsec[1]"/>')}
		</Properties>
	</Object>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>