<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" exclude-result-prefixes="xsl">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
	<xsl:template match="/">
		<ICONIS_KERNEL_PARAMETER_DESCRIPTION xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="SyPD_Kernel.xsd">
			<xsl:copy>
				<xsl:apply-templates select="$kerneldb/*"/>
		   </xsl:copy>
		</ICONIS_KERNEL_PARAMETER_DESCRIPTION>
	</xsl:template>
		
	<xsl:template match="@*">
		<xsl:attribute name="{local-name()}">
			<xsl:value-of select="current()"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:element name="{local-name()}">
			<xsl:apply-templates select="@* | * | text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="text()">
		<xsl:copy>
			<xsl:value-of select="current()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:param name="kerneldb" select="/docs/ICONIS_KERNEL_PARAMETER_DESCRIPTION"/>
</xsl:stylesheet>