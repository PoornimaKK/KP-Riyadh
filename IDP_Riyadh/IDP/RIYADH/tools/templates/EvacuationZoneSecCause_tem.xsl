<%inherit file="/Object_tem.mako"/>
<%! 
  class_ = "EvacuationZoneSecStatus"
  add_alias_function = True
 %>
<%block name="classes">
	<Class name="EvacuationZoneSecStatus">
		<Objects>
			<xsl:apply-templates select="$sysdb//Evacuation_Zone_Sec[sys:zc/@id=$ZC_ID]"/>
		</Objects>
	</Class>
</%block>
<xsl:template match="Evacuation_Zone_Sec">
	<xsl:variable name="obj" select="concat(@Name,'.EvacCause')"/>
	<xsl:variable name="bmz_id" select="Basic_Multitrack_Zone_ID_List/Basic_Multitrack_Zone_ID"/>
	<xsl:variable name="blckid" select="//Block[@ID=(//Elementary_Zone[@ID=(//Basic_Multitrack_Zone[@ID=$bmz_id]/Elementary_Zone_ID_List/Elementary_Zone_ID)]/Elementary_Zone_Block_ID_List/Block_ID)]/@Name"/>
	<xsl:variable name="blckname" select="for $blk in ($blckid) return concat('TI_',$blk,'.TrackPortion')"/>
	
	<xsl:variable name="zoneReqIDs" select="//Evacuation_Zone_Req[@ID=current()/Evacuation_Zone_Req_ID_List/Evacuation_Zone_Req_ID]/@Name"/>
	<xsl:variable name="zoneReqName" select="for $req in ($zoneReqIDs) return concat('EZRSR_',$req)"/>
	

	<Object name="{$obj}" rules="update_or_create">
		<Properties>
		<Property name="PVEZSS" dt="string"><xsl:value-of select="concat('EZSS_', @Name)"/></Property>
		<PropertyList name="PVsEZRSR">
			<xsl:for-each select="$zoneReqName">
				<ListElem index="{position()}" dt="string"><xsl:value-of select="."/></ListElem>
			</xsl:for-each>
		</PropertyList>
		<PropertyList name="TrackPortion">
			<xsl:for-each select="$blckname">
				<ListElem index="{position()}" dt="string"><xsl:value-of select="."/></ListElem>
			</xsl:for-each>
		</PropertyList>
			${multilingualvalue("$obj")}
		</Properties>
	</Object>
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue"/>