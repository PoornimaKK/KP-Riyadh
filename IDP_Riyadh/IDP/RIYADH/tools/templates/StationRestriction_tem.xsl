<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "StationRestriction"
	add_alias_function = True
%>
<%block name="classes">
	<Class name="StationRestrictionApproach">
		<Objects>
			<xsl:apply-templates select="$sysdb//Stopping_Area[*/Original_Area/@Original_Area_Type='Platform' and sys:sigarea/@id=$SERVER_ID and Train_Entrance_Prevention_Distance]"/>
		</Objects>
	</Class>
</%block>
<xsl:template match="Stopping_Area">
	<xsl:variable name="objname" select="concat(@Name,'.StationRestriction')"/>
	<Object name="{$objname}" rules="update_or_create">
		<Properties>
			${prop('InAutomaton_PV','PIA_SR_<xsl:value-of select="@Name"/>')}
			${prop('SharedOnIdentifier','<xsl:value-of select="$objname"/>')}
			${prop('GenericAreaID','<xsl:value-of select="@Name"/>')}
			<xsl:variable name="blckid" select="sys:blockid/@id"/>
			<xsl:variable name="blck_kpb" select="min(//Block[@ID=$blckid]/Kp_Begin)"/>
			<xsl:variable name="blck_kpe" select="max(//Block[@ID=$blckid]/Kp_End)"/>
			<xsl:variable name="kpbgn" select="min(//Block[@ID=$blckid]/Kp_Begin)- (Train_Entrance_Prevention_Distance)"/>
			<xsl:variable name="kpend" select="max(//Block[@ID=$blckid]/Kp_End) + (Train_Entrance_Prevention_Distance)"/>
			<xsl:variable name="blck_list" select="for $i in ($sysdb//Block) return (if ((($i/Kp_Begin &lt;= $kpbgn) and ($i/Kp_End &gt; $kpend)) or (($i/Kp_Begin &gt; $kpbgn) and ($i/Kp_End &lt; $kpend)) or (($i/Kp_Begin &lt; $kpbgn) and ($i/Kp_End &gt;= $kpend))) then ($i/@ID) else null)"/>
			<xsl:variable name="technical">
				<xsl:call-template name="Down_Normal_TP">
					<xsl:with-param name="prev_blck" select="//Block[@ID=$blckid and Kp_Begin=$blck_kpb]/@ID"/>
					<xsl:with-param name="blck_list" select="$blck_list"/>
				</xsl:call-template>
				<xsl:call-template name="Up_Normal_TP">
					<xsl:with-param name="prev_blck" select="//Block[@ID=$blckid and Kp_End=$blck_kpe]/@ID"/>
					<xsl:with-param name="blck_list" select="$blck_list"/>
				</xsl:call-template>
				<xsl:value-of select="//Block[@ID=$blckid]/@Name"/>
			</xsl:variable>
			<Property name="Technical" dt="string">TrackPortions(<xsl:value-of select="for $i in tokenize($technical, ' ') return concat('TI_', $i ,'.TrackPortion')" separator=";"/>)</Property>
			<xsl:variable name="self" select="."/>
        	${multilingualvalue("sys:alias_name($self)")}
		</Properties>
	</Object>
</xsl:template>
<xsl:template name="Up_Normal_TP">
	<xsl:param name="prev_blck"/>
	<xsl:param name="blck_list"/>
	<xsl:variable name="next_up_tp" select="//Block[(@ID = //Block[@ID=$prev_blck]/Next_Up_Normal_Block_ID) and (@ID=$blck_list)]"/>
	<xsl:if test="$next_up_tp">
		<xsl:value-of select="concat($next_up_tp/@Name,' ')"/>
		<xsl:call-template name="Up_Normal_TP">
			<xsl:with-param name="prev_blck" select="$next_up_tp/@ID"/>
			<xsl:with-param name="blck_list" select="$blck_list"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
<xsl:template name="Down_Normal_TP">
	<xsl:param name="prev_blck"/>
	<xsl:param name="blck_list"/>
	<xsl:variable name="next_down_tp" select="//Block[(@ID = //Block[@ID=$prev_blck]/Next_Down_Normal_Block_ID) and (@ID=$blck_list)]"/>
	<xsl:if test="$next_down_tp">
		<xsl:value-of select="concat($next_down_tp/@Name,' ')"/>
		<xsl:call-template name="Down_Normal_TP">
			<xsl:with-param name="prev_blck" select="$next_down_tp/@ID"/>
			<xsl:with-param name="blck_list" select="$blck_list"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue,prop"/>