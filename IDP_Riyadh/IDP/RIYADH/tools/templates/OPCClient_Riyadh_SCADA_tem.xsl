<%inherit file="/Object_tem.mako"/>
<%! 
	class_ = "S2KOPCUAClient.IOClient"
	add_alias_function = True
%>
<xsl:variable name="objs">
	<Objects>
		<Object Variable_Name="PSDIS" Check_Platform_docking="Yes" RM_RC="RM" Type="VT_BSTR" OPCTag="ATS-SCADA.PlatformInfo.OBJ_NAME.PlatformPSDIsolationStatus" Check_Class="Urbalis_Sector" Parameter_On_Child_Node="Urbalis_Sector_Option" Parameter="PSD_Presence" Parameter_Value="true"/>
		<Object Variable_Name="RSCMD" Check_Platform_docking="Yes" RM_RC="RC" Type="VT_BSTR" OPCTag="ATS-SCADA.PlatformInfo.OBJ_NAME.PlatformPSDInhibitionStatus" Check_Class="Urbalis_Sector" Parameter_On_Child_Node="Urbalis_Sector_Option" Parameter="PSD_Presence" Parameter_Value="true"/>
	</Objects>
</xsl:variable>

<xsl:variable name="objsdepot">
	<Objects>
		<Object Variable_Name=".CloseFbk"  RM_RC="RM" Type="VT_I4" OPCTag="SCADA-ATS.DepotStablingDoors"/>
		<Object Variable_Name=".LocalRemote"  RM_RC="RM" Type="VT_I4" OPCTag="SCADA-ATS.DepotStablingDoors"/>
		<Object Variable_Name=".OpenFbk"  RM_RC="RM" Type="VT_I4" OPCTag=""/>
	</Objects>
</xsl:variable>

<%block name="classes">
	<Class name="S2KOPCUAClient.IOClient">
		<Objects>
			<Object name="PSDOPCClient_SCADA" rules="update_or_create">
			<Properties>
				<Property name="ConnectAttemptsPeriod" dt="i4">10</Property>
				<Property name="Server1Url" dt="string">opc.tcp://CER_SRV_EM_A:9680</Property>
				<Property name="Server2Url" dt="string">opc.tcp://CER_SRV_EM_B:9680</Property>
				<Property name="DuplicateControls" dt="boolean">1</Property>
				<Property name="SharedOnIdentifierDefinition" dt="boolean">1</Property>
				<Property name="SharedOnIdentifier" dt="string">PSDOPCClient_SCADA</Property>
			</Properties>
			</Object>
		</Objects>
	</Class>
	<Class name="OPCGroup">
		<Objects>
			<Object name="SCADA_Client" rules="update_or_create">
				<Properties>
					<Property name="OPCUAInterface" dt="boolean">1</Property>
					<Property name="OPCClientRef" dt="string">PSDOPCClient_SCADA</Property>
					<Property name="SharedOnIdentifier" dt="string">SCADA_Client</Property>
					<Property name="SharedOnIdentifierDefinition" dt="boolean">1</Property>
				</Properties>
			</Object>
		</Objects>
	</Class>
	<Class name="Variable">
		<Objects>
			<xsl:apply-templates select="//Platform"/>
			<xsl:apply-templates select="//Depot_Stabling_Door"/>
		</Objects>
	</Class>
	<Class name="SCADAEmergencyDevices">
		<Objects>
			<xsl:apply-templates select="//SPKS"/>
		</Objects>
	</Class>	
</%block>

<xsl:template match="Platform">
	<xsl:variable name="pf" select="."/>
	<xsl:variable name="objnm_raw" select="@Name"/>
	<xsl:for-each select="$objs/Objects/Object">
		<xsl:variable name="objname" select="concat(@Variable_Name,'_',$objnm_raw)"/>
		<xsl:variable name="opctag_raw" select="replace(@OPCTag,'OBJ_NAME',$objnm_raw)"/>
		<xsl:variable name="opctag_last" select="tokenize($opctag_raw,'\.')[last()]"/>
		<xsl:variable name="opctag_int" select="concat('[2:http://www.alstom.com/Transport/Icons/S2K/Data]&lt;Organizes&gt;2:',replace(substring-before($opctag_raw,concat('.',$opctag_last)),'\.','&lt;Organizes&gt;2:'))"/>
		<xsl:variable name="opctag_final" select="concat($opctag_int,'&lt;HasComponent&gt;2:',$opctag_last)"/>
		
		<!-- Checks to be made as per the given options -->
		<xsl:variable name="chk_cls" select="@Check_Class"/>
		<xsl:variable name="child_node" select="@Parameter_On_Child_Node"/>
		<xsl:variable name="param" select="@Parameter"/>
		<xsl:variable name="value" select="@Parameter_Value"/>
		<xsl:variable name="chk_pf_dock" select="@Check_Platform_docking"/>
		<xsl:variable name="check_id" select="$sysdb//Urbalis_Sector[Track_ID_List/Track_ID=$pf/Track_ID]/@ID"/>
		<xsl:variable name="check_int" select="if ($sysdb/descendant-or-self::*[name()=$chk_cls and @ID=$check_id]/descendant-or-self::*[name()=$child_node and @*[name()=$param]=$value]) then true() else false()"/>
		
		<!-- Final Checks -->
		<xsl:variable name="check_1" select="if ($chk_cls='None') then true() else $check_int"/>
		<xsl:variable name="check_2" select="if ($chk_pf_dock='No') then true() else ($pf/Platform_Type='Single Right Docking' or $pf/Platform_Type='Single Left Docking')"/>
		<xsl:if test="$check_1 and $check_2">
			<!-- Commented as the document is not yet updated -->
			##${opcgrp_object('{$objname}','<xsl:value-of select="@RM_RC"/>','<xsl:value-of select="@Type"/>','SCADA_Client','MyGroup','<xsl:value-of select="$opctag_final"/>')}
			
			<!-- Generating as per the SyAD Config -->
			<Object name="{$objname}" rules="update_or_create">
				<Properties>
					<Property name="OPCGroupRef" dt="string">SCADA_Client</Property>
					<Property name="OPCTag" dt="string"><xsl:value-of select="$opctag_final"/></Property>
					<Property name="SharedOnIdentifier" dt="string"><xsl:value-of select="$objname"/></Property>
					<Property name="SharedOnIdentifierDefinition" dt="boolean">1</Property>
				</Properties>
			</Object>
			
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template match="Depot_Stabling_Door">
	<xsl:variable name="objnm_raw" select="@Name"/>
<xsl:for-each select="$objsdepot/Objects/Object">
		<xsl:variable name="objname" select="concat(@OPCTag,$objnm_raw,@Variable_Name)"/>
		<xsl:variable name="opctag_raw" select="replace(@OPCTag,'OBJ_NAME',$objnm_raw)"/>
		<xsl:variable name="opctag_last" select="tokenize($opctag_raw,'\.')[last()]"/>
		<xsl:variable name="opctag_int" select="concat('[2:http://www.alstom.com/Transport/Icons/S2K/Data]&lt;Organizes&gt;2:',replace(substring-before($opctag_raw,concat('.',$opctag_last)),'\.','&lt;Organizes&gt;2:'))"/>
		<xsl:variable name="opctag_final" select="concat($opctag_int,'&lt;HasComponent&gt;2:',$opctag_last)"/>
		
	<Object name="{$objname}" rules="update_or_create">
		<Properties>
			<Property name="OPCGroupRef" dt="string">SCADA_Client</Property>
			<Property name="OPCTag" dt="string"><xsl:value-of select="$opctag_final"/></Property>
			<Property name="SharedOnIdentifier" dt="string"><xsl:value-of select="$objname"/></Property>
			<Property name="SharedOnIdentifierDefinition" dt="boolean">1</Property>
		</Properties>
	</Object>
</xsl:for-each>	
</xsl:template>	

<xsl:template match="SPKS">
<xsl:variable name="objName" select="concat('ATS-SCADA.EmergencyDevicesInfo.',@Name)"/>
	<Object name="{$objName}" rules="update_or_create">
		<Properties>
			<Property name="EmergencyDevice" dt="string"><xsl:value-of select="concat('ATS-ISM.EmergencyDevicesInfo.',@Name)"/></Property>
		</Properties>
	</Object>
</xsl:template>	

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>
<%def name="opcgrp_object(objName,type,opcType,opcGrpID,opcGrp,opcTag,address='0')">
	<Object name="${objName}" rules="update_or_create">
		<Properties>
			<Property name="Type" dt="string">${type}</Property>
			<Property name="OPCType" dt="string">${opcType}</Property>
			<Property name="OPCGroupID" dt="string">${opcGrpID}</Property>
			<Property name="OPCGroup" dt="string">${opcGrp}</Property>
			<Property name="OPCTag" dt="string">${opcTag}</Property>
			<Property name="Address" dt="i4">${address}</Property>
		</Properties>
	</Object>
</%def>