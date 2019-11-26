<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "SCADAInterface"
	name="SCADATrainInfo"
%>
<%block name="classes">
	<Class name="SCADATrainInfo">
		<Objects>
			<xsl:apply-templates select="//ATC_Equipment[Train_ID!='']"/>
		</Objects>
	</Class>
</%block>

<xsl:template match="ATC_Equipment">
	<xsl:variable name="trainID" select="format-number(Train_ID,'000')"/>
	<xsl:variable name="TrainName" select="concat('Train',format-number(Train_ID,'000'))"/>
	<Object name="ATS-SCADA.TrainInfo.{$trainID}" rules="update_or_create">
		<Properties>
			<Property name="TrainID" dt="string"><xsl:value-of select="$trainID"/></Property>
			<Property name="TrainName" dt="string"><xsl:value-of select="$TrainName"/></Property>
		</Properties>
	</Object>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>