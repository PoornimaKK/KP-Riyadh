<%inherit file="/Object_tem.mako"/>
<%! class_ = "OPCClient" %>
<%!
LIST=[('Evacuation_Zone_Req','ezr','$sysdb//Evacuation_Zone_Req[sys:sigarea/@id=$SERVER_ID]','EZR_','.Monitoring.Template.iEqpState'),
	 ('Evacuation_Zone_Sec','ezs','$sysdb//Evacuation_Zone_Sec[sys:sigarea/@id=$SERVER_ID]','EZS_','.Secure.Template.iEqpState'),
     ('Evacuation_Zone_Req','pia','$sysdb//Evacuation_Zone_Req[sys:sigarea/@id=$SERVER_ID]','PIA_','.Hold.Point.OutAutomaton'),
     ('Stopping_Area','pia_sr','$sysdb//Stopping_Area[sys:sigarea/@id=$SERVER_ID and Train_Entrance_Prevention_Distance]','PIA_SR_','.StationRestriction.Point.OutAutomaton'),
     ('Train_Unit','rscmd','$sysdb//Train_Unit','RSCMD_','.RSCommand.Others.RSCommand.Template.iCommand'),
	 ('Stopping_Area','pia_sapp',"$sysdb//Stopping_Area[sys:sigarea/@id=$SERVER_ID and Original_Area_List/Original_Area/@Original_Area_Type='Platform']",'PIA_SAPP_','.ISMApproching.Point.OutAutomaton'),

	 ('SPKS','spks',"$sysdb//SPKS[sys:sigarea/@id=$SERVER_ID]",'ATS-ISM.EmergencyDevicesInfo.','.Status.Value')]
 %>
 <xsl:param name="IS_BOTH_LEVEL"/>
<%block name="classes">
	<Class name="S2KIOOPCServerMonitor">
		<Objects>
			<xsl:apply-templates select="if ($IS_BOTH_LEVEL = 'NO') then (//Signalisation_Area[Server_Type = 'Level_1' and contains(Area_Type,'Server') and (sys:sigarea/@id=//Signalisation_Area[@ID=$SERVER_ID]/@ID)]) else (//Signalisation_Area[@ID=$SERVER_ID])" mode="S2KIOOPCServerMonitor"/>
		</Objects>
	</Class>
	<Class name="OPCGroup">
		<Objects>
			<xsl:apply-templates select="//Signalisation_Area[@ID=$SERVER_ID]" mode="OPCGroup"/>
		</Objects>
	</Class>
	<Class name="Variable">
		<Objects>
		 	% for cls, mode, gen, var, opctag in LIST:
				<xsl:apply-templates select="${gen}" mode="${mode}"/>
			% endfor
			${obj_var("WSHAV","RM","WashingMachine.Availability.Template.iEqpState","VT_I4")}
			${obj_var("WSHFC","RM","WashingMachine.FrontWashCompleted.Template.iEqpState","VT_I4")}
			${obj_var("WSHRC","RM","WashingMachine.RearWashCompleted.Template.iEqpState","VT_I4")}
			${obj_var("WSHTC","RM","WashingMachine.TrainWashCompleted.Template.iEqpState","VT_I4")}
			${obj_var("WSHPG","RC","WashingMachine.WashProgram.Template.iCommand","VT_I4")}
			${obj_var("WSH_InterposeRSMCmd","RC","MainKernelBasic.TrainModule.BasicCmd.bstrInterposeCmd","VT_BSTR")}
		</Objects>
	</Class>
</%block>
<xsl:template match="Signalisation_Area" mode="OPCGroup">
	<Object name="Split_{@ID}" rules="update_or_create">
		${prop("OPCClientRef",'OPCClient_ATS_<xsl:value-of select="@ID"/>')}
		${prop("SharedOnIdentifier",'Split_<xsl:value-of select="@ID"/>')}
	</Object>
</xsl:template>

<xsl:template match="Signalisation_Area" mode="S2KIOOPCServerMonitor">
	<xsl:variable name="ats_eqps" select="//ATS_Equipment[Signalisation_Area_ID = $SERVER_ID or Signalisation_Area_ID_List/Signalisation_Area_ID = $SERVER_ID]/@Name"/>
	<Object name="OPCClient_ATS_{@ID}" rules="update_or_create">
		${prop("ConnectAttemptsPeriod","10","i4")}
		${prop("DoubleLinks","0","boolean")}
		${prop("MonitoringPeriod","30","i4")}
		${prop("MultiActive","1","boolean")}
		${prop("ServerNodeName1",'<xsl:value-of select="$ats_eqps[1]"/>')}
		${prop("ServerNodeName2",'<xsl:value-of select="$ats_eqps[2]"/>')}
		${prop("ServerProgID1","S2K.OpcServer.1")}
		${prop("ServerProgID2","S2K.OpcServer.1")}
		${prop("SharedOnIdentifierDefinition","1","boolean")}
		${prop("SharedOnIdentifier",'OPCClient_ATS_<xsl:value-of select="@ID"/>')}
	</Object>
</xsl:template>

% for cls, mode, gen, var, opctag in LIST:
	<xsl:template match="${cls}" mode="${mode}">
		<xsl:variable name="objname" select="if (local-name()='Train_Unit') then concat('${var}','Train',current()/RS_Identifier) else concat('${var}',@Name)"/>
		<Object name="{$objname}" rules="update_or_create">
			<Properties>
				<Property name="Type" dt="string"><xsl:value-of select="if (local-name()!='Train_Unit') then 'RM' else 'RC'"/></Property>
				<Property name="OPCType" dt="string"><xsl:value-of select="if (contains($objname,'EZR_') or contains($objname,'ATS-ISM.EmergencyDevicesInfo.')) then 'VT_I4' else 'VT_BSTR'"/></Property>
				<Property name="OPCGroupID" dt="string">Split_<xsl:value-of select="$SERVER_ID"/></Property>
				<Property name="OPCGroup" dt="string">self</Property>
				<Property name="OPCTag" dt="string"><xsl:value-of select="if (local-name()='Train_Unit') then concat('Train',format-number(@ID,'000'),'${opctag}') else concat(@Name,'${opctag}')"/></Property>
				<Property name="Address" dt="i4"/>
			</Properties>
		</Object>
	</xsl:template>
% endfor
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="prop"/>
<%def name="obj_var(name, type, opctag,dt)" >
	<Object name="${name}" rules="update_or_create">
		<Properties>
			<Property name="Type" dt="string">${type}</Property>
			<Property name="OPCType" dt="string">${dt}</Property>
			<Property name="OPCGroupID" dt="string">Split_<xsl:value-of select="$SERVER_ID"/></Property>
			<Property name="OPCGroup" dt="string">self</Property>
			<Property name="OPCTag" dt="string">${opctag}</Property>
			<Property name="Address" dt="i4"/>
		</Properties>
	</Object>
</%def>