<%inherit file="/Object_tem.mako"/>
<%! 
  class_ = "AntiBunching"
  add_alias_function = True
 %>
<%block name="classes">
	<Class name="AntiBunching">
		<Objects>
			<xsl:variable name="sa" select="$sysdb//Inter_Stopping_Area[@ID=//Monitoring_Trains_Zone[Inter_Stopping_Area_ID]/Inter_Stopping_Area_ID]/Stopping_Area_Origin_ID, $sysdb//Monitoring_Trains_Zone[Origin_Stopping_Area_ID]/Origin_Stopping_Area_ID"/>
			<xsl:apply-templates select="$sysdb//Stopping_Area[@ID=distinct-values($sa) and sys:sigarea/@id=$SERVER_ID]"/>
		</Objects>
	</Class>
</%block>
<xsl:template match="Stopping_Area">
	<xsl:variable name="id" select="@ID"/>
	<xsl:variable name="objname" select="concat(@Name,'.AntiBunching')"/>
	<Object name="{$objname}" rules="update_or_create">
		<Properties>
			${prop('PlatformID','<xsl:value-of select="@Name"/>')}
			${prop('SharedOnIdentifier','<xsl:value-of select="$objname"/>')}
			${prop('HoldSkipPointID','<xsl:value-of select="@Name"/>.HoldSkip')}
			<xsl:variable name="mtzname"><xsl:value-of select="$sysdb//Monitoring_Trains_Zone[Inter_Stopping_Area_ID=$sysdb//Inter_Stopping_Area[Stopping_Area_Origin_ID=$id]/@ID]/@Name, $sysdb//Monitoring_Trains_Zone[Origin_Stopping_Area_ID=$id]/@Name" separator=";"/></xsl:variable>
			${multilingualvalue("$mtzname","MTZList")}
		</Properties>
	</Object>
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue,prop"/>