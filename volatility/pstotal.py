# pstotal
# Copyright (C) 2012 The SANS(tm) Institute
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

'''
Rewrite of Jesse Kornblum's pstotal plugin for Volatility 2.0

@author:        The SANS(tm) Institute
@license:       GNU General Public License 2.0 or later
@contact:       info@sans.org
@organization:  The SANS(tm) Institute

Amended by Sue Stirrup
   *  Default behaviour to display complete list of processes (process scan)
   *  Commandline option to display only processes hidden from process list (original behaviour)
   *  Hidden processes shown as TRUE in text output
   *  Dot rendering added
   *  Hidden processes rendered in red

Updated 2014.05.12 by Matt Anderson <matt.anderson@skewd.net>
   *  Update for volatility 2.3.1
'''

import filescan
#import volatility.commands as commands
import volatility.commands as commands
import volatility.utils as utils
import volatility.obj as obj
import volatility.win32.tasks as tasks
import pdb

class pstotal(commands.Command):
    ''' List processes in process scan but not process list if the --short option is set '''
    
    def __init__(self, config, *args):
        commands.Command.__init__(self, config, *args)
        self._config.add_option('SHORT', help = 'Interesting processes only', action = 'store_true')
    
    def render_text(self, outfd, data):
        processes = data[0]
	hidden = data[1]
        outfd.write(" Offset     Name             PID    PPID   PDB        Time created                 Time exited                  Hidden \n" + \
                    "---------- ---------------- ------ ------ ---------- ---------------------------- ---------------------------- ------- \n")

        for eprocess in processes:
		if hidden[processes[eprocess].obj_offset] == 1:
			hide = 'TRUE'
		else:
			hide = ' '
		outfd.write("0x{0:08x} {1:16} {2:6} {3:6} 0x{4:08x} {5:28} {6:28} {7:6}\n".format(
			processes[eprocess].obj_offset,
			processes[eprocess].ImageFileName,
			processes[eprocess].UniqueProcessId,
			processes[eprocess].InheritedFromUniqueProcessId,
			processes[eprocess].Pcb.DirectoryTableBase,
			processes[eprocess].CreateTime or '',
			processes[eprocess].ExitTime or '',
			hide))
				
    def render_dot(self, outfd, data):
        objects = set()
        links = set()
        processes = data[0]
        filling = data[1]
        
        for eprocess in processes:
            proc_offset = processes[eprocess].obj_offset
            label = "{0} | {1} | created\\n{2} |".format(processes[eprocess].UniqueProcessId,
                                         processes[eprocess].ImageFileName,
                                         processes[eprocess].CreateTime or 'not available')
            if processes[eprocess].ExitTime:
                label += "exited\\n{0}".format(processes[eprocess].ExitTime)
                options = ' style = "filled" fillcolor = "lightgray" '
            else:
                label += "running"
                options = ''
            if filling[proc_offset] == 1:
                options = ' style = "filled" fillcolor = "red" '
                           
            label = "{" + label + "}"
            objects.add('pid{0} [label="{1}" shape="record" {2}];\n'.format(processes[eprocess].UniqueProcessId,
                                                                            label, options))
            links.add("pid{0} -> pid{1} [];\n".format(processes[eprocess].InheritedFromUniqueProcessId,
                                                      processes[eprocess].UniqueProcessId))

        ## Now write the dot file
        outfd.write("digraph processtree { \ngraph [rankdir = \"TB\"];\n")
        for link in links:
            outfd.write(link)

        for item in objects:
            outfd.write(item)
        outfd.write("}")
    
    def calculate(self):
        eproc = {}
        found = {}
              
        # Brute force search for eproc blocks in pool memory
        address_space = utils.load_as(self._config, astype = 'physical')
        for offset in filescan.PoolScanProcess().scan(address_space):
            eprocess = obj.Object('_EPROCESS', vm = address_space, offset = offset)
            eproc[offset] = eprocess
            found[offset] = 1
        
        # Walking the active process list.
        # Remove any tasks we find here from the brute force search if the --short option is set.
        # Anything left is something which was hidden/terminated/of interest.
        address_space = utils.load_as(self._config)
        for task in tasks.pslist(address_space):
            phys = address_space.vtop(task.obj_offset)
            if phys in eproc:
                if self._config.SHORT :
                    del eproc[phys]
                    del found[phys]
                else:
                    found[phys] = 0
        
        ret = [eproc, found]

        return ret
