<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" exclude-result-prefixes="xsl">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

	<xsl:template match="/">
       <xsl:apply-templates select="$kerneldb"/>
	</xsl:template>
	
	<xsl:template match="TrackPortions">
		<xsl:copy-of select="$kerneldb1/TrackPortions"/>
	</xsl:template>
	
    <xsl:template match="TrackPortions_Connections">
		<xsl:copy-of select="$kerneldb1/TrackPortions_Connections"/>
	</xsl:template>
	
    <!-- copy all attribute or child nodes in place -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>  
        </xsl:copy>
    </xsl:template>
	
	<xsl:param name="kerneldb" select="/docs/ICONIS_KERNEL_PARAMETER_DESCRIPTION"/>
	<xsl:param name="kerneldb1" select="/docs/ICONIS_KERNEL_PARAMETER_DESCRIPTION1"/>
</xsl:stylesheet>