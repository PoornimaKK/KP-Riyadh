<%inherit file="/Group_tem.mako"/>

<%block name="classes">
	<Class name="HMITrainAlarmMonitored" rules="update" traces="error">
		<Objects>
			<!-- Call template for generating object-->
			<xsl:apply-templates select="document('../tools/Input_HMITrainAlarmMonitored.xml')//Object"/>
		</Objects>
	</Class>
</%block>

<!-- Template for generating object-->
<xsl:template match="Object">
	<xsl:variable name="name"><xsl:value-of select="@name"/></xsl:variable>
	<xsl:for-each select="$sysdb//Train_Unit">
		<xsl:variable name="object_Name" select="replace($name,'XXX',format-number(@ID, '000'))"/>
		<Object name="{$object_Name}" rules="update" traces="error">
			<Properties>
				<Property name="AreaGroup" dt="string">Area/Trains/Train_<xsl:value-of select="format-number(@ID, '000')"/></Property>
				<Property name="FunctionGroup" dt="string">Function/Signalling</Property>
			</Properties>
		</Object>
	</xsl:for-each>
</xsl:template>

