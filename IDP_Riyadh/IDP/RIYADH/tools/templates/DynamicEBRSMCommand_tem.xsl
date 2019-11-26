<%inherit file="/Object_tem.mako"/>
<%! class_ = "DynamicEB" %>
<%block name="classes">
	<Class name="DynamicEB">
		<Objects>
			<xsl:apply-templates select="//Trains_Unit/Train_Unit"/>
		</Objects>
	</Class>
</%block>
<xsl:template match="Train_Unit">
<xsl:variable name="TrainName" select="concat('Train',format-number(@ID,'000'))"/>
<xsl:variable name="objname" select="concat('Train',format-number(@ID,'000'),'.DynamicEB')"/>
<xsl:variable name="quote">"</xsl:variable>
	<Object name="{$objname}" rules="update_or_create">
		<Properties>
			${prop('SharedOnIdentifier','<xsl:value-of select="$objname"/>')}
			${prop('SharedOnIdentifierDefinition','1','boolean')}
			<Property name="DynamicEBScript_Release" dt="string"><xsl:value-of select="concat('%RollingStockID%|',current()/RS_Identifier,'|XmlRSMCommand|&lt;GenericSettingRequest&gt;&lt;Field name=','&quot;DYNAMIC_EB_TEST_REQUEST&quot;',' value=','&quot;00&quot;',' DEMUX=',$quote,'1',$quote,'/&gt; &lt;/GenericSettingRequest&gt;')"/></Property>
			<Property name="DynamicEBScript_Set" dt="string"><xsl:value-of select="concat('%RollingStockID%|',current()/RS_Identifier,'|XmlRSMCommand|&lt;GenericSettingRequest&gt;&lt;Field name=','&quot;DYNAMIC_EB_TEST_REQUEST&quot;',' value=','&quot;01&quot; DEMUX=','&quot;1&quot;','/&gt; &lt;/GenericSettingRequest&gt;')"/></Property>
			${multilingualvalue("$objname")}
		</Properties>
	</Object>
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue, prop"/>