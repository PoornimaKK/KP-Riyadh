<%inherit file="/Object_tem.mako"/>
<%! class_ = "HMITrainAlarmMonitored" %>



<%block name="classes">
	<Class name="HMITrainAlarmTriggered">
		<Objects>
			<xsl:apply-templates select="$sysdb//Train_Unit"/>
		</Objects>
	</Class>
</%block>

<!-- Template for generating object-->
<xsl:template match="Train_Unit">
	<xsl:variable name="TrainName" select="concat('Train',format-number(@ID, '000'))"/>
	<xsl:variable name="TrainName1" select="concat('Train',current()/RS_Identifier)"/>
	<Object name="{$TrainName}.TriggeredAlarm" rules="update_or_create">
		<Properties>
			<Property name="TrainIdentifier" dt="string"><xsl:value-of select="current()/RS_Identifier"/></Property>
			<Property name="RejectedKeys" dt="string">ALM_*;MSG_*;ATR_DELAYTRAINDEPARTURE;ATR_ADVANCETRAINDEPARTURE;ATR_ADVANCETRAINARRIVAL;TPMA_EXTREMEDELAYADVANCE;REGTRAIN_TRAINEXTREMEDELAY;REGTRAIN_TRAINEXTREMEDELAY_DOWN;REGTRAIN_TRAINEXTREMEADVANCE;REGTRAIN_TRAINEXTREMEADVANCE_DOWN</Property>
			${multilingualvalue('$TrainName1')}
		</Properties>
	</Object>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue, props"/>
