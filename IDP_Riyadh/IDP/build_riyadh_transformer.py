#!/usr/bin/env python2
# -*- coding: utf8 -*-
import os.path
from lib_common.fabricate import *  # @UnusedWildImport
import lib_common.build_gen  # @UnusedImport
lib_common.build_gen.base_dir = 'RIYADH_TRANSFORMER/'
from lib_common.build_gen import *  # @UnusedWildImport
lib_common.build_gen.own_order=True
import stat

setup(depsname='.deps_riyadh_transformer')

def bin_xslt(out_f, xsl_f, in_f=[], param=[], **run_args):
    out_f = os.path.join("bin", out_f) 
    in_f.insert(0, '../bin/versions.xml')
    run_xslt(out_f, xsl_f, in_f, param, **run_args)

def all():  # @ReservedAssignment
    remove_read_only()
    import_input_files(authorized_file_regex = ['^(ATS_SUBSYSTEM_DATABASE)_.*','^(ATS_PARAMETER_DESCRIPTION)_.*','(ICONIS_KERNEL_PARAMETER_DESCRIPTION).*'])
    after()
    prepare_input(lib_common_templates=['group_info_riyadh', 'LocalRoles'],
           tables_files=['ATS_SUBSYSTEM_DATABASE.xml', 'ATS_PARAMETER_DESCRIPTION.xml'],
           information_add = [('group_info_riyadh', [])])
    run('python','lib_common/copy_file.py', "lib_common/lib_xslt.xsl", base_dir+"bin_tools/")
    mkdir(base_dir+'bin/separate', isdir=True)
    after()
    # Generate versions files
    gen_versions_file()
    # Transform XML files and run python scripts
    print_action("separate/Transform XML files and run python scripts")
    after()
    bin_xslt('separate/TrackPortions_pass1.xml', 'bin_tools/TrackPortion_pass1.xsl', ['Stopping_Areas.xml','Platforms.xml','Blocks.xml', 'ATC_Equipments.xml', 'Signalisation_Areas.xml'], [])
    after()
    bin_xslt('separate/TrackPortions.xml', 'bin_tools/TrackPortion.xsl', ['../bin/separate/TrackPortions_pass1.xml','ICONIS_KERNEL_PARAMETER_DESCRIPTION.xml'], [])
    after()
    bin_xslt('separate/TrackPortions_Connections.xml', 'bin_tools/TrackPortions_Connections.xsl', ['../bin/separate/TrackPortions_pass1.xml', 'ICONIS_KERNEL_PARAMETER_DESCRIPTION.xml'], [])
    after()
    run_xslt('bin/separate/ICONIS_KERNEL_PARAMETER_DESCRIPTION_RIYADH.xml', 'bin_tools/finalout_pass1.xsl', ['ICONIS_KERNEL_PARAMETER_DESCRIPTION.xml','../bin/separate/TrackPortions.xml','../bin/separate/TrackPortions_Connections.xml'], [])	
    after()
    run_xslt('output/ICONIS_KERNEL_PARAMETER_DESCRIPTION.xml', 'bin_tools/finalout.xsl', ['../bin/separate/ICONIS_KERNEL_PARAMETER_DESCRIPTION_RIYADH.xml'], [])	
    after()
    copy_to_output()
    after()
    print_action("Generation Done")
        
def remove_read_only():
    """
    Remove read-only mode for all the files in the project folder
    """
    for root, _, files in os.walk(os.getcwd()):
        for file_name in files:
            fpath = os.path.join(root,file_name)
            if not os.chmod(fpath, stat.S_IWRITE):
                os.chmod(fpath, stat.S_IWRITE)

def delivery():
    set_date()
    all()

if __name__ == '__main__':
    import multiprocessing  # @Reimport
    main(extra_options= options, parallel_ok=True, jobs=multiprocessing.cpu_count())
