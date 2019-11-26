<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP" exclude-result-prefixes="sys xs">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

	<xsl:template match="/">
		<ICONIS_KERNEL_PARAMETER_DESCRIPTION1 xsi:noNamespaceSchemaLocation="SyPD_Kernel.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sys="http://www.systerel.fr/Alstom/IDP">
			<TrackPortions_Connections>
				<xsl:variable name="tpriyadh" select="//ICONIS_KERNEL_PARAMETER_DESCRIPTION_OTHER/TrackPortions/TrackPortion"/>
				<xsl:copy-of select="//TrackPortions_Connections/TrackPortions_Connection[not(Left_Normal_TP = $tpriyadh[tpOrder]/@ID)]" copy-namespaces="no"/>
				<xsl:apply-templates select="//TrackPortions_Connections/TrackPortions_Connection[Left_Normal_TP = $tpriyadh[tpOrder='1']/@ID]"/>
				<xsl:apply-templates select="$tpriyadh[tpOrder='1']"/>				
			</TrackPortions_Connections>
		</ICONIS_KERNEL_PARAMETER_DESCRIPTION1>
	</xsl:template>
	<xsl:template match="TrackPortion">
	  <xsl:variable name="othertp" select="//ICONIS_KERNEL_PARAMETER_DESCRIPTION_OTHER/TrackPortions/TrackPortion[tp=current()/tp and tpOrder='2']"/>
	  <xsl:variable name="tp1" select="replace(@Name, '.TrackPortion', '')"/>
	  <xsl:variable name="tp2" select="replace($othertp/@Name, '.TrackPortion', '')"/>
	  <xsl:variable name="tpcmaxid" select="max(//TrackPortions_Connection/@ID)"/>
	  <TrackPortions_Connection ID="{$tpcmaxid + position()}" Name="{concat('J_',$tp1,'_',$tp2,'.TrackPortionConnection')}">
         <StateElement/>
         <Left_Normal_TP><xsl:value-of select="@ID"/></Left_Normal_TP>
         <Right_Normal_TP><xsl:value-of select="$othertp/@ID"/></Right_Normal_TP>
      </TrackPortions_Connection>
	</xsl:template>
	<xsl:template match="TrackPortions_Connection">
	  <xsl:variable name="tp" select="//ICONIS_KERNEL_PARAMETER_DESCRIPTION_OTHER/TrackPortions/TrackPortion[@ID=current()/Left_Normal_TP and tpOrder]"/>
	  <xsl:variable name="secondTP" select="//ICONIS_KERNEL_PARAMETER_DESCRIPTION_OTHER/TrackPortions/TrackPortion[tp=$tp/tp and tpOrder='2']"/>
	  <TrackPortions_Connection ID="{@ID}" Name="{@Name}">
         <StateElement><xsl:value-of select="StateElement"/></StateElement>
         <Left_Normal_TP><xsl:value-of select="$secondTP/@ID"/></Left_Normal_TP>
         <Right_Normal_TP><xsl:value-of select="Right_Normal_TP"/></Right_Normal_TP>
      </TrackPortions_Connection>
	</xsl:template>
	
</xsl:stylesheet>