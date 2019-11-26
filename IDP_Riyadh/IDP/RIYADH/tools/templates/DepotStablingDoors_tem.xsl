<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "DepotStablingDoors"
	name="DepotStablingDoors"
%>
<%block name="classes">
	<Class name="DepotStablingDoors">
		<Objects>
			<xsl:apply-templates select="//Depot_Stabling_Door"/>
		</Objects>
	</Class>
</%block>

<xsl:template match="Depot_Stabling_Door">
<xsl:variable name="yy" select="concat('ATS-SCADA.DepotStablingDoors.',@Name)"/>
	<Object name="{$yy}" rules="update_or_create">
		<Properties>
			<Property name="DepotStablingDoorID" dt="string"><xsl:value-of select="@Name"/></Property>
			<Property name="DoorStatus_PV" dt="string"><xsl:value-of select="concat('SCADA-ATS.DepotStablingDoors.',@Name,'.CloseFbk')"/></Property>
			<Property name="RemoteMode_PV" dt="string"><xsl:value-of select="concat('SCADA-ATS.DepotStablingDoors.',@Name,'.LocalRemote')"/></Property>
		</Properties>
	</Object>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>