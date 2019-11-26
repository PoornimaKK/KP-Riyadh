<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "DepotModule"
	name="DepotModule"
%>
<%block name="classes">
	<Class name="DepotModule">
		<Objects>
			<xsl:apply-templates select="//DepotModules/DepotModule"/>
		</Objects>
	</Class>
</%block>

<xsl:template match="DepotModule">	
		<Object name="DepotModule" rules="update_or_create">
		<Properties>
			<xsl:for-each select="//DepotModules/DepotModule/ApproachStopping_Area_ID_List">
				<xsl:variable name="stoppingareaname"><xsl:value-of select="//Stopping_Area[@ID=current()/Stopping_Areas_ID]/@Name" separator=";"/></xsl:variable>			
				<Property name="DepotStablingApproachTrack" dt="string"><xsl:value-of select="$stoppingareaname"/></Property>
			</xsl:for-each>	
			<Property name="DepotStablingLocationList" dt="string"></Property>
			<Property name="LastUpdateTime" dt="string"></Property>
			<Property name="SharedOnIdentifier" dt="string">DepotModule</Property>
			<Property name="SharedOnIdentifierDefinition" dt="boolean">1</Property>
		</Properties>
	</Object>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>