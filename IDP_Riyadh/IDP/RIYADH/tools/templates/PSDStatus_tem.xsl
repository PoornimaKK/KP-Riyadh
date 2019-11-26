<%inherit file="/Object_tem.mako"/>
<%! class_ = "PSDStatus" %>

<%block name="classes">
  	<Class name="PSDStatus">
  		<Objects>
  			<!-- Generate the items of Stopping_Area table -->
  			<xsl:apply-templates select="$sysdb//Stopping_Area[sys:sigarea/@id=$SERVER_ID and (Original_Area_List/Original_Area/@Original_Area_Type='Platform')]"/>
  		</Objects>
  	</Class>
</%block>

<!-- Template to match the Platform table -->
<xsl:template match="Stopping_Area">
	<xsl:variable name="sta" select="concat(@Name,'.PSD')"/>
	<Object name="{$sta}" rules="update_or_create">
		<Properties>
			<!-- MAKO to generate properties -->
			${props([('ID', 'string' ,'<xsl:value-of select="$sta"/>'),
					 ('SharedOnIdentifier', 'string', '<xsl:value-of select="$sta"/>'),('SharedOnIdentifierDefinition', 'boolean', '1')])}
		</Properties>
	</Object>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="props"/>