<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP" exclude-result-prefixes="sys xs">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

	<xsl:template match="/">
		<ICONIS_KERNEL_PARAMETER_DESCRIPTION1 xsi:noNamespaceSchemaLocation="SyPD_Kernel.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<TrackPortions>
				<xsl:variable name="riyadhtp" select="//ICONIS_KERNEL_PARAMETER_DESCRIPTION_OTHER/TrackPortions/TrackPortion"/>
				<xsl:apply-templates select="//ICONIS_KERNEL_PARAMETER_DESCRIPTION/TrackPortions/TrackPortion[not(@Name=$riyadhtp/tp)], $riyadhtp"/>
			</TrackPortions>
		</ICONIS_KERNEL_PARAMETER_DESCRIPTION1>
	</xsl:template>

	<xsl:template match="TrackPortion">
		  <TrackPortion ID="{@ID}" Name="{@Name}">
			 <KpBegin><xsl:value-of select="KpBegin"/></KpBegin>
			 <KpEnd><xsl:value-of select="KpEnd"/></KpEnd>
			 <Sector><xsl:value-of select="Sector"/></Sector>
			 <FixedBlockOnly><xsl:value-of select="FixedBlockOnly"/></FixedBlockOnly>
		  </TrackPortion>
	</xsl:template>
</xsl:stylesheet>