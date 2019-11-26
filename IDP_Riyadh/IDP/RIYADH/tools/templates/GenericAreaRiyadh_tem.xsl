<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "GenericArea"
	add_alias_function = True
%>
<%block name="classes">
	<Class name="GenericArea">
		<Objects>
			<xsl:apply-templates select="$sysdb//Stopping_Area[*/Original_Area/@Original_Area_Type='Platform' and sys:sigarea/@id=$SERVER_ID and Train_Entrance_Prevention_Distance]"/>
			<xsl:apply-templates select="$sysdb//Evacuation_Zone_Req[sys:sigarea/@id=$SERVER_ID]"/>
			<xsl:apply-templates select="$sysdb//Stopping_Area[sys:sigarea/@id=$SERVER_ID and Original_Area_List/Original_Area/@Original_Area_Type='Platform']" mode="washing"/>
		</Objects>
	</Class>
</%block>
<xsl:variable name="blcks" select="//Block"/>
<xsl:template match="Evacuation_Zone_Req|Stopping_Area">
	<xsl:variable name="objname" select="if (local-name()='Evacuation_Zone_Req') then concat(@Name,'.Hold') else concat(@Name,'.StationRestriction')"/>
	<Object name="{$objname}" rules="update_or_create">
		<Properties>
			${prop('SharedOnIdentifier','<xsl:value-of select="$objname"/>')}
			${prop('SharedOnIdentifierDefinition','1','boolean')}
			<xsl:if test="local-name()='Evacuation_Zone_Req'">
				<xsl:variable name="bmz_id" select="Basic_Multitrack_Zone_ID_List/Basic_Multitrack_Zone_ID"/>
				<Property name="Technical" dt="string">TrackPortions(<xsl:value-of select="for $blk in (//Block[@ID=(//Elementary_Zone[@ID=(//Basic_Multitrack_Zone[@ID=$bmz_id]/Elementary_Zone_ID_List/Elementary_Zone_ID)]/Elementary_Zone_Block_ID_List/Block_ID)]/@Name) return concat('TI_',$blk,'.TrackPortion')" separator=";"/>)</Property>
			</xsl:if>
			<xsl:if test="local-name()='Stopping_Area'">
				<xsl:variable name="trainentrance" select="number(Train_Entrance_Prevention_Distance)"/>
				<xsl:variable name="blckid" select="sys:blockid/@id"/>
				<xsl:variable name="blck_kpb" select="min($blcks[@ID=$blckid]/Kp_Begin)"/>
				<xsl:variable name="blck_kpe" select="max($blcks[@ID=$blckid]/Kp_End)"/>
				<xsl:variable name="dir" select="current()/STA_Direction"/>
				
				<xsl:variable name="technical">
				<xsl:call-template name="distance">
					<xsl:with-param name="block" select="if($dir='Up') then ($blcks[@ID=$blcks[@ID=$blckid]/Next_Down_Normal_Block_ID]) else ($blcks[@ID=$blcks[@ID=$blckid]/Next_Up_Normal_Block_ID])"/>
					<xsl:with-param name="trainentrancedist" select="$trainentrance"/>
					<xsl:with-param name="direction" select="$dir"/>
					<xsl:with-param name="length" select="0"/>
				</xsl:call-template>				
				</xsl:variable>
				<Property name="Technical" dt="string">TrackPortions(<xsl:value-of select="for $i in tokenize($technical, ' ') return if($i) then concat('TI_', $i ,'.TrackPortion') else Null" separator=";"/>)</Property>
			</xsl:if>
				${prop('Direction','3','i4')}
				${prop('PropagateAutomaton','1','boolean')}
			<xsl:if test="local-name()='Evacuation_Zone_Req'">	
				${prop('Type','0x00000800')}
			</xsl:if>
			<xsl:variable name="self" select="."/>
        	${multilingualvalue("sys:alias_name($self)")}
		</Properties>
	</Object>
</xsl:template>

<xsl:template match="Stopping_Area" mode="washing">
	<xsl:variable name="ismapproachdistance" select="number(ISM_Approching_Distance)"/>
	<xsl:variable name="kpb" select="//Block[@ID=current()/sys:blockid/@id]/Kp_Begin"/>
	<xsl:variable name="blckid" select="if (Direction='Up') then (//Block[@ID=current()/sys:blockid/@id and Kp_Begin=min($kpb)]/@ID) else (//Block[@ID=current()/sys:blockid/@id and Kp_Begin=max($kpb)]/@ID)"/>
	<xsl:variable name="dir" select="current()/STA_Direction"/>
	<Object name="{@Name}.ISMApproching" rules="update_or_create">
		<Properties>
			${prop('SharedOnIdentifier','<xsl:value-of select="@Name"/>.ISMApproching')}
			${prop('SharedOnIdentifierDefinition','1','boolean')}
			<xsl:variable name="technical">
				<xsl:call-template name="distance">
					<xsl:with-param name="block" select="if($dir='Up') then ($blcks[@ID=$blcks[@ID=$blckid]/Next_Down_Normal_Block_ID]) else ($blcks[@ID=$blcks[@ID=$blckid]/Next_Up_Normal_Block_ID])"/>
					<xsl:with-param name="trainentrancedist" select="$ismapproachdistance"/>
					<xsl:with-param name="direction" select="$dir"/>
					<xsl:with-param name="length" select="0"/>
				</xsl:call-template>			
			</xsl:variable>
			<Property name="Technical" dt="string">TrackPortions(<xsl:value-of select="for $i in tokenize($technical, ' ') return if($i) then concat('TI_', $i ,'.TrackPortion') else Null" separator=";"/>)</Property>
			${prop('Direction','3','i4')}
			${prop('Type','0x00000800')}
			${prop('PropagateAutomaton','1','boolean')}
			<xsl:variable name="self" select="."/>
        	${multilingualvalue("sys:alias_name($self)")}
		</Properties>
	</Object>
</xsl:template>

<xsl:template name="distance">
	<xsl:param name="block"/>
	<xsl:param name="trainentrancedist"/>
	<xsl:param name="length"/>
	<xsl:param name="direction"/>
	<xsl:variable name="len" select="if(number($block/Kp_Begin) &gt; number($block/Kp_End)) then ($length + (number($block/Kp_Begin)-number($block/Kp_End))) else ($length + (number($block/Kp_End)-number($block/Kp_Begin)))"/>
	<xsl:variable name="nextBlock" select="if($direction = 'Up') then $blcks[@ID=$block/Next_Down_Normal_Block_ID] else $blcks[@ID=$block/Next_Up_Normal_Block_ID]"/>
	<xsl:variable name="dir" select="if($direction = 'Up' and $nextBlock/Next_Down_Normal_Block_ID = $block/Next_Down_Normal_Block_ID) then 'Down' else if($direction = 'Down' and $nextBlock/Next_Down_Normal_Block_ID = $block/Next_Down_Normal_Block_ID) then 'Up' else $direction"/>
	<xsl:value-of select="concat($block/@Name, ' ')"/>
	<xsl:if test="$nextBlock">
		<xsl:choose>
			<xsl:when test="number($len) &gt;= number($trainentrancedist)">
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="distance">
					<xsl:with-param name="block" select="$nextBlock"/>
					<xsl:with-param name="trainentrancedist" select="$trainentrancedist"/>
					<xsl:with-param name="length" select="$len"/>
					<xsl:with-param name="direction" select="$dir"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>	

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue,prop"/>