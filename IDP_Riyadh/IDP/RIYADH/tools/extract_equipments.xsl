<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="text" indent="yes"/>

  <xsl:template match="/"># This script create the equipments list
# CBI: 
#	- {ID: @ID, NAME: @Name}
# ZC: 
#	- {ID: @ID, NAME: @Name}
# SERVER: 
#	- {ID: @ID, NAME: @Name, AREA_TYPE: Area_Type, LEVEL: if(Server_Type = Level_1) then [_LV1] else if (Server_Type=Level_2) then [_LV2] else if (Server_Type=Both_Levels) then [_LV1, _LV2] else NA}
# ATS_Equipment:
#     - {ID: @ID, NAME: @Name, ATS_Equipment_type: ATS_Equipment_Type}

CBI: <xsl:apply-templates select="//CBI"/>
ZC: <xsl:apply-templates select="//ZC"/>
SERVER: <xsl:apply-templates select="//Signalisation_Area[(contains(Area_Type, 'Server')) and (Server_Type='Level_1' or Server_Type='Level_2' or Server_Type='NA' or Server_Type='Both_Levels')]"/>
ATS_EQUIPMENTS: <xsl:apply-templates select="//ATS_Equipment"/>
Project:<xsl:apply-templates select="//Project"/>
  </xsl:template>
  
   <xsl:template match="CBI|ZC">  
- {ID: <xsl:value-of select="@ID"/>, NAME: <xsl:value-of select="@Name"/>}
  </xsl:template>
  
   <xsl:template match="Signalisation_Area">  
- {ID: <xsl:value-of select="@ID"/>, NAME: <xsl:value-of  select="@Name"/>, AREA_TYPE: <xsl:value-of  select="Area_Type"/>, LEVEL: [<xsl:value-of select="if(Server_Type = 'Level_1') then '_LV1' else if (Server_Type = 'Level_2') then '_LV2' else if (Server_Type = 'Both_Levels') then '_LV1, _LV2' else 'NA'"/>]}
  </xsl:template>
  
    <xsl:template match="ATS_Equipment">
  - {ID: <xsl:value-of select="@ID"/>, NAME: <xsl:value-of select="@Name"/>, ATS_EQUIP_TYPE: <xsl:value-of select="ATS_Equipment_Type/text()"/>}</xsl:template>
  <xsl:template match="Project">
    Name: <xsl:value-of select="@Name"/></xsl:template>
</xsl:stylesheet>
