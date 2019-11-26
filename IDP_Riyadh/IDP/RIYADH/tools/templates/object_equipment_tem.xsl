<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<%
ATS_SYSDB_PATH = "/docs/ATS_SYSTEM_PARAMETERS"
OBJS_EQT = "/docs/OBJS_EQT"
%>

   <xsl:template match="docs">
        <OBJS_EQT>
            <xsl:copy-of select="${OBJS_EQT}/*"/>
            <xsl:apply-templates select="${ATS_SYSDB_PATH}/*" mode="table"/>
        </OBJS_EQT>
   </xsl:template>
   
   <xsl:template match="Switchs|Switch_Local_Control_Keys|Cycles" mode="table">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
   </xsl:template>
   
   <xsl:template match="*" mode="table"/>

   <xsl:template match="Switch">
       <xsl:copy>
           <xsl:variable name="sid" select="@ID"/>
           <xsl:attribute name="ID"><xsl:value-of select="$sid"/></xsl:attribute>      
            <sys:CBI_ID_LIST>
                <xsl:apply-templates select="." mode="el"/>
            </sys:CBI_ID_LIST>
       </xsl:copy>
   </xsl:template>

   <xsl:template match="Switch_Local_Control_Key">
        <xsl:variable name="sid" select="@ID"/>
        <xsl:copy>
	         <xsl:attribute name="ID"><xsl:value-of select="$sid"/></xsl:attribute>
	         <sys:CBI_ID_LIST>
	             <xsl:apply-templates select="Switch_ID_List/Switch_ID" mode="el"/>
	         </sys:CBI_ID_LIST>
        </xsl:copy>
   </xsl:template>

   <xsl:template match="Cycle">
        <xsl:variable name="cid" select="@ID"/>
        <xsl:copy>
            <xsl:attribute name="ID"><xsl:value-of select="$cid"/></xsl:attribute>
            <sys:CBI_ID_LIST>
                <xsl:apply-templates select="Route_Sequence_List/Route_ID" mode="el"/>
            </sys:CBI_ID_LIST>
        </xsl:copy>
   </xsl:template>

   <xsl:template match="Switch" mode="el">
        <xsl:apply-templates select=".//Convergent_Point_ID" mode="el"/>
        <xsl:apply-templates select=".//Divergent_Point_ID" mode="el"/>
   </xsl:template>

   <xsl:template match="Convergent_Point_ID|Divergent_Point_ID" mode="el">
       <xsl:variable name="id" select="./text()"/>
       <xsl:apply-templates select="//Point[@ID=$id]" mode="el"/>
   </xsl:template>

   <xsl:template match="Switch_ID" mode="el">
       <xsl:variable name="id" select="./text()"/>
       <xsl:apply-templates select="//Switch[@ID=$id]" mode="el"/>
   </xsl:template>
   
   <xsl:template match="Route_ID" mode="el">
       <xsl:variable name="id" select="./text()"/>
       <xsl:apply-templates select="//Route[@ID=$id]" mode="el"/>
   </xsl:template>

   <xsl:template match="Point" mode="el">
       <xsl:variable name="id" select="@ID"/>
       <xsl:copy-of select="${OBJS_EQT}//Point[@ID=$id]//sys:CBI_ID"/>
   </xsl:template>

   <xsl:template match="Route" mode="el">
       <xsl:variable name="id" select="@ID"/>
       <xsl:copy-of select="${OBJS_EQT}//Route[@ID=$id]//sys:CBI_ID"/>
   </xsl:template>
</xsl:stylesheet>
