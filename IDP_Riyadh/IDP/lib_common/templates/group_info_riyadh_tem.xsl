<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sys="http://www.systerel.fr/Alstom/IDP" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>


  <xsl:template match="/">
    <xsl:apply-templates select="/docs/ATS_SYSTEM_PARAMETERS"/>
  </xsl:template>

<!-- Return the table name corresponding to a Stopping Area Type.-->
  <xsl:function name="sys:table">
    <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="$type='Change Of Direction Area'">Change_Of_Direction_Areas</xsl:when>
            <xsl:when test="$type='Platform'">Platforms</xsl:when>
            <xsl:when test="$type='Transfer Track'">Transfer_Tracks</xsl:when>
            <xsl:when test="$type='Stabling'">Stablings_Location</xsl:when>
            <xsl:when test="$type='Coupling Uncoupling'">Coupling_Uncoupling_Areas</xsl:when>
            <xsl:when test="$type='Washing'">Washing_Zones</xsl:when>
            <xsl:when test="$type='Isolation Area'">Isolation_Areas</xsl:when>
            <xsl:otherwise><xsl:message terminate="yes">Unknown type<xsl:value-of select="$type"/></xsl:message></xsl:otherwise>
        </xsl:choose>
  </xsl:function>

<!--
Template that match an element of a table.
For each element first, the node is copied and the templates are applied on the element given the territory informations.
-->
% for (en, var_req, req) in [("Switch", "", "(.//Convergent_Point_ID|.//Divergent_Point_ID)[1]"),("CBI|ZC|RemoteIO","Urbalis_Sector_ID","//Line[Urbalis_Sector_ID_List/Urbalis_Sector_ID/text()=$v]"),("SDD_Group_In_Operation","if(count(Secondary_Detection_Device_ID_List/Secondary_Detection_Device_ID)=1) then 1 else count(Secondary_Detection_Device_ID_List/Secondary_Detection_Device_ID) idiv 2","Secondary_Detection_Device_ID_List/Secondary_Detection_Device_ID[$v]"),("Cycle","","Route_Sequence_List/*[1]"),("Emergency_Stop_Area","ceiling(count(Block_ID_List/Block_ID) div 2)","Block_ID_List/Block_ID[$v]"),("ESP|Platform_Screen_Doors|Elementary_GAMA","","Block_ID_List/Block_ID[1]"),("Signalisation_Area","","Block_ID_List/Block_ID"),("Calculated_Work_Zone_Boundary|Platform","","Track_ID"),("Overlap","@ID","//Signal[Overlap_ID=$v]"),("CBI_Routes_Cycles_Control_Key|Traffic_Direction|Sub_Route|SPKS","","Block_ID"),("Switch_Local_Control_Key","","Switch_ID_List/*"),("Junction_Area", "", "Point_ID"),("Traction_Power_Supply_Equipment", "@ID", "//Power_Supply_Zone[Traction_Power_Supply_Equipment_ID/text()=$v]")]:
							 
   <xsl:template match="${en}" mode="add_el">
    % if var_req != "":
            <xsl:variable name="v" select="${var_req}"/>
    % endif
            <xsl:apply-templates select="${req}" mode="add"/>
   </xsl:template>
% endfor

   <xsl:template match="Adjacent_Monitoring_Area" mode="add_el">
		<xsl:variable name="current_sigarea" select="ATS_Local_Server_Area_ID/text()"/>
		<xsl:variable name="sigblocks" select="//Signalisation_Areas/Signalisation_Area[@ID = $current_sigarea]/Block_ID_List/Block_ID"/>
		<xsl:for-each select="Secondary_Detection_Device_ID_List/Secondary_Detection_Device_ID">
			<xsl:variable name="sddid" select="."/>
			<xsl:variable name="blocks" select="//Blocks/Block[Secondary_Detection_Device_ID = $sddid]/@ID"/>
			<xsl:variable name="adjname" select="for $bl in $blocks return ( (if (//Blocks/Block[@ID = $bl and Next_Up_Normal_Block_ID]/Next_Up_Normal_Block_ID = $sigblocks) then concat('AMA_',//Blocks/Block[@ID = $bl]/@Name, '_', //Block[@ID = //Blocks/Block[@ID = $bl]/Next_Up_Normal_Block_ID]/@Name) else null),
										(if (//Blocks/Block[@ID = $bl and Next_Down_Normal_Block_ID]/Next_Down_Normal_Block_ID = $sigblocks) then concat('AMA_',//Blocks/Block[@ID = $bl]/@Name,'_',//Block[@ID = //Blocks/Block[@ID = $bl]/Next_Down_Normal_Block_ID]/@Name) else null),
										(if (//Blocks/Block[@ID = $bl and Next_Up_Reverse_Block_ID]/Next_Up_Reverse_Block_ID = $sigblocks) then concat('AMA_',//Blocks/Block[@ID = $bl]/@Name,'_',//Block[@ID = //Blocks/Block[@ID = $bl]/Next_Up_Reverse_Block_ID]/@Name) else null),
										(if (//Blocks/Block[@ID = $bl and Next_Down_Reverse_Block_ID]/Next_Down_Reverse_Block_ID = $sigblocks) then concat('AMA_',//Blocks/Block[@ID = $bl]/@Name,'_',//Block[@ID = //Blocks/Block[@ID = $bl]/Next_Down_Reverse_Block_ID]/@Name) else null))"/>
			<xsl:if test="$adjname">
				<sys:adjobj name="{$adjname[1]}" id="{$sddid}"/>
			</xsl:if>
		</xsl:for-each>
		<xsl:apply-templates select="Secondary_Detection_Device_ID_List/Secondary_Detection_Device_ID" mode="add"/>
   </xsl:template>

   <xsl:template match="Power_Supply_Zone" mode="add">
        <xsl:variable name="tid" select="Track_ID/text()"/>
        <xsl:variable name="kpb" select="sys:corr_kp(Kp_Begin)"/>
        <xsl:variable name="kpe" select="sys:corr_kp(Kp_End)"/>
        <xsl:apply-templates select="//(Block[Track_ID = $tid and ((number(Kp_Begin) &lt;= number($kpb) and number(Kp_End) &gt; number($kpb)) or (number(Kp_Begin) &gt;= number($kpb) and number(Kp_End) &lt;= number($kpe)) or (number(Kp_End) &gt;= number($kpe) and number(Kp_Begin) &lt; number($kpe)) or (number(Kp_Begin) &gt;= number($kpb) and number(Kp_End) &lt; number($kpb)) or (number(Kp_Begin) &lt;= number($kpb) and number(Kp_End) &gt;= number($kpe)) or (number(Kp_End) &lt;= number($kpe) and number(Kp_Begin) &gt; number($kpe)))])[1]"  mode="add_el"/>
   </xsl:template>
   
   <xsl:template match="Track_Container" mode="add_el">
        <xsl:variable name="tid" select="Track_ID/text()"/>
        <xsl:variable name="kpb" select="sys:corr_kp(Kp_Begin)"/>
        <xsl:apply-templates select="//(Block[Track_ID = $tid and ((number(Kp_Begin) &lt;= number($kpb) and number(Kp_End) &gt;= number($kpb)) or (number(Kp_Begin) &gt;= number($kpb) and number(Kp_End) &lt;= number($kpb)))])[1]"  mode="add_el"/>
   </xsl:template>

   <xsl:template match="Point" mode="add_el">
            <xsl:variable name="v" select="@ID"/>
            <xsl:apply-templates select="//Block[Point_ID=$v]" mode="add_el"/>
   </xsl:template>

   <xsl:template match="Secondary_Detection_Device" mode="add_el">
            <xsl:variable name="v" select="@ID"/>
            <xsl:apply-templates select="//Block[Secondary_Detection_Device_ID=$v]" mode="add_el"/>
   </xsl:template>

  <xsl:template match="Stopping_Area" mode="add_el">	
	<xsl:for-each select="Original_Area_List/Original_Area">
		<xsl:variable name="type" select="@Original_Area_Type"/>
		<xsl:variable name="id" select="@ID"/>
		 <xsl:apply-templates select="//*[local-name()=sys:table($type)]/*[@ID=$id]" mode="Stopping"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="Isolation_Area|Change_Of_Direction_Area" mode="add_el">
    <xsl:apply-templates select="." mode="Stopping"/>
  </xsl:template>

    <xsl:template match="Track_Allocation_Zone" mode="add_el">
        <xsl:variable name="tid" select="Track_ID/text()"/>
        <xsl:variable name="kpb" select="sys:corr_kp(Kp_Begin)"/>
		<xsl:variable name="block" select="//Block[Track_ID = $tid and ((number(Kp_Begin) &lt;= number($kpb) and number(Kp_End) &gt;= number($kpb)) or (number(Kp_Begin) &gt;= number($kpb) and number(Kp_End) &lt;= number($kpb)))]"/>
		<xsl:apply-templates select="$block[1]"  mode="add_el"/>
  </xsl:template>
  
  <xsl:template match="Change_Of_Direction_Area|Platform|Stabling_Location|Transfer_Track|Coupling_Uncoupling_Area|Washing_Zone|Isolation_Area|Track_Allocation_Zone" mode="Stopping">
        <xsl:variable name="tid" select="Track_ID/text()"/>
        <xsl:variable name="kpb" select="sys:corr_kp(Kp_Begin)"/>
        <xsl:variable name="kpe" select="sys:corr_kp(Kp_End)"/>
		<xsl:for-each select="//Block[Track_ID = $tid and ((number(Kp_Begin) &lt;= number($kpb) and number(Kp_End) &gt; number($kpb)) or (number(Kp_Begin) &gt;= number($kpb) and number(Kp_End) &lt;= number($kpe)) or (number(Kp_End) &gt;= number($kpe) and number(Kp_Begin) &lt; number($kpe)) or (number(Kp_Begin) &gt;= number($kpb) and number(Kp_End) &lt; number($kpb)) or (number(Kp_Begin) &lt;= number($kpb) and number(Kp_End) &gt;= number($kpe)) or (number(Kp_End) &lt;= number($kpe) and number(Kp_Begin) &gt; number($kpe)))]">
			<sys:blockid name="{@Name}" id="{@ID}"/> 
		</xsl:for-each>
		<xsl:apply-templates select="//(Block[Track_ID = $tid and ((number(Kp_Begin) &lt;= number($kpb) and number(Kp_End) &gt; number($kpb)) or (number(Kp_Begin) &gt;= number($kpb) and number(Kp_End) &lt;= number($kpe)) or (number(Kp_End) &gt;= number($kpe) and number(Kp_Begin) &lt; number($kpe)) or (number(Kp_Begin) &gt;= number($kpb) and number(Kp_End) &lt; number($kpb)) or (number(Kp_Begin) &lt;= number($kpb) and number(Kp_End) &gt;= number($kpe)) or (number(Kp_End) &lt;= number($kpe) and number(Kp_Begin) &gt; number($kpe)))])[1]"  mode="add_el"/>
  </xsl:template>

  <xsl:template match="Washing_Zone" mode="add_el">
        <xsl:variable name="tid" select="Track_ID/text()"/>
        <xsl:variable name="kpb" select="sys:corr_kp(Kp_Begin)"/>
        <xsl:variable name="kpe" select="sys:corr_kp(Kp_End)"/>
		<xsl:apply-templates select="//(Block[Track_ID = $tid and ((number(Kp_Begin) &lt;= number($kpb) and number(Kp_End) &gt; number($kpb)) or (number(Kp_Begin) &gt;= number($kpb) and number(Kp_End) &lt;= number($kpe)) or (number(Kp_End) &gt;= number($kpe) and number(Kp_Begin) &lt; number($kpe)) or (number(Kp_Begin) &gt;= number($kpb) and number(Kp_End) &lt; number($kpb)) or (number(Kp_Begin) &lt;= number($kpb) and number(Kp_End) &gt;= number($kpe)) or (number(Kp_End) &lt;= number($kpe) and number(Kp_Begin) &gt; number($kpe)))])[1]"  mode="add_el"/>
  </xsl:template>

  <xsl:template match="*" mode="Stopping">
        <xsl:value-of select="local-name()"/>
  </xsl:template>

  <xsl:template match="GAMA_Zone"  mode="add_el">
            <xsl:variable name="EGID" select="Elementary_GAMA_ID_List/Elementary_GAMA_ID[1]"/>
            <xsl:apply-templates select="/docs/ATS_SYSTEM_PARAMETERS/Elementarys_GAMA/Elementary_GAMA[@ID=$EGID]/Block_ID_List/Block_ID[1]" mode="add"/>
  </xsl:template>

  <xsl:template match="Evacuation_Zone_Req|Evacuation_Zone_Sec|Give_Take_Isolation_Zone"  mode="add_el">
            <xsl:variable name="BMZID" select="Basic_Multitrack_Zone_ID_List/Basic_Multitrack_Zone_ID[1]"/>
            <xsl:variable name="EZID" select="/docs/ATS_SYSTEM_PARAMETERS/Basic_Multitrack_Zones/Basic_Multitrack_Zone[@ID=$BMZID]/Elementary_Zone_ID_List/Elementary_Zone_ID[1]"/>
            <xsl:apply-templates select="/docs/ATS_SYSTEM_PARAMETERS/Elementary_Zones/Elementary_Zone[@ID=$EZID]/Elementary_Zone_Block_ID_List/Block_ID[1]"  mode="add"/>
    </xsl:template>

% for e in ["Switch", "Route", "Block", "Point"]:
   <xsl:template match="${e}_ID" mode="add">
        <xsl:variable name="id" select="./text()"/>
        <xsl:apply-templates select="//${e}[@ID=$id]" mode="add_el"/>
    </xsl:template>
% endfor

   <xsl:template match="Convergent_Point_ID|Divergent_Point_ID"  mode="add">
        <xsl:variable name="id" select="./text()"/>
       <xsl:apply-templates select="//Block[Point_ID=$id]" mode="add_el"/>
   </xsl:template>

    <xsl:template match="Route" mode="add_el">
        <xsl:variable name="sid" select="Origin_Signal_ID/text()"/>
        <xsl:apply-templates select="//Signal[@ID=$sid]" mode="add"/>
    </xsl:template>

	 <xsl:template match="Signal" mode="add">
        <xsl:apply-templates select="." mode="add_el"/>
    </xsl:template>
	
    <xsl:template match="Secondary_Detection_Device_ID" mode="add">
        <xsl:variable name="id" select="./text()"/>
        <xsl:apply-templates select="//Block[Secondary_Detection_Device_ID=$id]" mode="add_el"/>
    </xsl:template>

    <xsl:template match="Signal|Direction_Indicator" mode="add_el">
        <xsl:variable name="pk" select="Kp/@Value + Kp/@Corrected_Gap_Value + Kp/@Corrected_Trolley_Value"/><!-- sys:corr_kp(Kp)"/> -->
        <xsl:variable name="tid" select="Track_ID/text()"/>
        <xsl:variable name="dir" select="Direction/text()"/>

        <!--  select all the blocks where the signal is on an extrimity -->
        <xsl:variable name="blocks_extr" select="//Block[(Kp_Begin/text() = $pk or Kp_End/text() = $pk ) and Track_ID/text() = $tid]"/>
        <!-- first case : the signal is on the extrimity of one and only one block -->
        <xsl:if test="count($blocks_extr) = 1">
            <xsl:variable name="id" select="$blocks_extr/*[local-name() = concat('Next_',$dir,'_Normal_Block_ID')]/text()"/> 
            <xsl:apply-templates  select="if ($id) then //Block[@ID=$id] else $blocks_extr" mode="add_el"/>
        </xsl:if>

        <xsl:if test="count($blocks_extr) = 2">
            <xsl:if test="$dir='Up'">
                <xsl:apply-templates  select="//Block[Kp_Begin/text() = $pk and Track_ID/text() = $tid]" mode="add_el"/>
            </xsl:if>
            <xsl:if test="$dir='Down'">
                <xsl:apply-templates  select="//Block[Kp_End/text() = $pk and Track_ID/text() = $tid]" mode="add_el"/>
            </xsl:if>
        </xsl:if>
        
        <!-- select the block where the signal is located.  -->
        ${var("block_sup", "//Block[((Kp_Begin/text() &lt; $pk and $pk &lt; Kp_End/text()) or (Kp_End/text() &lt; $pk and $pk &lt; Kp_Begin/text())) and Track_ID/text() = $tid]")}    
        <xsl:if test="count($block_sup)=1">
                <xsl:variable name="id" select="$block_sup/*[local-name() = concat('Next_',$dir,'_Normal_Block_ID')]/text()"/> 
                <xsl:apply-templates  select="if ($id) then //Block[@ID=$id] else $block_sup" mode="add_el"/>
       </xsl:if>

    </xsl:template>

    <xsl:template match="Track_ID" mode="add">
	    <xsl:variable name="trackid" select="./text()"/>
        <xsl:variable name="usid" select="//Urbalis_Sector[Track_ID_List/Track_ID/text()=$trackid]/@ID"/>
        <xsl:apply-templates select="//Line[Urbalis_Sector_ID_List/Urbalis_Sector_ID/text()=$usid]" mode="add"/>

        <xsl:variable name="mainline_name" select="//Mainlines/Mainline/Track_ID_List/Track_ID[text()=$trackid]/../../@Name"/>
        <xsl:variable name="depot_name" select="//Depots/Depot/Track_ID_List/Track_ID[.=$trackid]/../../@Name"/>
        <xsl:variable name="md_name" select="if ($mainline_name) then $mainline_name else $depot_name"/>   

        <sys:main_depot name="{$md_name}"/>
        <xsl:variable name="uslcid" select="//Urbalis_Sector[Track_ID_List/Track_ID/text()=$trackid]/LC_ID"/>
        <xsl:variable name="lc_name" select="//ATC_Equipment[@ID=$uslcid]/@Name"/>
        <sys:lc name="{$lc_name}" id="{$uslcid}"/>
    </xsl:template>


   <xsl:template match="Block" mode="add_el">
        <xsl:variable name="block" select="."/>
        <xsl:variable name="blockid" select="@ID"/>
        <xsl:comment>From Block <xsl:value-of select="$blockid"/></xsl:comment>
    	<xsl:variable name="sddid" select="$block/Secondary_Detection_Device_ID"/>
        
        <xsl:apply-templates select="Track_ID" mode="add"/>
        
        <xsl:variable name="geoarea_id_sdd" select="//Geographical_Area/Secondary_Detection_Device_ID_List/Secondary_Detection_Device_ID[text()=$sddid]/../../@ID"/>
        <xsl:variable name="geoarea_id_track" select="//Geographical_Area/Block_ID_List/Block_ID[text()=$blockid]/../../@ID"/>
        <xsl:variable name="geoarea_id" select="if ($geoarea_id_sdd) then $geoarea_id_sdd else $geoarea_id_track"/>

        <xsl:apply-templates select="(//Territory[Geographical_Area_ID_List/Geographical_Area_ID/text()=$geoarea_id])[last()]" mode="add"/>
        <xsl:apply-templates select="(//Geographical_Area[@ID=$geoarea_id])[last()]" mode="add"/>
    
        <xsl:for-each select="//Signalisation_Area[Block_ID_List/Block_ID/text()=$blockid]">
          <sys:sigarea name="{@Name}" id="{@ID}"/>
        </xsl:for-each>
        <xsl:variable name="said" select="//Signalisation_Area[Area_Type/text()='ZC' and Block_ID_List/Block_ID/text()=$blockid]/@ID"/>
        <xsl:variable name="zcid" select="//ZC[ZC_Area_ID/text()=$said]/@ID"/>
        <xsl:variable name="zcname" select="//ZC[ZC_Area_ID/text()=$said]/@Name"/>
        <xsl:if test="//ZC[ZC_Area_ID/text()=$said]">
          <sys:zc name="{$zcname}" id="{$zcid}"/>
        </xsl:if>
        <xsl:variable name="said" select="//Signalisation_Area[Area_Type/text()='CBI' and Block_ID_List/Block_ID/text()=$blockid]/@ID"/>
        <xsl:variable name="cbiid" select="//CBI[CBI_Area_ID/text()=$said]/@ID"/>
        <xsl:variable name="cbiname" select="//CBI[CBI_Area_ID/text()=$said]/@Name"/>
        <xsl:if test="//CBI[CBI_Area_ID/text()=$said]">
          <sys:cbi name="{$cbiname}" id="{$cbiid}"/>
        </xsl:if>
        <xsl:variable name="said" select="//Signalisation_Area[Area_Type/text()='ATS' and Block_ID_List/Block_ID/text()=$blockid]/@ID"/>
        <xsl:variable name="atsid" select="//ATS[ATS_Area_ID/text()=$said]/@ID"/>
        <xsl:variable name="atsname" select="//ATS[ATS_Area_ID/text()=$said]/@Name"/>
        <xsl:if test="//ATS[ATS_Area_ID/text()=$said]">
          <sys:ats name="{$atsname}" id="{$atsid}"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="Line" mode="add">
      <sys:line name="{@Name}" id="{@ID}" cdd="{Conventional_Description_Direction}" cddrw="{Conventional_Description_Direction_Reading_Way}"/>
    </xsl:template>
    <xsl:template match="Territory" mode="add">
        <sys:terr name="{@Name}"/>
    </xsl:template>

    <xsl:template match="Geographical_Area" mode="add">
        <sys:geo name="{@Name}"/>
    </xsl:template>

    <xsl:template match="@* | node()" mode="add_el"/>
    <xsl:template match="@* | node()">
        <xsl:copy>
           <xsl:apply-templates select="@* | node()"/>
            
            <!-- add the information of location -->
            <xsl:variable name="location_info">
                <xsl:apply-templates select="." mode="add_el"/>
            </xsl:variable>

            <xsl:for-each-group select="$location_info/*" group-by ="@name">
                <xsl:element name="{name(.)}">
                    <xsl:attribute name="name" select="@name"/>
                    <xsl:if test="@id"><xsl:attribute name="id" select="@id"/></xsl:if>
                    <xsl:if test="@cdd"><xsl:attribute name="cdd" select="@cdd"/></xsl:if>
                    <xsl:if test="@cddrw"><xsl:attribute name="cddrw" select="@cddrw"/></xsl:if>
                    <xsl:attribute name="cn" select="count(current-group())"/>
                </xsl:element>
            </xsl:for-each-group>
	    </xsl:copy>
    </xsl:template>

<xsl:include href="../../lib_common/lib_xslt.xsl"/>

	<xsl:template match="Remote_IO" mode="add_el">
		<xsl:variable name="id" select="@ID"/>
		<sys:cbi name="{//CBI[Remote_IO_ID_List/Remote_IO_ID = $id]/@Name}" id="{//CBI[Remote_IO_ID_List/Remote_IO_ID = $id]/@ID}"/>
	</xsl:template>
</xsl:stylesheet>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="var"/>

