<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "ISMTrainInfo"
%>
<%block name="classes">
	<Class name="ISMTrainInfo">
		<Objects>
			<xsl:for-each select="$sysdb//ATC_Equipment/Train_ID">
				<xsl:variable name="trainID1" select="format-number(.,'000')"/>
				<xsl:variable name="trainID" select="//Train_Unit[@ID=current()]/RS_Identifier"/>
				<Object name="ATS-ISM.TrainInfo.{$trainID}" rules="update_or_create">
					${prop('TrainID','<xsl:value-of select="."/>')}
					${prop('TrainName','Train<xsl:value-of select="$trainID1"/>')}
				</Object>
			</xsl:for-each>
		</Objects>
	</Class>
</%block>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>