<%inherit file="/Object_tem.mako"/>
<%! class_ = "HMITrainAlarmMonitored" %>



<%block name="classes">
	<Class name="HMITrainAlarmMonitored">
		<Objects>
			<!-- Call template for generating object-->
			<xsl:apply-templates select="document('../tools/Input_HMITrainAlarmMonitored.xml')//Object"/>
		</Objects>
	</Class>
</%block>

<!-- Template for generating object-->
<xsl:template match="Object">
	<xsl:variable name="name"><xsl:value-of select="@name"/></xsl:variable>
	<xsl:variable name="TrainIdentifier"><xsl:value-of select="Properties/Property[@name='TrainIdentifier']/text()"/></xsl:variable>
	<xsl:variable name="AcceptedKeys"><xsl:value-of select="Properties/Property[@name='AcceptedKeys']/text()"/></xsl:variable>
	<xsl:for-each select="$sysdb//Train_Unit">
		<xsl:variable name="tid" select="replace($TrainIdentifier, 'TrainXXX', @ID)"/>
		<xsl:variable name="rsid" select="//Trains_Unit/Train_Unit[@ID=$tid]/RS_Identifier"/>
		<xsl:variable name="rsidname" select="concat('Train',//Trains_Unit/Train_Unit[@ID=$tid]/RS_Identifier)"/>
		<xsl:variable name="object_Name" select="replace($name,'XXX',format-number(@ID, '000'))"/>
		<xsl:variable name="TrainName" select="replace($TrainIdentifier, 'XXX', format-number(@ID, '000'))"/>
		<Object name="{$object_Name}" rules="update_or_create">
			<Properties>
				<Property name="TrainIdentifier" dt="string"><xsl:value-of select="$rsid"/></Property>
				<Property name="AcceptedKeys" dt="string"><xsl:value-of select="$AcceptedKeys"/></Property>
				${multilingualvalue('$rsidname')}
			</Properties>
		</Object>
	</xsl:for-each>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue, props"/>
