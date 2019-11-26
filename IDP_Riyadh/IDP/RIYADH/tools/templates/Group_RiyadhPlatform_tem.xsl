<%inherit file="/Group_tem.mako"/>

<%block name="classes">
	<Class name="RiyadhPlatform" rules="update" traces="error">
		<Objects>
			<xsl:apply-templates select="$sysdb//Stopping_Area[sys:sigarea/@id=$SERVER_ID and (Original_Area_List/Original_Area/@Original_Area_Type='Platform')]"/>
		</Objects>
	</Class>
</%block>

<!-- Template for generating object-->
<xsl:template match="Stopping_Area">
	<Object name="{@Name}.Riyadh" rules="update" traces="error">
		<Properties>
			<Property name="AreaGroup" dt="string">Area/<xsl:value-of select="sys:line/@name"/></Property>
			<Property name="FunctionGroup" dt="string">Function/Regulation</Property>
		</Properties>
	</Object>
</xsl:template>