<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="text" indent="yes" encoding="UTF-8"/>

<xsl:template match="/">
  <xsl:apply-templates select="//ATS"/>
</xsl:template>

<xsl:template match="//ATS">
<xsl:variable name="ats_urba_id" select="Urbalis_Sector_ID"/>
<xsl:value-of select="@ID"/>:<xsl:apply-templates select="//DCS_Equipment[Urbalis_Sector_ID=$ats_urba_id and (DCS_Equipment_Type/text()='NMS IP' or DCS_Equipment_Type/text()='NMS SDH')]"/>
</xsl:template>

<xsl:template match="//DCS_Equipment">
  - {"Addr":"<xsl:value-of select="IP_Management_Address"/>", "Mask":"<xsl:value-of select="Subnet_Mask"/>"}
</xsl:template>

</xsl:stylesheet>
