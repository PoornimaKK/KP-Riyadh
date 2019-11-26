<%inherit file="/Object_tem.mako"/>
<%! class_ = "WashPoint" %>

<%block name="classes">
  	<Class name="WashPoint">
  		<Objects>
<!-- 			<xsl:variable name="sta" select="$sysdb//Train_Washing/Wash_Destination_Stopping_Area_ID,$sysdb//Train_Washing/No_Wash_Destination_Stopping_Area_ID"/> -->
  			<xsl:for-each select="distinct-values(//Stopping_Area[sys:sigarea/@id = $SERVER_ID and Original_Area_List/Original_Area/@Original_Area_Type='Washing']/@Name)">
				<xsl:variable name="self" select="."/>
				<Object name="{$self}.Washing" rules="update_or_create">
					<Properties>
						<Property name="SharedOnIdentifier" dt="string"><xsl:value-of select="concat($self,'.Washing')"/></Property>
						<Property name="RegulationPointID" dt="string"><xsl:value-of select="$self"/>.ATR</Property>
					</Properties>
				</Object>
			</xsl:for-each>
  		</Objects>
  	</Class>
</%block>