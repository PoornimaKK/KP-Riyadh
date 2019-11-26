<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sys="http://www.systerel.fr/Alstom/IDP" version="2.0" exclude-result-prefixes="sys">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<!-- Get the server_level and date from command line -->
<xsl:param name="SERVER_LEVEL"/>
<xsl:param name="SERVER_ID"/>
<xsl:param name="DATE"/>
<xsl:template match="/">
<VALUES name="ParametersRIM46" version="1.0.0" Project="{//Project/@Name}" Generation_Date="{$DATE}"  xsi:noNamespaceSchemaLocation="ParametersRiyadh.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 	<xsl:variable name="btvvalue" select="if($SERVER_LEVEL ='_LV1') then 'TF_CCHold;Direction;TFDirection;CCStatusReport;TF_CCItfver;TF_CCNTPTimeDesynchronized;LocalizedID;HeadTrainLocation;FrontTPID;TFCharacteristic;RollingStockID;TEST_MODE_STATUS;RSTalkative;CCPEEDNT;TF_TrainOperatingMode;MaintainTrainDoorsClosed;RSTrainDoorIsolationOnSideA;RSTrainDoorIsolationOnSideB;TrainUnitCharacteristicID;TUList;CCExtremity1Ahead;TrainOperatingMode;TOMChangeReport;TF_CCRealStopAreaState;CCMovement1StopAreaID;CCCouplingStatus;DD_CIOS121;DD_CIOS122;DD_CIOS123;DD_CIOS124;DD_CIOS125;DD_CIOS126;DD_CIOS090;CCRealStopAreaID;' else if($SERVER_LEVEL ='_LV2') then 'CCSettingRequest;TripID;TrainCode;OriginCode;DestinationCode;Delay;bTrainHeld;Associated;TripNumber;ReachableStopPointsWithManeuvers;HoldSkipList;TM1StopAreaName;TF_TrainOperatingMode;TOMChangeRequest;TF_CCHold;CCServiceID;CCTripID;CCFinalDestinationNumber;CCCrewID;CCDriverNumber;ServiceID;bDelay;bAdvance;TrainOutOfRegulation;AlarmActivityLV2;LastStopPoint;OverallTrainDoorInhibitionOnSideA;OverallTrainDoorInhibitionOnSideB;SituationType' else null"/>
	${params([('bstrTrainEventList','{$btvvalue}' ,'TrainEventDescriber')])}
	<xsl:if test="$SERVER_LEVEL = '_LV2'">
	<xsl:variable name="wshReqTimeOut" select="number(//Train_Washing/Washing_Request_TimeOut[1])"/>
	<xsl:variable name="WashingRequestTimeout" select="if(not($wshReqTimeOut))then '' else if($wshReqTimeOut=-1) then (-1) else number($wshReqTimeOut * 60)"/>
	<xsl:variable name="WashPlantExitPoint" select="//Stopping_Area[@ID=//Train_Washing/Wash_Destination_Stopping_Area_ID[1]]/@Name"/>
	<xsl:variable name="FrontWashPoint" select="//Stopping_Area[@ID=//Train_Washing/Front_Wash_Stopping_Area_ID]/@Name"/>
	<xsl:variable name="RearWashPoint" select="//Stopping_Area[@ID=//Train_Washing/Rear_Wash_Stopping_Area_ID]/@Name"/>
	<xsl:variable name="NoWashPoint" select="//Stopping_Area[@ID=//Train_Washing/No_Wash_Destination_Stopping_Area_ID]/@Name"/>
	<xsl:variable name="wptt"><xsl:value-of select ="for $i in distinct-values(//Stopping_Area[sys:sigarea/@id=$SERVER_ID  and @ID=//Train_Washing/Transfer_Track_ID_List/Transfer_Track_ID]/@Name) return $i" separator=";"/></xsl:variable>
	${params([("MaxPredictedDisplayedForTPMPoint", "4", "RegulationPoint"),
				("PredictedParameters", "0x8110", "TPMPoint"),
				("PlatformNameFile", "RiyadStopAreaPlatformNameMap.xml","OPCMMgr"),
				("WashingRequestTimeout","{$WashingRequestTimeout}","WSHMgr"),
				("WashPlantTransferTracks","{normalize-space($wptt)}","WSHMgr"),
				("WashPlantExitPoint","{$WashPlantExitPoint}","WSHMgr"),
				("FrontWashPoint","{$FrontWashPoint}","WSHMgr"),
				("RearWashPoint","{$RearWashPoint}","WSHMgr"),
				("NoWashPoint","{$NoWashPoint}","WSHMgr"),
				("RollingStockFile","WSHRollingStockFile.xml","WSHMgr"),
				("ServiceOriented","False","RulesMgr"),
				("ServiceOriented","False","TTRMgr"),
				("DepotConfigurationFile","RiyadhDepotConfiguration.xml","DepotMgr")
				])}
	</xsl:if>
	<xsl:if test="$SERVER_LEVEL = '_LV1'">
	${params([("DataConversion","ASCII","CCMManager"),
				("DataConversion","ASCII","TrainArea"),
				("DataConversion","ASCII","RSMU400Manager"),
				("DataConversion","ASCII","APDecoder"),
				("DataConversion","ASCII","ZCClient"),
				("TransitionFile","TrainOperatingMode.xml","TrainAttributeMgmt"),
				("SDOperationalStatusAlarmLabel","Secondary train detection device detected out of operation","TrackSection"),
				("StatusAlarmLabel","Staff protection Key switch activated","SPKS")])}
	</xsl:if>
</VALUES>
</xsl:template>
</xsl:stylesheet>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->

## Mako template used for generating <Params/> elements with values passed as list.
<%def name="params(list)" >
% for name,value,dt in list:
	<Param name="${name}" value="${value}" class="${dt}"/>
% endfor
</%def>
