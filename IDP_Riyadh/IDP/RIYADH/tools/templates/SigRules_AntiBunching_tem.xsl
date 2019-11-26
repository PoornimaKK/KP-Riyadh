<%inherit file="/SigRules_tem.mako"/>
<%block name="main">
	<xsl:variable name="sa" select="$sysdb//Inter_Stopping_Area[@ID=//Monitoring_Trains_Zone[Inter_Stopping_Area_ID]/Inter_Stopping_Area_ID]/Stopping_Area_Origin_ID, $sysdb//Monitoring_Trains_Zone[Origin_Stopping_Area_ID]/Origin_Stopping_Area_ID"/>
	<xsl:apply-templates select="$sysdb//Stopping_Area[@ID=distinct-values($sa) and sys:sigarea/@id=$SERVER_ID]"/>
</%block>
<xsl:template match="Stopping_Area">
	<xsl:variable name="id" select="@ID"/>
	<xsl:variable name="nm" select="concat(@Name,'.AntiBunching')"/>
	<xsl:variable name="mtzname"><xsl:value-of select="$sysdb//Monitoring_Trains_Zone[Inter_Stopping_Area_ID=$sysdb//Inter_Stopping_Area[Stopping_Area_Origin_ID=$id]/@ID]/@Name, $sysdb//Monitoring_Trains_Zone[Origin_Stopping_Area_ID=$id]/@Name"/></xsl:variable>
	<xsl:variable name="eqn1"><xsl:value-of select="for $i in tokenize($mtzname,' ') return(concat('(',$i,'.MTZ.RegLink.NumberOfTrains &gt;= ',$i,'.MTZ.RegLink.MaxTrainNumberLimited)'))" separator="||"/></xsl:variable>
	<xsl:variable name="eqn2"><xsl:value-of select="for $i in tokenize($mtzname,' ') return(concat('(',$i,'.MTZ.RegLink.NumberOfTrains &lt; ',$i,'.MTZ.RegLink.MaxTrainNumberLimited)'))" separator="&amp;&amp;"/></xsl:variable>
	<Equipment name="{$nm}" type="AntiBunching" flavor="AutomaticHold">
		<Requisites>
			<Equation><xsl:value-of select="$nm"/>.HoldCmd.IntOutputPlug_1#1[HOLD]::<xsl:value-of select="$eqn1"/></Equation>
			<Equation><xsl:value-of select="$nm"/>.HoldCmd.IntOutputPlug_1#2[RELEASE]::<xsl:value-of select="$eqn2"/></Equation>
		</Requisites>
		<CommandResults>
			<Equation><xsl:value-of select="$nm"/>.HoldCmd.IntOutputPlug_1#1[HOLD]::1</Equation>
			<Equation><xsl:value-of select="$nm"/>.HoldCmd.IntOutputPlug_1#2[RELEASE]::1</Equation>
		</CommandResults>
	</Equipment>   
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->