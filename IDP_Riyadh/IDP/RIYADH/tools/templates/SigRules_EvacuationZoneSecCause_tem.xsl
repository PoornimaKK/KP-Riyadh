<%inherit file="/SigRules_tem.mako"/>
<%block name="main">
	<xsl:apply-templates select="$sysdb//Evacuation_Zone_Sec[sys:zc/@id = $ZC_ID]"/>
</%block>

<xsl:template match="Evacuation_Zone_Sec">
	<xsl:variable name="tt" select="concat(@Name,'.EvacCause')"/>
	<xsl:variable name="xx_eqn_0"><xsl:value-of select="for $item in SPKS_ID_List/SPKS_ID return (concat('(',//SPKS[@ID = $item]/@Name,'.Status.Value == 0)'))" separator=" || "/></xsl:variable>
	<xsl:variable name="xx_eqn_1"><xsl:value-of select="for $item in SPKS_ID_List/SPKS_ID return (concat('(',//SPKS[@ID = $item]/@Name,'.Status.Value == 1)'))" separator=" &amp;&amp; "/></xsl:variable>
	<xsl:variable name="T1" select="'Train1.HMITETrain.longPlug_1'"/>
	<xsl:variable name="T2" select="'Train2.HMITETrain.longPlug_1'"/>
	<xsl:variable name="T3" select="'Train3.HMITETrain.longPlug_1'"/>
	
	<!-- Equations -->
	<xsl:variable name="eqn_0"><xsl:if test="normalize-space($xx_eqn_0)">(${var('$xx_eqn_0')}) &amp;&amp; </xsl:if>((??(${var('$tt')}.${var('$T1')}) &amp;&amp; (${var('$tt')}.${var('$T1')} == 0 || ${var('$tt')}.${var('$T1')} == 1)) || !(??(${var('$tt')}.${var('$T1')}))) &amp;&amp; ((??(${var('$tt')}.${var('$T2')}) &amp;&amp; (${var('$tt')}.${var('$T2')} == 0 || ${var('$tt')}.${var('$T2')} == 1)) || !(??(${var('$tt')}.${var('$T2')}))) &amp;&amp; ((??(${var('$tt')}.${var('$T3')}) &amp;&amp; (${var('$tt')}.${var('$T3')} == 0 || ${var('$tt')}.${var('$T3')} == 1)) || !(??(${var('$tt')}.${var('$T3')}))) &amp;&amp; (${var('$tt')}.IsOpReq.IntOutputPlug_1 == 0)</xsl:variable>
	<xsl:variable name="eqn_1"><xsl:if test="normalize-space($xx_eqn_1)">(${var('$xx_eqn_1')}) &amp;&amp; </xsl:if>(??(${var('$tt')}.${var('$T1')}) &amp;&amp; (${var('$tt')}.${var('$T1')} == 2) || ??(${var('$tt')}.${var('$T2')}) &amp;&amp; (${var('$tt')}.${var('$T2')} == 2) || ??(${var('$tt')}.${var('$T3')}) &amp;&amp; (${var('$tt')}.${var('$T3')} == 2)) &amp;&amp; (${var('$tt')}.IsOpReq.IntOutputPlug_1 == 0)</xsl:variable>
	<xsl:variable name="eqn_2"><xsl:if test="normalize-space($xx_eqn_1)">(${var('$xx_eqn_1')}) &amp;&amp; </xsl:if>((??(${var('$tt')}.${var('$T1')}) &amp;&amp; (${var('$tt')}.${var('$T1')} == 0 || ${var('$tt')}.${var('$T1')} == 1)) || !(??(${var('$tt')}.${var('$T1')}))) &amp;&amp; ((??(${var('$tt')}.${var('$T2')}) &amp;&amp; (${var('$tt')}.${var('$T2')} == 0 || ${var('$tt')}.${var('$T2')} == 1)) || !(??(${var('$tt')}.${var('$T2')}))) &amp;&amp; ((??(${var('$tt')}.${var('$T3')}) &amp;&amp; (${var('$tt')}.${var('$T3')} == 0 || ${var('$tt')}.${var('$T3')} == 1)) || !(??(${var('$tt')}.${var('$T3')}))) &amp;&amp; (${var('$tt')}.IsOpReq.IntOutputPlug_1 == 1)</xsl:variable>
	<xsl:variable name="eqn_3"><xsl:if test="normalize-space($xx_eqn_0)">(${var('$xx_eqn_0')}) &amp;&amp; </xsl:if>(??(${var('$tt')}.${var('$T1')}) &amp;&amp; (${var('$tt')}.${var('$T1')} == 2) || ??(${var('$tt')}.${var('$T2')}) &amp;&amp; (${var('$tt')}.${var('$T2')} == 2) || ??(${var('$tt')}.${var('$T3')}) &amp;&amp; (${var('$tt')}.${var('$T3')} == 2)) &amp;&amp; (${var('$tt')}.IsOpReq.IntOutputPlug_1 == 0)</xsl:variable>
	<xsl:variable name="eqn_4"><xsl:if test="normalize-space($xx_eqn_0)">(${var('$xx_eqn_0')}) &amp;&amp; </xsl:if>((??(${var('$tt')}.${var('$T1')}) &amp;&amp; (${var('$tt')}.${var('$T1')} == 0 || ${var('$tt')}.${var('$T1')} == 1)) || !(??(${var('$tt')}.${var('$T1')}))) &amp;&amp; ((??(${var('$tt')}.${var('$T2')}) &amp;&amp; (${var('$tt')}.${var('$T2')} == 0 || ${var('$tt')}.${var('$T2')} == 1)) || !(??(${var('$tt')}.${var('$T2')}))) &amp;&amp; ((??(${var('$tt')}.${var('$T3')}) &amp;&amp; (${var('$tt')}.${var('$T3')} == 0 || ${var('$tt')}.${var('$T3')} == 1)) || !(??(${var('$tt')}.${var('$T3')}))) &amp;&amp; (${var('$tt')}.IsOpReq.IntOutputPlug_1 == 1)</xsl:variable>
	<xsl:variable name="eqn_5"><xsl:if test="normalize-space($xx_eqn_1)">(${var('$xx_eqn_1')}) &amp;&amp; </xsl:if>(??(${var('$tt')}.${var('$T1')}) &amp;&amp; (${var('$tt')}.${var('$T1')} == 2) || ??(${var('$tt')}.${var('$T2')}) &amp;&amp; (${var('$tt')}.${var('$T2')} == 2) || ??(${var('$tt')}.${var('$T3')}) &amp;&amp; (${var('$tt')}.${var('$T3')} == 2)) &amp;&amp; (${var('$tt')}.IsOpReq.IntOutputPlug_1 == 1)</xsl:variable>
	<xsl:variable name="eqn_6"><xsl:if test="normalize-space($xx_eqn_0)">(${var('$xx_eqn_0')}) &amp;&amp; </xsl:if>(??(${var('$tt')}.${var('$T1')}) &amp;&amp; (${var('$tt')}.${var('$T1')} == 2) || ??(${var('$tt')}.${var('$T2')}) &amp;&amp; (${var('$tt')}.${var('$T2')} == 2) || ??(${var('$tt')}.${var('$T3')}) &amp;&amp; (${var('$tt')}.${var('$T3')} == 2)) &amp;&amp; (${var('$tt')}.IsOpReq.IntOutputPlug_1 == 1)</xsl:variable>
	
	<Equipment name="{$tt}" type="EvacuationZoneSecStatus" flavor="Cause">
		<States>
			<Equation>EVAC_BY_SPKS[0]::<xsl:value-of select="$eqn_0"/></Equation>
			<Equation>EVAC_BY_TRAIN[1]::<xsl:value-of select="$eqn_1"/></Equation>
			<Equation>EVAC_BY_OPER[2]::<xsl:value-of select="$eqn_2"/></Equation>
			<Equation>EVAC_BY_SPKS_TRAIN[3]::<xsl:value-of select="$eqn_3"/></Equation>
			<Equation>EVAC_BY_SPKS_OPER[4]::<xsl:value-of select="$eqn_4"/></Equation>
			<Equation>EVAC_BY_TRAIN_OPER[5]::<xsl:value-of select="$eqn_5"/></Equation>
			<Equation>EVAC_BY_ALL[6]::<xsl:value-of select="$eqn_6"/></Equation>
			<Equation>NO_EVAC[7]::1</Equation>
		</States>
	</Equipment>
</xsl:template>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->

<%def name="var(obj)"><xsl:value-of select="${obj}"/></%def>