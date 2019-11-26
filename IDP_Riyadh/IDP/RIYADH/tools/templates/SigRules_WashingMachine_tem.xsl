<%inherit file="/SigRules_tem.mako"/>
<%block name="main">
	<xsl:apply-templates select="$sysdb//Generic_ATS_IO[CBI_Signalisation_Area_ID=//Signalisation_Area[sys:cbi/@id=$CBI_ID]/@ID]"/>
	<xsl:apply-templates select="$sysdb//SPKS[sys:cbi/@id=$CBI_ID]"/>
</%block>

<xsl:template match="SPKS">
<xsl:variable name="spksvar" select="concat('SPKS_',@Name)"/>
<xsl:variable name="spkstype" select="current()/Type"/>
<%
	tt="<xsl:value-of select='$spksvar'/>"
%>
	<xsl:if test="$spkstype='Maintainence'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="MAINTAINENCE" AlarmTimeOut="">
			<States>
				<Equation>WSH_LOCAL_MAINTAINENCE_ACTIVATED[0]::${tt}==0</Equation>
				<Equation>WSH_LOCAL_MAINTAINENCE_NOTACTIVATED[1]::${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>
	<xsl:if test="$spkstype='AlarmLv0'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="MAINTAINENCE" AlarmTimeOut="">
			<States>
				<Equation>WSH_ALARM_LEVEL0_ACTIVATED[0]::${tt}==0</Equation>
				<Equation>WSH_ALARM_LEVEL0_NOTACTIVATED[1]::${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>
</xsl:template>

<xsl:template match="Generic_ATS_IO">
<xsl:variable name="washtype" select="current()/Washing_Type[1]"/>
<xsl:variable name="cmdtimeout" select="//System_Constraints_Constant/T_ATS_CBI_Reply_Timeout"/>
<%
	tt="<xsl:value-of select='@Name'/>"
%>
	<xsl:if test="$washtype='Wash_Availability'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="READINESS" >
			<States>
				<Equation>WSH_NOTREADY[0]::GATSM_${tt}==0</Equation>
				<Equation>WSH_READY[1]::GATSM_${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>
	<xsl:if test="$washtype='Wash_In_Progress_Status'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="STATUS" >
			<States>
				<Equation>WSH_NOTINPROGRESS[0]::GATSM_${tt}==0</Equation>
				<Equation>WSH_INPROGRESS[1]::GATSM_${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>
	<xsl:if test="$washtype='Local_Mode_Status'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="LOCALMODE" >
			<States>
				<Equation>WSH_LOCALCONTROL_OFF[0]::GATSM_${tt}==0</Equation>
				<Equation>WSH_LOCALCONTROL_ON[1]::GATSM_${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>
	<xsl:if test="$washtype='Front_Wash_Completed'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="FRONTWASHCOMPLETED" >
			<States>
				<Equation>WSH_FRONT_NOT_COMPLETED[0]::GATSM_${tt}==0</Equation>
				<Equation>WSH_FRONT_COMPLETED[1]::GATSM_${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>	
	<xsl:if test="$washtype='Rear_Wash_Completed'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="REARWASHCOMPLETED" >
			<States>
				<Equation>WSH_REAR_NOT_COMPLETED[0]::GATSM_${tt}==0</Equation>
				<Equation>WSH_REAR_COMPLETED[1]::GATSM_${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>	
	<xsl:if test="$washtype='Train_Wash_Completed'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="TRAINWASHCOMPLETED" >
			<States>
				<Equation>WSH_TRAIN_NOT_COMPLETED[0]::GATSM_${tt}==0</Equation>
				<Equation>WSH_TRAIN_COMPLETED[1]::GATSM_${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>	
	<xsl:if test="$washtype='Wash_Availability'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="AVAILABILITY" >
			<States>
				<Equation>WSH_NOTAVAILABLE[0]::GATSM_${tt}==0</Equation>
				<Equation>WSH_AVAILABLE[1]::GATSM_${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>	
	
	<xsl:if test="$washtype='Alarm_Level1_Status'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="ALARMLV1">
			<States>
				<Equation>WSH_ALARM_LEVEL1_ACTIVATED[0]::${tt}==0</Equation>
				<Equation>WSH_ALARM_LEVEL1_NOTACTIVATED[1]::${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>
	<xsl:if test="$washtype='Intermediate_Wash_Completed'">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="INTERMEDIATEWASHCOMPLETED" >
			<States>
				<Equation>WSH_INTERMEDIATE_NOT_COMPLETED[0]::${tt}==0</Equation>
				<Equation>WSH_INTERMEDIATE_COMPLETED[1]::${tt}==1</Equation>
			</States>
		</Equipment>
	</xsl:if>	
	
	<xsl:if test="contains($washtype,'Command_No_Wash_Program') or contains($washtype,'Command_2C_Full_Wash_Program') or contains($washtype,'Command_Simple_Wash_Program') or contains($washtype,'Command_4C_Full_Wash_Program')">
		<Equipment name="WashingMachine" type="WashingMachine" flavor="WASHPROGRAM" CommandTimeOut="{$cmdtimeout}">
			<Requisites>
				<xsl:if test="$washtype='Command_No_Wash_Program'">
					<Equation>GATSC_${tt}[NO_WASH]::1</Equation>
					<Equation>GATSC_${tt}#0[CANCEL_NO_WASH]::1</Equation>
				</xsl:if>
				<xsl:if test="$washtype='Command_2C_Full_Wash_Program'">
					<Equation>GATSC_${tt}[STOP_AND_GO_WASH]::1</Equation>
					<Equation>GATSC_${tt}#0[CANCEL_STOP_AND_GO_WASH]::1</Equation>
				</xsl:if>
				<xsl:if test="$washtype='Command_Simple_Wash_Program'">
					<Equation>GATSC_${tt}[GO_THROUGH_WASH]::1</Equation>
					<Equation>GATSC_${tt}#0[CANCEL_GO_THROUGH_WASH]::1</Equation>
				</xsl:if>
				<xsl:if test="$washtype='Command_4C_Full_Wash_Program'">
					<Equation>GATSC_${tt}[INTERMEDIATE_WASH]::1</Equation>
					<Equation>GATSC_${tt}#0[CANCEL_INTERMEDIATE_WASH]::1</Equation>
				</xsl:if>
			</Requisites>		
			<CommandResults>
				<xsl:if test="$washtype='Command_No_Wash_Program'">
					<Equation>GATSC_${tt}[NO_WASH]::1</Equation>
					<Equation>GATSC_${tt}#0[CANCEL_NO_WASH]::1</Equation>
				</xsl:if>
				<xsl:if test="$washtype='Command_2C_Full_Wash_Program'">
					<Equation>GATSC_${tt}[STOP_AND_GO_WASH]::1</Equation>
					<Equation>GATSC_${tt}#0[CANCEL_STOP_AND_GO_WASH]::1</Equation>
				</xsl:if>
				<xsl:if test="$washtype='Command_Simple_Wash_Program'">
					<Equation>GATSC_${tt}[GO_THROUGH_WASH]::1</Equation>
					<Equation>GATSC_${tt}#0[CANCEL_GO_THROUGH_WASH]::1</Equation>
				</xsl:if>
				<xsl:if test="$washtype='Command_4C_Full_Wash_Program'">
					<Equation>GATSC_${tt}[INTERMEDIATE_WASH]::1</Equation>
					<Equation>GATSC_${tt}#0[CANCEL_INTERMEDIATE_WASH]::1</Equation>
				</xsl:if>
			</CommandResults>			
		</Equipment>
	</xsl:if>	
</xsl:template>

