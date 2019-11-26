<%inherit file="/Object_tem.mako"/>
<%! class_ = "EvacuationZone" %>
<%block name="classes">
	<Class name="EvacuationZone">
		<Objects>
			<xsl:apply-templates select="$sysdb//Evacuation_Zone_Req[sys:sigarea/@id=$SERVER_ID]"/>
		</Objects>
	</Class>
</%block>
<xsl:template match="Evacuation_Zone_Req">
	<xsl:variable name="objname" select="concat(@Name,'.Hold')"/>
	<xsl:variable name="bmz_id" select="Basic_Multitrack_Zone_ID_List/Basic_Multitrack_Zone_ID"/>
	<Object name="{$objname}" rules="update_or_create">
		<Properties>
			${prop('PV_EZRStatus','EZR_<xsl:value-of select="@Name"/>')}
			${prop('InAutomaton_PV','PIA_<xsl:value-of select="@Name"/>')}
			${prop('SharedOnIdentifier','<xsl:value-of select="$objname"/>')}
			<Property name="Technical" dt="string">TrackPortions(<xsl:value-of select="for $blk in (//Block[@ID=(//Elementary_Zone[@ID=(//Basic_Multitrack_Zone[@ID=$bmz_id]/Elementary_Zone_ID_List/Elementary_Zone_ID)]/Elementary_Zone_Block_ID_List/Block_ID)]/@Name) return concat('TI_',$blk,'.TrackPortion')" separator=";"/>)</Property>
			${prop('Type','0x00000800')}
		</Properties>
	</Object>
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>