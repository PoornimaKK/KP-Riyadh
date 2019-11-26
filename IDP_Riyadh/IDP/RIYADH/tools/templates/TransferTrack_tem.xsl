<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "TransferTrack"
	name = "TransferTrack"
%>
<%block name="classes">
  	<Class name="TransferTrackPoint">
  		<Objects>
			<xsl:variable name="sta" select="$sysdb//Stopping_Area[sys:sigarea/@id=$SERVER_ID  and @ID=//Train_Washing/Transfer_Track_ID_List/Transfer_Track_ID]/@Name"/>
  			<xsl:for-each select="distinct-values($sta)">
				<xsl:variable name="self" select="."/>
				<Object name="{$self}.Washing" rules="update_or_create">
					<Properties>
						<Property name="GenericAreaID" dt="string"><xsl:value-of select="$self"/></Property>
						<Property name="SharedOnIdentifier" dt="string"><xsl:value-of select="$self"/>.Washing</Property>
						<Property name="RegulationPointID" dt="string"><xsl:value-of select="$self"/>.ATR</Property>
					</Properties>
				</Object>
			</xsl:for-each>
  		</Objects>
  	</Class>
</%block>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>