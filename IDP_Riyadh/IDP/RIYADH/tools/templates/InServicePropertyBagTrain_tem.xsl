<%inherit file="/Object_tem.mako"/>
<%! class_ = "InServicePropertyBagTrain" %>
<%block name="classes">
	<Class name="InServicePropertyBagTrain">
		<Objects>
			<xsl:apply-templates select="$sysdb//Train_Unit"/>
		</Objects>
	</Class>
</%block>
<xsl:template match="Train_Unit">
	<xsl:variable name="obj" select="concat('Train',format-number(@ID,'000'))"/>
	<Object name="{$obj}.InService" rules="update_or_create">
		<Properties>
			<Property name="TrainName" dt="string"><xsl:value-of select="$obj"/></Property>
		</Properties>
	</Object>
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->