<%inherit file="/Object_tem.mako"/>
<%! class_ = "SCADAStationInfo" %>

<%block name="classes">
	<Class name="SCADAStationInfo">
    	<Objects>
		<xsl:variable name="platformid"  select="$sysdb//Stopping_Area[sys:sigarea/@id=$SERVER_ID]/Original_Area_List/Original_Area[@Original_Area_Type='Platform']/@ID"/>
    	  <xsl:apply-templates select="//Station[Platform_ID_List/Platform_ID = $platformid]"/>
  		</Objects>
    </Class>
</%block>

<xsl:template match="Station">
	<Object name="SCADAStationInfo.{@Name}" rules="update_or_create">
		<xsl:variable name="blockid" select="$sysdb//Stopping_Area[Original_Area_List/Original_Area[@Original_Area_Type='Platform' and @ID=current()/Platform_ID_List/Platform_ID]]/sys:blockid/@id"/>
		<xsl:variable name="evzonsec" select="$sysdb//Evacuation_Zone_Sec[Basic_Multitrack_Zone_ID_List/Basic_Multitrack_Zone_ID = //Basic_Multitrack_Zone[Elementary_Zone_ID_List/Elementary_Zone_ID = //Elementary_Zone[Elementary_Zone_Block_ID_List/Block_ID=$blockid]/@ID]/@ID]/@Name"/>
	    <xsl:variable name="evname2" select="concat('SCADAStationInfo.',@Name)"/>
		<xsl:variable name="evname1" select="concat('EZSS_',$evzonsec)"/>
		<Properties>
			${props([('EVSStatus_PV','string','<xsl:value-of select="$evname1"/>') ,('SharedOnIdentifier','string','<xsl:value-of select="$evname2"/>')])}
		</Properties>
	</Object>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="props"/>