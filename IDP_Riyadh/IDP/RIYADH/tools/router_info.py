#!/usr/bin/env python2
# -*- coding: utf8 -*-
# Compute address with mask
import argparse
import yaml
import sys
import socket
import struct
import lxml.etree as etree

def ip2int(addr):                                                               
    return struct.unpack("!I", socket.inet_aton(addr))[0]                       

def int2ip(addr):                                                               
    return socket.inet_ntoa(struct.pack("!I", addr))       

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('in_f', type=argparse.FileType('r'), default=sys.stdin)
    parser.add_argument('out_f', type=argparse.FileType('w'), default=sys.stdout)
    args = parser.parse_args()

    file_data = yaml.load(args.in_f)

    root = etree.Element("ROOT")
	
    for ats_id, ip_list in file_data.iteritems():
	ats_fep = etree.SubElement(root, "ATS_FEP") 
	ats_fep.set("ID", str(ats_id))
	if ip_list:
            for ip in ip_list:
                ip_with_mask = int2ip(ip2int(ip['Addr'])&ip2int(ip['Mask']))
                # Check if the node is not already generated
                if not(ats_fep.xpath("WITH_MASK[@IP='%s']" % ip_with_mask)):
                    with_mask = etree.SubElement(ats_fep, "WITH_MASK")
                    with_mask.set("IP", ip_with_mask)
                    with_mask.set("MASK", ip['Mask'])

    args.out_f.writelines(etree.tostring(root, pretty_print=True))
    args.out_f.close()
    args.in_f.close()
    

if __name__ == "__main__":
    main()
