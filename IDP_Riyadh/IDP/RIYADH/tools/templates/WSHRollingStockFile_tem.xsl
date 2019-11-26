<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP" exclude-result-prefixes="sys">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<xsl:template match="/">
<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="WSHRollingStockFile" Project="{//Project/@Name}" xsi:noNamespaceSchemaLocation="WSH_RollingStockFile.xsd">
	<RollingStocks>
		<xsl:apply-templates select="//Train_Unit">
			<xsl:sort data-type="number" select="@ID" order="ascending"/>
		</xsl:apply-templates>
	</RollingStocks>
</Root>
</xsl:template>

<!-- Template to call all Train's -->
<xsl:template match="Train_Unit">
	<RollingStock RollingStockID="{@ID}"/>
</xsl:template>
</xsl:stylesheet>