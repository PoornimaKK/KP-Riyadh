<%inherit file="/Object_tem.mako"/>
<%! class_ = "RSCommand" %>
<%block name="classes">
	<Class name="RSCommand">
		<Objects>
			<xsl:variable name="obj" select="'RSCommand'"/>
			<Object name="RSCommand" rules="update_or_create">
				<Properties>
					<PropertyList name="PV_RSRestrictionCmd">
						<xsl:apply-templates select="$sysdb//Train_Unit"/>
					</PropertyList>
					${prop('SharedOnIdentifier','RSCommand')}
					${multilingualvalue('$obj')}
				</Properties>
			</Object>
		</Objects>
	</Class>
</%block>
<xsl:template match="Train_Unit">
	<xsl:variable name="obj" select="concat('RSCMD_','Train',current()/RS_Identifier)"/>
	<ListElem index="{position()}" dt="string"><xsl:value-of select="$obj"/></ListElem>
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue,prop"/>