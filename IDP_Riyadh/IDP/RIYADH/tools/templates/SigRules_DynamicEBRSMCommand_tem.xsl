<%inherit file="/SigRules_tem.mako"/>
<%block name="main">
    <xsl:apply-templates select="$sysdb//Train_Unit"/>
</%block>


<xsl:template match="Train_Unit">
	<xsl:variable name="TrainName" select="concat('Train',format-number(@ID,'000'))"/>
	<xsl:variable name="objname" select="concat('Train',format-number(@ID,'000'),'.DynamicEB')"/>
	<%
	tt = "<xsl:value-of select='$objname'/>"
	%>
 <Equipment name="{$objname}" type="DynamicEB" flavor="DynamicEBCmd" CommandTimeOut="12" >
	<Requisites>
		<Equation><xsl:value-of select="$objname"/>.DynamicEBScript.IntOutputPlug_1#1::1</Equation>
		<Equation><xsl:value-of select="$objname"/>.DynamicEBScript.IntOutputPlug_1#2::1</Equation>
	</Requisites>
	<CommandResults>
		<Equation><xsl:value-of select="$objname"/>.DynamicEBScript.IntOutputPlug_1#1::1</Equation>
		<Equation><xsl:value-of select="$objname"/>.DynamicEBScript.IntOutputPlug_1#2::1</Equation>
	</CommandResults>
 </Equipment>


</xsl:template>   		

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
