<%inherit file="/Object_tem.mako"/>
<%! 
class_ = "HMIStringInformation"
name="HMIStringInformation"
add_alias_function = True
xs_ = True
%>
<%block name="classes">
  ## Variable CLASSES Contains pattern,mode,lv1_tag for creating Object's IconisHMI.* , groupinhibitionlist&TrainsList used in template for creating GroupInhibitionList
  <%CLASSES = [("TrackSectionsList","TrackSections","//Secondary_Detection_Devices/Secondary_Detection_Device[@ID = (//Block[@ID = //Signalisation_Area[@ID = $SERVER_ID]/Block_ID_List/Block_ID]/Secondary_Detection_Device_ID)]"),
							  ("FixedBlocksList","FixedBlocks","//Blocks/Block[sys:sigarea/@id = $SERVER_ID]"),
							  ("TrackPortionsList","TrackPortionsList","//Blocks/Block[@ID = (//Signalisation_Area[@ID = $SERVER_ID]/Block_ID_List/Block_ID)]"),
							  ("ESAList","ESAs","//Emergency_Stop_Areas/Emergency_Stop_Area[(some $item in Block_ID_List/Block_ID satisfies ($item = (//Signalisation_Area[@ID = $SERVER_ID]/Block_ID_List/Block_ID)))]"),
							  ("PointEndsList","PointEnds","//Points/Point[@ID = (//Block[@ID = //Signalisation_Area[@ID = $SERVER_ID]/Block_ID_List/Block_ID]/Point_ID)]"),("SignalsList","Signals","//Signal"),("CyclesList","Cycles","//Cycle"),
							  ("SubRoutesList","SubRoutes","//Sub_Routes/Sub_Route[Block_ID=(//Signalisation_Area[@ID = $SERVER_ID]/Block_ID_List/Block_ID) and Manually_Releasable = 'true']"),("RoutesList","Routes","//Route"),("SPKSList","SPKSs","//SPKS[Block_ID = (//Signalisation_Area[@ID = $SERVER_ID]/Block_ID_List/Block_ID)]"),("GAMAsList","GAMAs","//GAMA_Zone"),
							  ("ZCsList","ZCs","//ZCs/ZC[@ID = //Signalisation_Area[@ID = $SERVER_ID]/sys:zc/@id]"),("LCsList","LCs","//ATC_Equipments/ATC_Equipment[ATC_Equipment_Type = 'LC' and @ID = (//Signalisation_Area[@ID = $SERVER_ID]/sys:lc/@id)]"),
							  ("FEPsList","FEPs","//ATSs/ATS[@ID = //Signalisation_Area[@ID = $SERVER_ID]/sys:ats/@id]"),("SwitchPointEndsList","PointEnds","//Switchs/Switch[sys:sigarea/@id = $SERVER_ID]"),("CBIsList","CBIs","//CBIs/CBI[@ID = //Signalisation_Area[@ID = $SERVER_ID]//sys:cbi/@id]"),
							  ("PlatformsList","Platforms","//Stopping_Areas/Stopping_Area[sys:sigarea/@id = $SERVER_ID]"),("CalculatedWorkZoneBoundaryList","WorkZoneBoundarys","//Calculated_Work_Zone_Boundary[Type='Secondary Detection Device Boundary' or Type='Point Normal' or Type='Point Reverse']"),
							  ("EZRList","EZRs","//Evacuation_Zones_Req/Evacuation_Zone_Req[sys:sigarea/@id = $SERVER_ID]"),("EZSList","EZSs","//Evacuation_Zones_Sec/Evacuation_Zone_Sec[sys:sigarea/@id = $SERVER_ID]"),("SpeedList","Speeds","//Reduction_Speeds/Reduction_Speed"),
							  ("SDDGroupList","SDDGroups","//SDD_Groups_In_Operation/SDD_Group_In_Operation[sys:sigarea/@id = $SERVER_ID]")]%>
  <xsl:variable name="cnt_list"><xsl:value-of select="for $item in //Kilometric_Counter_Detector/Type return concat('PBH_',$item,';PBH_TotalDistance;PBH_WithoutPassengersDistance;PBH_WithPassengersDistance;')"/></xsl:variable>
  <xsl:variable name="cnt_name_list"><xsl:value-of select="for $item in //Kilometric_Counter_Detector/@Name return concat('PBH_',$item,';Km_TotalDistance;Km_WithoutPassengersDistance;Km_WithPassengersDistance')"/></xsl:variable>
  <Class name="HMIStringInformation">
		<Objects>
		<!-- Generation of elements <Object/>-->
		%	for mode,lv1_tag,pattern in CLASSES:
				<xsl:if test="$SERVER_LEVEL = '_LV1' and ${pattern} ">
					<Object name="IconisHMI.${mode}" rules="update_or_create">
						<Properties>
							<xsl:variable name="multilingual">&lt;${lv1_tag}&gt;<xsl:apply-templates select="${pattern}" mode="${mode}">
							%if mode=="FixedBlocksList" or mode=="TrackPortionsList" or mode=="GAMAsList":
							<xsl:sort select="number(@ID)"/>
							%elif mode=="EZRList" or mode=="EZSList":
							<xsl:sort select="sys:alias_name(.)"/>
							%elif mode=="SpeedList":
							<xsl:sort select="number(Speed_Value)"/>
							%else:
							<xsl:sort select="@Name"/>
							%endif
							</xsl:apply-templates>&lt;/${lv1_tag}&gt;</xsl:variable>
							${multilingualvalue('$multilingual','Information')}
						</Properties>
					 </Object>
				</xsl:if>
		%	endfor
			<xsl:if test="$SERVER_LEVEL = '_LV1'">
				<Object name="IconisHMI.TrainsList" rules="update_or_create">
					 <Properties>
						 <xsl:variable name="multilingual">&lt;Trains NbCounter=&quot;<xsl:value-of select="count(//Kilometric_Counter_Detector) + 3"/>&quot; CounterList=&quot;<xsl:value-of select="replace($cnt_list,' ',';')"/>&quot; CounterNameList=&quot;<xsl:value-of select="replace($cnt_name_list,' ',';')"/>&quot;&gt;<xsl:apply-templates select="//Trains_Unit/Train_Unit" mode="TrainsList"><xsl:sort select="number(@ID)"/></xsl:apply-templates>&lt;/Trains&gt; </xsl:variable>
						 ${multilingualvalue('$multilingual','Information')}
					 </Properties>
				 </Object>
				<Object name="IconisHMI.GroupInhibitionList" rules="update_or_create">
					 <Properties>
						<xsl:variable name="multilingual">&lt;GroupInhibitions RootName=&quot;Root&quot;&gt;<xsl:apply-templates select="/" mode="GroupInhibitionList"/>&lt;/GroupInhibitions&gt;</xsl:variable>
						${multilingualvalue('$multilingual','Information')} 
					 </Properties>
				 </Object>
			 </xsl:if>
		</Objects>
	 </Class>
</%block>
<!-- Frequent keys-->
<xsl:key name="block_list" match="Signalisation_Area/Block_ID_List/Block_ID" use="ancestor::*/@ID"/>
<xsl:key name="block_id" match="Block" use="@ID"/>
<xsl:key name="block_sdd" match="Block" use="Secondary_Detection_Device_ID"/>
<xsl:key name="point_id" match="Point" use="@ID"/>
<xsl:key name="platform_id" match="Platform" use="@ID"/>
<xsl:key name="egama" match="Elementary_GAMA" use="@ID"/>
<!-- Template for TrackSectionsList-->
<xsl:template match="Secondary_Detection_Device" mode="TrackSectionsList">
	&lt;TrackSection Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; ID=&quot;<xsl:value-of select="@Name"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="key('block_sdd',@ID)[1]/sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="key('block_sdd',@ID)[1]/sys:lc/@id"/>&quot; ZC=&quot;ZCS_<xsl:value-of select="key('block_sdd',@ID)[1]/sys:zc/@id"/>&quot; Area=&quot;<xsl:value-of select="key('block_sdd',@ID)[1]/sys:geo/@name"/>&quot;/&gt;</xsl:template>

<!-- Template for FixedBlocksList-->
<xsl:template match="Block" mode="FixedBlocksList">
	<xsl:variable name="blockID" select="@ID"/>
	<xsl:variable name="trackID" select="Track_ID"/>
	&lt;FixedBlock Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; ID=&quot;<xsl:value-of select="@Name"/>&quot; KPBegin=&quot;<xsl:value-of select="Kp_Begin"/>&quot; KPEnd=&quot;<xsl:value-of select="Kp_End"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="sys:lc/@id"/>&quot; <xsl:value-of select="if(sys:zc/@id) then concat('ZC=&quot;','ZCS_', sys:zc/@id, '&quot;') else ''"/> Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot;&gt;&lt;ElementaryGamaList&gt;<xsl:apply-templates select="//Elementary_GAMA[Block_ID_List/Block_ID = $blockID]"><xsl:sort select="sys:alias_name(.)"/></xsl:apply-templates>&lt;/ElementaryGamaList&gt;&lt;ElementaryESAList&gt;<xsl:apply-templates select="//Emergency_Stop_Area[Block_ID_List/Block_ID = $blockID]"><xsl:sort select="@Name"/></xsl:apply-templates>&lt;/ElementaryESAList&gt;&lt;/FixedBlock&gt;</xsl:template>

<!-- Template for TrackPortionsList-->
<xsl:template match="Block" mode="TrackPortionsList">
	<xsl:variable name="sddID" select="Secondary_Detection_Device_ID"/>
	<xsl:variable name="values" select="concat(sys:cbi/@id,' ',sys:lc/@id,' ',sys:geo/@name,' ',sys:zc/@id)"/>
	<xsl:variable name="sdd" select="//Secondary_Detection_Devices/Secondary_Detection_Device[@ID = $sddID]"/>
	<xsl:variable name="TI_ID" select="//TI_Distributions/TI_Distribution[Secondary_Detection_Device_ID_List/Secondary_Detection_Device_ID = $sddID]/@ID"/>
	<xsl:variable name="SubDivisionStep" select="if(//TI_Distributions/TI_Distribution[@ID = $TI_ID]/Subdivision_Step != '') then (//TI_Distributions/TI_Distribution[@ID = $TI_ID]/Subdivision_Step * 100) else -1"/>
	<xsl:variable name="Block_Len" select="abs(Kp_Begin - Kp_End)"/>
	<xsl:variable name="TP_Name"><xsl:value-of select="if($SubDivisionStep = -1) then concat('TI_',@Name) else (for $item in (1 to xs:integer(ceiling($Block_Len div $SubDivisionStep))) return concat('TI_',@Name,'_',$item))"/></xsl:variable>
	<xsl:for-each select="tokenize($TP_Name,' ')">
		&lt;TrackPortion Name=&quot;<xsl:value-of select="."/>&quot; ID=&quot;<xsl:value-of select="."/>&quot; CBI=&quot;CBIS_<xsl:value-of select="tokenize($values,' ')[1]"/>&quot; LC=&quot;LCS_<xsl:value-of select="tokenize($values,' ')[2]"/>&quot; <xsl:value-of select="if(tokenize($values,' ')[4]) then concat('ZC=&quot;','ZCS_', tokenize($values,' ')[4], '&quot;') else ''"/> Area=&quot;<xsl:value-of select="tokenize($values,' ')[3]"/>&quot; TrackSectionID=&quot;<xsl:value-of select="$sdd/@Name"/>&quot; TrackSectionName=&quot;<xsl:value-of select="sys:alias_name($sdd)"/>&quot;/&gt;</xsl:for-each>
</xsl:template>
	
<!-- Template for ESAList-->
<xsl:template match="Emergency_Stop_Area" mode="ESAList">
	<xsl:variable name="Block_ID"><xsl:value-of select="for $item in Block_ID_List/Block_ID return(if($item = key('block_list',$SERVER_ID)) then $item else null)"/></xsl:variable>
	&lt;ESA Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; ID=&quot;<xsl:value-of select="@Name"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="key('block_id',tokenize($Block_ID,' ')[1])/sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="key('block_id',tokenize($Block_ID,' ')[1])/sys:lc/@id"/>&quot; ZC=&quot;ZCS_<xsl:value-of select="key('block_id',tokenize($Block_ID,' ')[1])/sys:zc/@id"/>&quot; Area=&quot;<xsl:value-of select="key('block_id',tokenize($Block_ID,' ')[1])/sys:geo/@name"/>&quot;/&gt;</xsl:template>

	<!-- Template for PointEndsList-->
	<xsl:template match="Point" mode="PointEndsList">
	&lt;PointEnd Name=&quot;<xsl:value-of select="@Name"/>&quot; ID=&quot;<xsl:value-of select="@Name"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="sys:lc/@id"/>&quot; ZC=&quot;ZCS_<xsl:value-of select="sys:zc/@id"/>&quot; Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot;/&gt;</xsl:template>

	<!-- Template for Speedslist -->
	<xsl:template match="Reduction_Speed" mode="SpeedList">
	&lt;Speed Value=&quot;<xsl:value-of select="Speed_Value"/>&quot;/&gt;</xsl:template>

	
<!-- Template for SignalsList-->
<xsl:template match="Signal" mode="SignalsList">
	<xsl:variable name="trackID" select="Track_ID"/>
	<xsl:variable name="kPSignal" select="Kp/@Value + Kp/@Corrected_Gap_Value + Kp/@Corrected_Trolley_Value"/>
	<xsl:variable name="block_ID_List"><xsl:value-of select="for $item in //Blocks/Block[Track_ID = $trackID] return (if(( (xs:double($item/Kp_Begin) &lt;= xs:double($kPSignal)) and (xs:double($kPSignal) &lt;= xs:double($item/Kp_End))) or ( (xs:double($item/Kp_Begin) &gt;= xs:double($kPSignal)) and (xs:double($kPSignal) &gt;= xs:double($item/Kp_End)))) then ($item/@ID) else (null))"/></xsl:variable>
	<xsl:variable name="block_ID"><xsl:value-of select="if (count(tokenize($block_ID_List,' ')) &gt; 1) then (tokenize($block_ID_List,' ')[1]) else $block_ID_List"/></xsl:variable>
	<xsl:if test="$block_ID = key('block_list',$SERVER_ID)">
	&lt;Signal Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; ID=&quot;<xsl:value-of select="@Name"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="sys:lc/@id"/>&quot; <xsl:value-of select="if(sys:zc/@id) then concat('ZC=&quot;','ZCS_', sys:zc/@id, '&quot;') else ''"/> Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot; Blockable=&quot;<xsl:value-of select="if(Signal_Blocked_By_ATS_Operator = 'true') then ('1') else '0'"/>&quot; DestinationBlockable=&quot;<xsl:value-of select="if(Destination_Signal_Blocked_By_ATS_Operator = 'true') then '1' else '0'"/>&quot; ExitGateBlockable=&quot;<xsl:value-of select="if(//Exit_Gate/Exit_Gate_Signal_ID = @ID) then '1' else '0'"/>&quot;/&gt;</xsl:if>
</xsl:template>

<!-- Template for CyclesList-->
<xsl:template match="Cycle" mode="CyclesList">
	<xsl:variable name="blockID_List" select="for $item in Route_Sequence_List/Route_ID return //Blocks/Block[Secondary_Detection_Device_ID = (//Signals/Signal[@ID = //Routes/Route[@ID = $item]/Origin_Signal_ID]/Secondary_Detection_Device_ID)]/@ID"/>
	<xsl:variable name="blockID_temp" select="for $item in tokenize($blockID_List, ' ') return (if ($item = key('block_list',$SERVER_ID)) then $item else null)"/>
	<xsl:variable name="blockID" select="tokenize($blockID_temp,' ')[1]"/>
	&lt;Cycle Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; ID=&quot;<xsl:value-of select="@Name"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="sys:lc/@id"/>&quot; ZC=&quot;ZCS_<xsl:value-of select="sys:zc/@id"/>&quot; Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot;/&gt;</xsl:template>

<!-- Template for SubRoutesList -->
<xsl:template match="Sub_Route" mode="SubRoutesList">
	&lt;SubRoute Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; ID=&quot;<xsl:value-of select="@Name"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="sys:lc/@id"/>&quot; <xsl:value-of select="if(sys:zc/@id) then concat('ZC=&quot;','ZCS_', sys:zc/@id, '&quot;') else ''"/> Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot;/&gt;</xsl:template>

<!-- Template for RoutesList -->
<xsl:template match="Route" mode="RoutesList">
	<xsl:variable name="routeID" select="@ID"/>
	<xsl:variable name="sddID" select="//Signal[@ID = //Route[@ID=$routeID]/Origin_Signal_ID]/Secondary_Detection_Device_ID"/>
	<xsl:variable name="blockID"><xsl:value-of select="//Block[Secondary_Detection_Device_ID = $sddID]/@ID"/></xsl:variable>
	<xsl:if test="some $item in tokenize($blockID,' ') satisfies ($item = key('block_list',$SERVER_ID))">
	&lt;Route Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; ID=&quot;<xsl:value-of select="@Name"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="sys:lc/@id"/>&quot; <xsl:value-of select="if(sys:zc/@id) then concat('ZC=&quot;','ZCS_', sys:zc/@id, '&quot;') else ''"/> Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot;/&gt;</xsl:if>
</xsl:template>

<!-- Template for SPKSList-->
<xsl:template match="SPKS" mode="SPKSList">
	&lt;SPKS Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; ID=&quot;<xsl:value-of select="@Name"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="key('block_id',Block_ID)/sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="key('block_id',Block_ID)/sys:lc/@id"/>&quot; <xsl:value-of select="if(key('block_id',Block_ID)/sys:zc/@id) then concat('ZC=&quot;','ZCS_', key('block_id',Block_ID)/sys:zc/@id, '&quot;') else ''"/> Area=&quot;<xsl:value-of select="key('block_id',Block_ID)/sys:geo/@name"/>&quot;/&gt;</xsl:template>

<!-- Template for GAMASList-->
<xsl:template match="GAMA_Zone" mode="GAMAsList">
	<xsl:variable name="blocks"><xsl:value-of select="for $item in Elementary_GAMA_ID_List/Elementary_GAMA_ID return(key('egama',$item)/Block_ID_List/Block_ID)"/></xsl:variable>
	<xsl:if test="some $item in tokenize($blocks,' ') satisfies ($item = key('block_list',$SERVER_ID))">
	&lt;GAMA Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; ID=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="sys:lc/@id"/>&quot; <xsl:value-of select="if(sys:zc/@id) then concat('ZC=&quot;','ZCS_', sys:zc/@id, '&quot;') else ''"/> Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot;&gt; &lt;BlockList&gt; <xsl:value-of select="for $item in tokenize($blocks,' ') return(if ( $item = key('block_list',$SERVER_ID)) then concat('&lt;Block ID=&quot;',//Block[@ID = $item]/@Name,'&quot; Name=&quot;',sys:alias_name(//Block[@ID = $item]),'&quot;&gt; &lt;/Block&gt;') else null) "/>&lt;/BlockList&gt;&lt;/GAMA&gt;</xsl:if>
</xsl:template>

<!-- Template for ZCsList-->
<xsl:template match="ZC" mode="ZCsList">
	<xsl:variable name="zcAreaID" select="ZC_Area_ID"/>
	<xsl:variable name="TS_List"><xsl:value-of select="for $item in //Signalisation_Area[@ID = $zcAreaID]/Block_ID_List/Block_ID return(//Block[@ID = $item]/Track_ID)"/></xsl:variable>
	<xsl:variable name="some_contained_depot_mainline"><xsl:value-of select="(some $item in distinct-values(tokenize($TS_List,' ')) satisfies ($item = //Depot/Track_ID_List/Track_ID)) and (some $item in distinct-values(tokenize($TS_List,' ')) satisfies ($item = //Mainline/Track_ID_List/Track_ID))"/></xsl:variable>
	<xsl:variable name="LocType"><xsl:value-of select="if(every $item in distinct-values(tokenize($TS_List,' ')) satisfies $item = //Mainline/Track_ID_List/Track_ID) then '0' else(if (every $item in distinct-values(tokenize($TS_List,' ')) satisfies ($item = //Depot/Track_ID_List/Track_ID)) then '1' else (if($some_contained_depot_mainline = 'true') then '2' else 'null'))"/></xsl:variable>
	&lt;ZC Name=&quot;<xsl:value-of select="@Name"/>&quot; ID=&quot;ZCS_<xsl:value-of select="@ID"/>&quot; LocType=&quot;<xsl:value-of select="$LocType"/>&quot;/&gt;</xsl:template>

<!-- Template for LCsList-->
<xsl:template match="ATC_Equipment" mode="LCsList">
	&lt;LC Name=&quot;<xsl:value-of select="@Name"/>&quot; ID=&quot;LCS_<xsl:value-of select="@ID"/>&quot;/&gt;</xsl:template>

<!-- Template for FEPsList-->
<xsl:template match="ATS" mode="FEPsList">
	<xsl:variable name="atsID" select="@ID"/>
	<xsl:variable name="ssid_List"><xsl:value-of select="for $zc in //ZCs/ZC[ATS_ID_List/ATS_ID = $atsID]/SSID return $zc"/></xsl:variable>
		&lt;FEP Name=&quot;<xsl:value-of select="@Name"/>&quot; ID=&quot;<xsl:value-of select="@ID"/>&quot; ZCSectors=&quot;<xsl:value-of select="replace($ssid_List,' ',';')"/>&quot;/&gt;</xsl:template>

<!-- Template for SwitchPointEndsList -->
<xsl:template match="Switch" mode="SwitchPointEndsList">
	<xsl:variable name="pointID"><xsl:value-of select="if(Convergent_Point_ID_List/Convergent_Point_ID_Not_Defined = '0') then (Divergent_Point_ID_List/Divergent_Point_ID) else (Convergent_Point_ID_List/Convergent_Point_ID)"/></xsl:variable>
	&lt;PointEnd Name=&quot;<xsl:value-of select="key('point_id',$pointID)/@Name"/>&quot; ID=&quot;<xsl:value-of select="key('point_id',$pointID)/@Name"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="sys:lc/@id"/>&quot; <xsl:value-of select="if(sys:zc/@id) then concat('ZC=&quot;','ZCS_', sys:zc/@id, '&quot;') else ''"/> Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot;/&gt;</xsl:template>

<!-- Template for CBIsList -->
<xsl:template match="CBI" mode="CBIsList">
	&lt;CBI Name=&quot;<xsl:value-of select="@Name"/>&quot; ID=&quot;CBIS_<xsl:value-of select="@ID"/>&quot;/&gt;</xsl:template>

<!-- TEmplate for TrainsList-->
<xsl:template match="Train_Unit" mode="TrainsList">
	&lt;Train Name=&quot;Train<xsl:value-of select="format-number(@ID,'000')"/>&quot; ID=&quot;Train<xsl:value-of select="format-number(@ID,'000')"/>&quot; Area=&quot;Train&quot;/&gt;</xsl:template>

<!-- Template for GroupInhibitionList-->
<xsl:template match="/" mode="GroupInhibitionList">
<%groupinhibitionlist=[("//Cycle","Cycle","CyclesList"),("//Emergency_Stop_Area","Emergency_Stop_Area","ESAList"),("//Block","Block","FixedBlocksList"),("//Point","Point","PointEndsList"),("//Route","Route","RoutesList"),
                     ("//SDD_Group_In_Operation","SDD_Groups_In_Operation","SDDGroupsList"),("//Signal","Signal","SignalsList"),("//Sub_Route","Sub_Route","SubRoutesList"),("//Secondary_Detection_Device","Secondary_Detection_Device","TrackSectionsList"),("//Train_Unit","Train_Unit","TrainsList")]%>
	%	for node,name,id in groupinhibitionlist:
		<xsl:if test="count(${node}) != 0">&lt;GroupInhibition Name=&quot;${name}&quot; ID=&quot;${id}&quot;/&gt;
		</xsl:if>
	%	endfor
</xsl:template>

<!-- Template for PlatformsList-->
<xsl:template match="Stopping_Area" mode="PlatformsList">
	<xsl:variable name="platformID"><xsl:value-of select="for $item in (Original_Area_List/Original_Area) return (if($item/@Original_Area_Type = 'Platform') then $item/@ID else null)"/></xsl:variable>
	<xsl:variable name="stationID" select="Station_ID"/>
	<xsl:if test="$platformID != ''">
	&lt;Platform ID=&quot;<xsl:value-of select="concat('Stop_',@Name)"/>&quot; Name=&quot;<xsl:value-of select="sys:alias_name(key('platform_id',tokenize($platformID,' ')[1]))"/>&quot; KmPosition=&quot;<xsl:value-of select="key('platform_id',tokenize($platformID,' ')[1])/Kp_Begin/format-number((@Value + @Corrected_Gap_Value + @Corrected_Trolley_Value),'#')"/>&quot; StationID=&quot;<xsl:value-of select="$stationID"/>&quot; StationName=&quot;<xsl:value-of select="//Station[@ID = $stationID]/@Name"/>&quot;&gt;&lt;/Platform&gt;</xsl:if>
</xsl:template>

<!-- Template for CalculatedWorkZoneBoundaryList-->
<xsl:template match="Calculated_Work_Zone_Boundary" mode="CalculatedWorkZoneBoundaryList">
	<xsl:variable name="trackID" select="Track_ID"/>
	<xsl:variable name="dir" select="Direction"/>
	<xsl:variable name="kP" select="Kp/@Value + Kp/@Corrected_Gap_Value + Kp/@Corrected_Trolley_Value"/>
	<xsl:variable name="blockID" select="if ($dir='Up') then (//Block[(Track_ID = $trackID) and (((number(Kp_Begin) &lt;= number($kP)) and (number(Kp_End) &gt; number($kP))) or ((number(Kp_Begin) &gt;= number($kP)) and (number(Kp_End) &lt; number($kP))))]/@ID) else (//Block[(Track_ID = $trackID) and (((number(Kp_Begin) &lt; number($kP)) and (number(Kp_End) &gt;= number($kP))) or ((number(Kp_Begin) &gt; number($kP)) and (number(Kp_End) &lt;= number($kP))))]/@ID)"/>
	<xsl:if test="$blockID = //Signalisation_Area[@ID = $SERVER_ID]/Block_ID_List/Block_ID">
	&lt;WorkZoneBoundary ID=&quot;<xsl:value-of select="@Name"/>&quot; Name=&quot;<xsl:value-of select="concat(//Block[@ID=$blockID]/@Name,'_',$dir)"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="key('block_id',$blockID)/sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="sys:lc/@id"/>&quot; <xsl:value-of select="if(key('block_id',$blockID)/sys:zc/@id) then concat('ZC=&quot;','ZCS_', key('block_id',$blockID)/sys:zc/@id, '&quot;') else ''"/> Area=&quot;<xsl:value-of select="key('block_id',$blockID)/sys:geo/@name"/>&quot;&gt;&lt;/WorkZoneBoundary&gt;</xsl:if>
</xsl:template>

<!-- Template Elementary_GAMA|Emergency_Stop_Area, used for generating eGAMA and eESA anc called inside template Block of mode = FixedBlockList
	 Template called inside Template Block-->
<xsl:template match="Elementary_GAMA|Emergency_Stop_Area"><xsl:variable name="localname"><xsl:value-of select="if (local-name() = 'Elementary_GAMA') then 'ElementaryGama' else 'ElementaryESA'"/></xsl:variable><xsl:variable name="blockBeginID"><xsl:value-of select="Block_ID_List/Block_ID[1]"/></xsl:variable><xsl:variable name="blockEndID"><xsl:value-of select="Block_ID_List/Block_ID[last()]"/></xsl:variable>&lt;<xsl:value-of select="$localname"/> ID=&quot;<xsl:value-of select="if (local-name()='Elementary_GAMA') then concat('EG_',sys:alias_name(.)) else @Name"/>&quot; Name=&quot;<xsl:value-of select="if (local-name()='Elementary_GAMA') then concat('EG_',sys:alias_name(.)) else @Name"/>&quot; KPBegin=&quot;<xsl:value-of select="//Block[@ID = $blockBeginID]/Kp_Begin + Start_Abscissa"/>&quot; KPEnd=&quot;<xsl:value-of select="//Block[@ID = $blockEndID]/Kp_Begin + End_Abscissa"/>&quot;/&gt;</xsl:template>

<!-- Template of Evacuation_Zones_Req List -->
<xsl:template match="Evacuation_Zone_Req" mode="EZRList">
	&lt;EZR ID=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; CBI=&quot;<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;<xsl:value-of select="sys:lc/@id"/>&quot; ZC=&quot;<xsl:value-of select="sys:zc/@id"/>&quot; Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot;&gt;&lt;/EZR&gt;</xsl:template>

<!-- Template of Evacuation_Zones_Sec List -->
<xsl:template match="Evacuation_Zone_Sec" mode="EZSList">
	&lt;EZS ID=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; CBI=&quot;<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;<xsl:value-of select="sys:lc/@id"/>&quot; ZC=&quot;<xsl:value-of select="sys:zc/@id"/>&quot; Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot;&gt;&lt;/EZS&gt;</xsl:template>

<!-- Template for SDDGroupList-->
	<xsl:template match="SDD_Group_In_Operation" mode="SDDGroupList">
	&lt;SDDGroup Name=&quot;<xsl:value-of select="sys:alias_name(.)"/>&quot; ID=&quot;<xsl:value-of select="@Name"/>&quot; CBI=&quot;CBIS_<xsl:value-of select="sys:cbi/@id"/>&quot; LC=&quot;LCS_<xsl:value-of select="sys:lc/@id"/>&quot; ZC=&quot;ZCS_<xsl:value-of select="sys:zc/@id"/>&quot; Area=&quot;<xsl:value-of select="sys:geo/@name"/>&quot;/&gt;</xsl:template>
	
	
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue"/>

