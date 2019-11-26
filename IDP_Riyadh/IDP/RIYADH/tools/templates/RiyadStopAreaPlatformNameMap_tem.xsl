<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  
  <xsl:template match="/">
	  <ROOT>
		<Mappings>
			<xsl:for-each select="//Platform">
				<Mapping Stopping_Area="{//Stopping_Area[*/*[@Original_Area_Type='Platform']/@ID=current()/@ID]/@Name}" Platform_Name="{@Name}"/>
			</xsl:for-each>
		</Mappings>
	  </ROOT>
  </xsl:template>
</xsl:stylesheet>
