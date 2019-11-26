#!/usr/bin/env python2
# -*- coding: utf8 -*-
# Generate alias names
import argparse
import sys
import re
import lxml.etree as etree

NMSPACE = "http://www.systerel.fr/Alstom/IDP"
NMSPACE_DICT =  {'sys' : NMSPACE}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('in_f', type=argparse.FileType('r'), default=sys.stdin)
    parser.add_argument('out_f', type=argparse.FileType('w'), default=sys.stdout)
    args = parser.parse_args()
    
    xml_tree = etree.parse(args.in_f)
    nodes = []
    root = xml_tree.getroot()
    doc = etree.Element(root.tag,nsmap=NMSPACE_DICT)

    #Get all objects node name that use alias name
    for child_node in root.iterfind("Alias_Rules/Alias_Rule/Uevol_Class"):
      alias_list = []
      parent = etree.SubElement(doc, child_node.text + 's')
      #Get the list of alias field to apply for a given object
      for al in child_node.iterfind("../Alias_Field_ID_List/Alias_Field_ID"):
          alias_list.append(al.text)
      #Go through all object node
      for node in root.iter(child_node.text):
        child = etree.SubElement(parent, child_node.text)
        child.set("Name", node.get('Name'))
        child.set("ID", node.get('ID'))
        alias = etree.SubElement(child, '{%s}%s'%(NMSPACE, "alias"))
        value = ""
        #Interpret the fields
        for al_id in alias_list:
          for val in root.iterfind("Alias_Fields/Alias_Field[@ID='%s']/Value"%al_id):
            tmp = ""
            if val.text == "$ID":
              tmp =  node.get('ID')
            elif val.text == "$StationName":
              tmp =  node.get('Name')
            elif "replace" in val.text.lower():
              search = re.findall('"(\w+)","(\w*)"', val.text)
              tmp = node.get('Name')
              for pattern, replace in search:
                tmp = tmp.replace(pattern, replace)
            else:
              tmp = val.text

            value = value + tmp
        alias.set("name", value)

    args.out_f.writelines(etree.tostring(doc, pretty_print=True))
    args.out_f.close()


    
  
if __name__ == "__main__":
   main()

