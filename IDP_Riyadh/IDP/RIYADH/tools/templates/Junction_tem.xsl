<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "Junction"
	name = "Junction"
%>
<%block name="classes">
	<Class name="Junction">
		<Objects>
			<xsl:apply-templates select="$sysdb//Junction_Area[sys:sigarea/@id=$SERVER_ID and (NOOT_Strategy_Presence='true' or FCFS_Strategy_Presence='true')]"/>
		</Objects>
	</Class>
</%block>
<xsl:template match="Junction_Area">
	<xsl:variable name="tt" select="concat(@Name,'.Riyadh')"/>
	<Object name="{$tt}" rules="update_or_create">
		${prop("SharedOnIdentifier",'<xsl:value-of select="$tt"/>')}
		${prop("JuntionID",'<xsl:value-of select="@Name"/>')}
	</Object>
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>