<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "ISMPlatformInfo"
	add_alias_function = True
%>
<%block name="classes">
	<Class name="ISMPlatformInfo">
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
	
	<Object name="ATS-ISM.PlatformInfo.{@Name}" rules="update_or_create">
		<Properties>
			${prop('InAutomaton_PV','PIA_SAPP_<xsl:value-of select="$sa/@Name"/>')}
			${prop('SharedOnIdentifier','ATS-ISM.PlatformInfo.<xsl:value-of select="@Name"/>')}
			${prop('GenericAreaID','<xsl:value-of select="$sa/@Name"/>')}
			<xsl:variable name="blk" select="if ($sa/Direction='Up') then (//Block[Next_Up_Normal_Block_ID=$blckid]/@Name) else (//Block[Next_Down_Normal_Block_ID=$blckid]/@Name)"/>
			<Property name="technical" dt="string">TrackPortions(<xsl:value-of select="if ($blk) then concat('TI_',$blk,'.TrackPortion') else concat('TI_',//Block[@ID=$blckid]/@Name,'.TrackPortion')"/>)</Property>
			${prop('PV_EVSStatus','<xsl:value-of select="$evzonsec[1]"/>')}
			<xsl:variable name="self" select="."/>
        	${multilingualvalue("sys:alias_name($self)")}
		</Properties>
	</Object>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue,prop"/>