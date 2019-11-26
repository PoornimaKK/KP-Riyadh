<%inherit file="/SigRules_tem.mako"/>
<%block name="main">
  <xsl:apply-templates select="$sysdb//Stopping_Area[sys:sigarea/@id=$SERVER_ID and (Original_Area_List/Original_Area/@Original_Area_Type='Platform')]"/>
</%block>

<!-- Template for generating equations from Platforms Table-->
<xsl:template match="Stopping_Area">
	<xsl:variable name="pfid" select="Original_Area_List/Original_Area[@Original_Area_Type='Platform']/@ID"/>
	<xsl:variable name="pf_name" select="$sysdb//Platform[@ID=$pfid[1]]/@Name"/>
	<xsl:variable name="pf_eqn1" select="concat('PSD_',substring-after($pf_name,'PF_'),'_SET1')"/>
	<xsl:variable name="pf_eqn2" select="concat('PSD_',substring-after($pf_name,'PF_'),'_SET2')"/>
	<xsl:variable name="set1" select="//Generic_ATS_IO[ATSI/@Object_Name=concat('GAIO_', $pf_eqn1)]/@Name"/>
	<xsl:if test="$set1">
		${Equipment('PSDStatus','Set1Closed',[('PSD_SET1_NOTCLOSED[0]','GATSM_GAIO_<xsl:value-of select="$pf_eqn1"/>==0'),
			   ('PSD_SET1_CLOSED[1]','GATSM_GAIO_<xsl:value-of select="$pf_eqn1"/>==1')])}
	</xsl:if>
	<xsl:variable name="set2" select="//Generic_ATS_IO[ATSI/@Object_Name=concat('GAIO_', $pf_eqn2)]/@Name"/>
	<xsl:if test="$set2">	
		${Equipment('PSDStatus','Set2Closed',[('PSD_SET2_NOTCLOSED[0]','GATSM_GAIO_<xsl:value-of select="$pf_eqn2"/>==0'),
			   ('PSD_SET2_CLOSED[1]','GATSM_GAIO_<xsl:value-of select="$pf_eqn2"/>==1')])}
	</xsl:if>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->

<%def name="Equipment(type, flavor, list)" >
  <Equipment name="{@Name}.PSD" type="${type}" flavor="${flavor}">
	<States>
	% for name,equation in list:
     <Equation>${name}::${equation}</Equation>
	% endfor
	</States>
  </Equipment>
</%def>