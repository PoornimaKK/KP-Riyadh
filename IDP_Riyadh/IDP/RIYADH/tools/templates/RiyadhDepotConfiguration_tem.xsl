<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:template match="/">
		<Root Project="PR_REG_RM3_46" Name="RiyadhDepotConfiguration" xsi:noNamespaceSchemaLocation="RiyadhDepotConfiguration.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<RiyadhDepotConfiguration>
				<DepotStablingEntryTracks>
					<xsl:for-each select="//DepotModules/DepotModule/ApproachStopping_Area_ID_List">
						<xsl:variable name="stoppingareaname"><xsl:value-of select="//Stopping_Area[@ID=current()/Stopping_Areas_ID]/@Name" separator=";"/></xsl:variable>			
						<DepotStablingEntryTrack Track_ID="{$stoppingareaname}"/>
					</xsl:for-each>					
				</DepotStablingEntryTracks>
				<DepotStablingApproachTracks>
					<xsl:for-each select="//DepotModules/DepotModule/TransferTrackStopping_Area_ID_List">
						<xsl:variable name="stoppingareaname"><xsl:value-of select="//Stopping_Area[@ID=current()/Stopping_Areas_ID]/@Name" separator=";"/></xsl:variable>			
						<DepotStabligApproachTrack Track_ID="{$stoppingareaname}"/>
					</xsl:for-each>					
				</DepotStablingApproachTracks>	
					<RiyadhDepotDoorStablingLocationMap>
						<xsl:for-each select="//Depot_Stabling_Doors/Depot_Stabling_Door">
								<xsl:variable name="stoppingareaname"><xsl:value-of select="//Stopping_Area[@ID=//Stabling_Location[@ID=current()/Stabling_Location_ID_List/Stabling_Location_ID]/@ID]/@Name" separator=";"/></xsl:variable>			
								<Depot DepotDoorID="{@Name}" Stabling_LocationID_List="{$stoppingareaname}"/>
						</xsl:for-each>	
					</RiyadhDepotDoorStablingLocationMap>
			</RiyadhDepotConfiguration>
		</Root>		
	</xsl:template>
</xsl:stylesheet>
