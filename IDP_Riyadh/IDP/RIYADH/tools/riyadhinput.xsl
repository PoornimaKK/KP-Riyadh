<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" >
<xsl:import href="../../lib_common/merge.xsl"/>
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:template match="/">
<xsl:comment>The input documents are merged into one. The purpose is to be able to quickly access to all the child of a node in only one file
</xsl:comment>
<xsl:variable name="sectorid" select="/docs/ATS_SYSTEM_PARAMETERS/@Sector_ID"/>
<xsl:variable name="writername" select="/docs/ATS_SYSTEM_PARAMETERS/@Writer_Name"/>
<xsl:variable name="sypdversion" select="/docs/ATS_SYSTEM_PARAMETERS/@SyPD_Version"/>
<xsl:variable name="xmlversion" select="/docs/ATS_SYSTEM_PARAMETERS/@XML_File_Version"/>
<xsl:variable name="comment" select="/docs/ATS_SYSTEM_PARAMETERS/@Comment"/>
<xsl:variable name="date" select="/docs/ATS_SYSTEM_PARAMETERS/@Date"/>
<ATS_SYSTEM_PARAMETERS  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP" Sector_ID="{$sectorid}" Writer_Name="{$writername}" SyPD_Version="{$sypdversion}" XML_File_Version="{$xmlversion}" Comment="{$comment}" Date="{$date}">
    <!-- we apply the templates on all "table" of the document : this is the node of level 2 in each document. -->
	<xsl:apply-imports/>
</ATS_SYSTEM_PARAMETERS>
  </xsl:template>
</xsl:stylesheet>
