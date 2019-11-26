#!/usr/bin/env python2
# -*- coding: utf8 -*-

from lib_common.fabricate import *  # @UnusedWildImport
import lib_common.build_gen  # @UnusedImport
from operator import contains
lib_common.build_gen.base_dir = 'RIYADH/'
from lib_common.build_gen import *  # @UnusedWildImport
import yaml

setup(depsname='.deps_riyadh')

def all():  # @ReservedAssignment
    import_input_files(authorized_file_regex = ['(.*_DATA_INTERFACE).*','^(ATS_SUBSYSTEM_DATABASE)_.*', '^(ATS_PARAMETER_DESCRIPTION)_.*', '^(ATS_TMS)_.*','^(ATS_CUSTOM)_.*'])
    #import_input_files()
    after()
    prepare_input(lib_common_templates=['group_info_riyadh', 'variables', 'LocalRoles'],
           tables_files=['ATS_SUBSYSTEM_DATABASE.xml', 'ATS_PARAMETER_DESCRIPTION.xml', 'ATS_TMS.xml','ATS_CUSTOM.xml'],
           information_add = [('group_info_riyadh', []),
                              ('variables', ['../../lib_common/variable_map.xml'] + get_data_interface_files())])
    after()
    # Generate versions files
    gen_versions_file()
    after()
    # Create list of handled equipments	
    run_xslt('bin/Equipments.yml', 'tools/extract_equipments.xsl', ['ATSs.xml', 'Urbalis_Sectors.xml', 'Signalisation_Areas.xml', 'ATS_Equipments.xml', 'CBIs.xml', 'ZCs.xml', 'Projects.xml'])
    after()
    #Extract Router Information
    sync_point = 'gen_router'
    run_xslt('bin/router_info.yml', 'tools/router_info.xsl', ['ATSs.xml','DCS_Equipments.xml'], group=sync_point)
    run('python', base_dir + 'tools/router_info.py', base_dir + 'bin/router_info.yml', base_dir + 'bin/router_info.xml', after=sync_point) 

    
    # Load yaml equipments file
    eqt_file = file(base_dir + "bin/Equipments.yml")
    eqt_file_data = yaml.load(eqt_file)

    run_xslt_LIB('bin_tools/alias.xsl', 'gen_alias.xsl', ['Alias_Rules.xml', 'Alias_Fields.xml'])

    # Transform XML files and run python scripts
    print_action("Transform XML files and run python scripts")
    run_xslt('bin/LocalesRoles.xml', 'bin_tools/LocalRoles.xsl', ['Projects.xml']) 
    after()
	# Copy static files    
    copy_static_files()
    output_xslt('IDC/Riyadh/RiyadStopAreaPlatformNameMap.xml', 'bin_tools/RiyadStopAreaPlatformNameMap.xsl', ['Stopping_Areas.xml', 'Platforms.xml'])
    output_xslt('IDC/Riyadh/HMITrainRSMCommand.xml', 'bin_tools/HMITrainRSMCommand.xsl', ['Trains_Unit.xml', '../bin/LocalesRoles.xml']) 
    output_xslt('IDC/SigRule/SigRules_HMITrainRSMCommand.xml', 'bin_tools/SigRules_HMITrainRSMCommand.xsl', ['Trains_Unit.xml', '../bin/LocalesRoles.xml']) 
    output_xslt('IDC/Riyadh/HMITrainAlarmMonitored.xml', 'bin_tools/HMITrainAlarmMonitored.xsl', ['Trains_Unit.xml','../bin/LocalesRoles.xml'])
    output_xslt('IDC/Group/Group_HMITrainAlarmMonitored.xml', 'bin_tools/Group_HMITrainAlarmMonitored.xsl', ['Trains_Unit.xml'])
    output_xslt('IDC/Riyadh/HMITrainAlarmTriggered.xml', 'bin_tools/HMITrainAlarmTriggered.xsl', ['Trains_Unit.xml','../bin/LocalesRoles.xml'])
    output_xslt('IDC/Group/Group_HMITrainAlarmTriggered.xml', 'bin_tools/Group_HMITrainAlarmTriggered.xsl', ['Trains_Unit.xml'])
    output_xslt('IDC/Riyadh/HMITrainAttributes.xml', 'bin_tools/HMITrainAttributes.xsl', ['Trains_Unit.xml','../bin/LocalesRoles.xml'])
    output_xslt('IDC/Riyadh/DynamicEBRSMCommand.xml', 'bin_tools/DynamicEBRSMCommand.xsl', ['Trains_Unit.xml','../bin/LocalesRoles.xml'])
    output_xslt('IDC/SigRule/SigRules_DynamicEBRSMCommand.xml', 'bin_tools/SigRules_DynamicEBRSMCommand.xsl', ['Trains_Unit.xml', '../bin/LocalesRoles.xml'])     
    output_xslt('IDC/Riyadh/InServicePropertyBagTrain.xml','bin_tools/InServicePropertyBagTrain.xsl',['Trains_Unit.xml'])
    output_xslt('IPName/IDP_IPName.xml','bin_tools/IDP_IPName.xsl',['ATS_Equipments.xml','ATSs.xml','Lines.xml','Signalisation_Areas.xml','Technical_Rooms.xml','Urbalis_Sectors.xml','External_Master_Clocks.xml','Projects.xml','DCS_Equipments.xml','../bin/LocalesRoles.xml','../bin/router_info.xml'])
    output_xslt('WSH/Common/WSHRollingStockFile.xml', 'bin_tools/WSHRollingStockFile.xsl', ['Trains_Unit.xml','Projects.xml'])
    output_xslt('IDC/Riyadh/RSCommandLV2.xml','bin_tools/RSCommandLV2.xsl',['Trains_Unit.xml','../bin/LocalesRoles.xml'])
    
    for server_id in eqt_file_data["SERVER"]:
        for server_level in server_id["LEVEL"]:
            is_both_level = 'NO'
            if len(server_id["LEVEL"]) == 2:
                is_both_level = 'YES'
                output_xslt('IDC/Riyadh/HMIStringInformation_%s%s.xml'%(server_id["ID"],levels(server_level)), 'bin_tools/HMIStringInformation.xsl', ['Evacuation_Zones_Sec.xml','Evacuation_Zones_Req.xml','Secondary_Detection_Devices.xml', 'Blocks.xml','Reduction_Speeds.xml' ,'Signalisation_Areas.xml', 'Points.xml', 'Emergency_Stop_Areas.xml', 'Cycles.xml', 'Signals.xml', 'Sub_Routes.xml', 'Routes.xml', 'SPKSs.xml', 'GAMA_Zones.xml', 'ZCs.xml', 'ATSs.xml', 'ATC_Equipments.xml', 'Switchs.xml', 'CBIs.xml', 'Stopping_Areas.xml', 'Calculated_Work_Zone_Boundarys.xml', 'Kilometric_Counter_Detectors.xml', 'Trains_Unit.xml', 'Elementarys_GAMA.xml', 'TI_Distributions.xml', 'Exit_Gates.xml', 'Exit_Gates.xml', 'Depots.xml', 'Mainlines.xml', 'Stations.xml', 'Platforms.xml', 'SDD_Groups_In_Operation.xml', '../bin/LocalesRoles.xml'], ['SERVER_ID=%s'%server_id["ID"], 'SERVER_LEVEL=%s' %levels(server_level)])			    
            if "Server" in server_id["AREA_TYPE"]:
                comp_tem(base_dir+'tools/bat_file/RunAutomaticIDCRIM46.bat', base_dir+'output/IDC/RunAutomaticIDCRIM46_%s%s.bat'%(server_id["ID"],levels(server_level)), {'SERVER_LEVEL':levels(server_level),'SERVER_ID':server_id["ID"],'PROJECT':eqt_file_data['Project']["Name"], 'COUNT':len(server_id["LEVEL"])})
                output_xslt('IDC/IDCRIM46_ATS_%s%s.xml'%(server_id["ID"],levels(server_level)), 'bin_tools/IDCRIM46.xsl', ['Projects.xml', 'Signalisation_Areas.xml' ], ['SERVER_ID=%s' % server_id["ID"],'SERVER_LEVEL=%s' %levels(server_level),'IS_BOTH_LEVEL=%s' %is_both_level])
            if server_level != 'NA' :
                output_xslt('IDC/ParametersRIM46_%s%s.xml'%(server_id["ID"],levels(server_level)), 'bin_tools/ParametersRIM46.xsl', ['Stopping_Areas.xml','Train_Washings.xml','Terminus_Managements.xml','Projects.xml','Signalisation_Areas.xml' ], ['SERVER_LEVEL=%s' %levels(server_level), 'SERVER_ID=%s' %server_id["ID"]])    
            if levels(server_level) == '_LV2':
                output_xslt('IDC/Riyadh/StationRestriction_%s.xml'%server_id["ID"],'bin_tools/StationRestriction.xsl',['Blocks.xml','Stopping_Areas.xml','../bin/LocalesRoles.xml'],['SERVER_ID=%s'%server_id["ID"]])
                output_xslt('IDC/Riyadh/SCADAPlatformInfo_%s.xml'%server_id["ID"],'bin_tools/SCADAPlatformInfo.xsl',['Stations.xml','Blocks.xml','Evacuation_Zones_Sec.xml','Basic_Multitrack_Zones.xml','Elementary_Zones.xml','Stopping_Areas.xml','Platforms.xml'],['SERVER_ID=%s' %server_id["ID"]])
                output_xslt('IDC/Riyadh/SCADATrainInfo_%s.xml'%server_id["ID"],'bin_tools/SCADATrainInfo.xsl',['ATC_Equipments.xml','Trains_Unit.xml'],['SERVER_ID=%s' %server_id["ID"]])
                output_xslt('IDC/Riyadh/ISMTrainInfo_%s.xml'%server_id["ID"],'bin_tools/ISMTrainInfo.xsl',['ATC_Equipments.xml','Trains_Unit.xml'],[])
                output_xslt('IDC/Riyadh/WashPoint_%s.xml'%server_id["ID"],'bin_tools/WashPoint.xsl',['Train_Washings.xml','Stopping_Areas.xml','../bin/LocalesRoles.xml'],['SERVER_ID=%s' %server_id["ID"]])
                output_xslt('IDC/Riyadh/AntiBunching_%s.xml'%server_id["ID"],'bin_tools/AntiBunching.xsl',['Blocks.xml','Monitoring_Trains_Zones.xml','Inter_Stopping_Areas.xml','Stopping_Areas.xml','../bin/LocalesRoles.xml'],['SERVER_ID=%s' %server_id["ID"]])
                output_xslt('IDC/SigRule/SigRules_AntiBunching_%s.xml'%server_id["ID"],'bin_tools/SigRules_AntiBunching.xsl',['Blocks.xml','Monitoring_Trains_Zones.xml','Inter_Stopping_Areas.xml','Stopping_Areas.xml','../bin/LocalesRoles.xml'],['SERVER_ID=%s' %server_id["ID"]])
                output_xslt('IDC/Riyadh/EvacuationZone_%s.xml'%server_id["ID"],'bin_tools/EvacuationZone.xsl',['Blocks.xml','Basic_Multitrack_Zones.xml','Evacuation_Zones_Req.xml','Elementary_Zones.xml'],['SERVER_ID=%s' %server_id["ID"]])
                output_xslt('IDC/Riyadh/RiyadhPlatform_%s.xml'%server_id["ID"],'bin_tools/RiyadhPlatform.xsl',['Stopping_Areas.xml','Stations.xml','Platforms.xml','Evacuation_Zones_Sec.xml','Basic_Multitrack_Zones.xml','Elementary_Zones.xml'],['SERVER_ID=%s' %server_id["ID"]])
                output_xslt('IDC/Group/Group_RiyadhPlatform_%s.xml'%server_id["ID"],'bin_tools/Group_RiyadhPlatform.xsl',['Stopping_Areas.xml','Stations.xml','Platforms.xml','Evacuation_Zones_Sec.xml','Basic_Multitrack_Zones.xml','Elementary_Zones.xml'],['SERVER_ID=%s' %server_id["ID"]])
                output_xslt('IDC/Riyadh/RiyadhLV2_%s.xml'%server_id["ID"],'bin_tools/RiyadhLV2.xsl',[],['SERVER_ID=%s' %server_id["ID"]])
                output_xslt('IDC/Riyadh/ISMPlatformInfo_%s.xml'%server_id["ID"],'bin_tools/ISMPlatformInfo.xsl',['Evacuation_Zones_Sec.xml','Basic_Multitrack_Zones.xml','Elementary_Zones.xml','Platforms.xml','Stopping_Areas.xml', 'Blocks.xml','../bin/LocalesRoles.xml'],['SERVER_ID=%s' %server_id["ID"]])
                output_xslt('IDC/Riyadh/OPCClient_Riyadh_SRV_%s_LV2.xml'%server_id["ID"],'bin_tools/OPCClient_Riyadh_SRV.xsl',['SPKSs.xml','ATS_Equipments.xml','Signalisation_Areas.xml','Evacuation_Zones_Req.xml','Evacuation_Zones_Sec.xml','Stopping_Areas.xml','Trains_Unit.xml'],['SERVER_ID=%s' % server_id["ID"],'SERVER_LEVEL=%s' %levels(server_level),'IS_BOTH_LEVEL=%s' %(is_both_level)])
                output_xslt('IDC/Riyadh/OPCClient_Riyadh_SCADA_%s.xml'%server_id["ID"],'bin_tools/OPCClient_Riyadh_SCADA.xsl',['Urbalis_Sectors.xml','ATS_Equipments.xml','Platforms.xml','Depot_Stabling_Doors.xml','SPKSs.xml'],['SERVER_ID=%s' % server_id["ID"],'SERVER_LEVEL=%s' %levels(server_level),'IS_BOTH_LEVEL=%s' %(is_both_level)])
                output_xslt('IDC/Riyadh/Junction_%s.xml' % (server_id["ID"]), 'bin_tools/Junction.xsl', ['Junction_Areas.xml'], ['SERVER_ID=%s' % server_id["ID"]])
                output_xslt('IDC/Riyadh/TransferTrack_%s.xml' % (server_id["ID"]), 'bin_tools/TransferTrack.xsl', ['Stopping_Areas.xml','Train_Washings.xml'], ['SERVER_ID=%s' % server_id["ID"]])
                output_xslt('MMG/Common/CMMGCentralRiyadh_%s.xml' % (server_id["ID"]), 'bin_tools/CMMGCentralRiyadh.xsl', ['Junction_Areas.xml'], ['SERVER_ID=%s' % server_id["ID"]])
                output_xslt('IDC/Riyadh/AlarmRiyadhLV2_%s.xml' % (server_id["ID"]), 'bin_tools/AlarmRiyadhLV2.xsl', [], [])
                output_xslt('IDC/Group/Group_AlarmRiyadhLV2_%s.xml'%(server_id["ID"]), 'bin_tools/Group_AlarmRiyadhLV2.xsl', [], [])
                output_xslt('IDC/Riyadh/OPCMModule_%s.xml' % (server_id["ID"]), 'bin_tools/OPCMModule.xsl', [], [])
                output_xslt('IDC/Riyadh/RiyadhDepotConfiguration.xml', 'bin_tools/RiyadhDepotConfiguration.xsl', ['DepotModules.xml','Depot_Stabling_Doors.xml','Stopping_Areas.xml','Stablings_Location.xml'], [])
                output_xslt('IDC/Riyadh/DepotModule_%s.xml' % (server_id["ID"]),'bin_tools/DepotModule.xsl',['Stopping_Areas.xml','DepotModules.xml','../bin/LocalesRoles.xml'])
                output_xslt('IDC/Riyadh/DepotStablingDoors_%s.xml' % (server_id["ID"]),'bin_tools/DepotStablingDoors.xsl',['Stopping_Areas.xml','Depot_Stabling_Doors.xml','../bin/LocalesRoles.xml'])
  
            else:
                output_xslt('IDC/Riyadh/PSDStatus_%s.xml' % (server_id["ID"]), 'bin_tools/PSDStatus.xsl', ['Stopping_Areas.xml'], ['SERVER_ID=%s' % server_id["ID"]])
                output_xslt('IDC/SigRule/SigRules_PSDStatus_%s.xml' %(server_id["ID"]), 'bin_tools/SigRules_PSDStatus.xsl', ['Stopping_Areas.xml', 'Platforms.xml','Generic_ATS_IOs.xml'], ['SERVER_ID=%s' % server_id["ID"]])
                output_xslt('IDC/Riyadh/TPBerthTUView_%s.xml'%(server_id["ID"]), 'bin_tools/TPBerthTUView.xsl', ['Blocks.xml', 'Signalisation_Areas.xml', '../bin/LocalesRoles.xml' ], ['SERVER_ID=%s' % server_id["ID"],'SERVER_LEVEL=%s' %levels(server_level)])
                output_xslt('IDC/Riyadh/GenericAreaRiyadh_%s.xml'%server_id["ID"],'bin_tools/GenericAreaRiyadh.xsl',['Platforms.xml','Blocks.xml','Basic_Multitrack_Zones.xml','Evacuation_Zones_Req.xml','Elementary_Zones.xml','Stopping_Areas.xml','../bin/LocalesRoles.xml'],['SERVER_ID=%s'%server_id["ID"]])
                output_xslt('IDC/Riyadh/RiyadhLV1_%s.xml'%server_id["ID"],'bin_tools/RiyadhLV1.xsl',[])

    for cbi_id in eqt_file_data["CBI"]:
        output_xslt('IDC/Riyadh/WashingMachine_%s.xml' %(cbi_id["ID"]), 'bin_tools/WashingMachine.xsl', ['Projects.xml', 'Washing_Zones.xml', '../bin/LocalesRoles.xml', 'Signalisation_Areas.xml', 'Generic_ATS_IOs.xml'], ['CBI_ID=%s' %cbi_id["ID"]])
        output_xslt('IDC/SigRule/SigRules_WashingMachine_%s.xml' %(cbi_id["ID"]), 'bin_tools/SigRules_WashingMachine.xsl', ['SPKSs.xml','Signalisation_Areas.xml','Washing_Zones.xml', 'CBIs.xml', 'Generic_ATS_IOs.xml','System_Constraints_Constants.xml'], ['CBI_ID=%s' %cbi_id["ID"]])
    
    for zc_id in eqt_file_data["ZC"]:
        output_xslt('IDC/Riyadh/EvacuationZoneSecCause_%s.xml' %(zc_id["ID"]), 'bin_tools/EvacuationZoneSecCause.xsl', ['Evacuation_Zones_Sec.xml','Evacuation_Zones_Req.xml','Basic_Multitrack_Zones.xml','Elementary_Zones.xml', 'Blocks.xml', '../bin/LocalesRoles.xml'], ['ZC_ID=%s' %zc_id["ID"]])
        output_xslt('IDC/SigRule/SigRules_EvacuationZoneSecCause_%s.xml' %(zc_id["ID"]), 'bin_tools/SigRules_EvacuationZoneSecCause.xsl', ['SPKSs.xml','Evacuation_Zones_Sec.xml','Basic_Multitrack_Zones.xml','Elementary_Zones.xml', 'Blocks.xml', '../bin/LocalesRoles.xml'], ['ZC_ID=%s' %zc_id["ID"]])

    for ats_equipments in eqt_file_data["ATS_EQUIPMENTS"]:
	if(ats_equipments["ATS_EQUIP_TYPE"]=='Workstation'):
            #reg files
            comp_tem(base_dir+'tools/reg_file/TABcRiyadhConfig.reg', base_dir+'output/TABcRiyadh/ByComputer/TABcRiyadhConfig_%s.reg'%(ats_equipments["NAME"]), {"MACHINE_NAME":ats_equipments["NAME"]})
        if(ats_equipments["ATS_EQUIP_TYPE"]=='Data_Logger_Computer' or ats_equipments["ATS_EQUIP_TYPE"]=='Workstation'):
            #bat files
            comp_tem(base_dir+'tools/bat_file/PerfLog.bat', base_dir+'output/System/ByComputer/PerfLog_%s.bat'%(ats_equipments["NAME"]), {"MACHINE_NAME":ats_equipments["NAME"],"ATS_EQUIPMENT_TYPE":ats_equipments["ATS_EQUIP_TYPE"]})
            comp_tem(base_dir+'tools/bat_file/PerfLogBandwith.bat', base_dir+'output/System/ByComputer/PerfLogBandwith_%s.bat'%(ats_equipments["NAME"]), {"MACHINE_NAME":ats_equipments["NAME"], "ATS_EQUIPMENT_TYPE":ats_equipments["ATS_EQUIP_TYPE"]})
            #conf files
            comp_tem(base_dir+'tools/conf_file/PerfLog.conf', base_dir+'output/System/ByComputer/PerfLog_%s.conf'%(ats_equipments["NAME"]), {"ATS_EQUIPMENT_TYPE":ats_equipments["ATS_EQUIP_TYPE"]})
            comp_tem(base_dir+'tools/conf_file/PerfLogBandwith.conf', base_dir+'output/System/ByComputer/PerfLogBandwith_%s.conf'%(ats_equipments["NAME"]), {"ATS_EQUIPMENT_TYPE":ats_equipments["ATS_EQUIP_TYPE"]})
        if(ats_equipments["ATS_EQUIP_TYPE"]=='Central Server'):
            comp_tem(base_dir+'tools/conf_file/PerfLog.conf', base_dir+'output/System/ByComputer/PerfLog_%s.conf'%(ats_equipments["NAME"]), {"ATS_EQUIPMENT_TYPE":ats_equipments["ATS_EQUIP_TYPE"]})
            comp_tem(base_dir+'tools/conf_file/PerfLogBandwith.conf', base_dir+'output/System/ByComputer/PerfLogBandwith_%s.conf'%(ats_equipments["NAME"]), {"ATS_EQUIPMENT_TYPE":ats_equipments["ATS_EQUIP_TYPE"]})
            comp_tem(base_dir+'tools/bat_file/PerfLogBandwith.bat', base_dir+'output/System/ByComputer/PerfLogBandwith_%s.bat'%(ats_equipments["NAME"]), {"MACHINE_NAME":ats_equipments["NAME"], "ATS_EQUIPMENT_TYPE":ats_equipments["ATS_EQUIP_TYPE"]})
            comp_tem(base_dir+'tools/bat_file/PerfLog.bat', base_dir+'output/System/ByComputer/PerfLog_%s.bat'%(ats_equipments["NAME"]), {"MACHINE_NAME":ats_equipments["NAME"],"ATS_EQUIPMENT_TYPE":ats_equipments["ATS_EQUIP_TYPE"]})
        if ats_equipments["ATS_EQUIP_TYPE"] == 'Development_Computer':
            output_xslt('Deployment/ByComputer/Deployment_%s.xml'%ats_equipments["NAME"], 'bin_tools/Deployment.xsl',['Signalisation_Areas.xml', 'ATS_Equipments.xml'])
    after()
    print_action("Copying output files")
    after()
    copy_to_output()
    after()		
    print_action("Generation Done")
    
def levels(sl):
    if "LV" in sl:
        return sl
    else:
        return ""
        
def delivery():
    set_date()
    all()

if __name__ == '__main__':
    import multiprocessing  # @Reimport
    main(extra_options= options, parallel_ok=True, jobs=multiprocessing.cpu_count())
