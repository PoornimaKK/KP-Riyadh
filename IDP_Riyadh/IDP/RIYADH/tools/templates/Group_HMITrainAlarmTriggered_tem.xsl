<%inherit file="/Group_tem.mako"/>

<%block name="classes">
	<Class name="HMITrainAlarmTriggered" rules="update" traces="error">
		<Objects>
			<xsl:apply-templates select="$sysdb//Train_Unit"/>
		</Objects>
	</Class>
</%block>

<!-- Template for generating object-->
<xsl:template match="Train_Unit">
	<xsl:variable name="TrainName" select="concat('Train',format-number(@ID, '000'))"/>
	<Object name="{$TrainName}.TriggeredAlarm" rules="update" traces="error">
		<Properties>
			<Property name="AreaGroup" dt="string">Area/Trains/Train_<xsl:value-of select="format-number(@ID, '000')"/></Property>
			<Property name="FunctionGroup" dt="string">Function/Signalling</Property>
		</Properties>
	</Object>
</xsl:template>

