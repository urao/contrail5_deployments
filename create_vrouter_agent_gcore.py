#!/usr/bin/python

'''
This script will run as cron job to generate vrouter_agent core 
How to run this script as cron job, every 3 minutes
chmod +x <python_file>
*/3 * * * * <python_file_location>
'''

import logging, glob, subprocess
import os, re

def generateCore():
    """ Function to execute gcore command if string is found"""

    logfile = "/var/log/contrail/contrail-vrouter-agent.log"
    try:
        with open(logfile) as r:
            logger.debug("Searching for string the \"{}\" in file \"{}\"".format(searchstr, logfile))
            string_found = False
            for line in r:
                if searchstr in line and not string_found:
                    logger.debug("String found, Fetching vrouter_vrouter-agent_1 PID and generating gcore dump file in {} directory".format(crash_dir))
                    string_found = True
                    cmd = "pgrep -f ^%s" %pidprs_name
                    pid_vagent = execute(cmd, ignore_errors=True)
                    cmd = "docker exec vrouter_vrouter-agent_1 gcore -o %s %s" %(crash_dir+tempfile,str(pid_vagent))
                    execute(cmd, ignore_errors=True)
    except subprocess.CalledProcessError as e:
        output = e.message
        logger.debug(output)

def execute(command, ignore_errors=False):
    """ Function to execute shell command and return the output """

    pipe = subprocess.Popen(command, shell=True,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT,
                            close_fds=True)
    data = ""
    for line in pipe.stdout:
        data += line

    rc = pipe.wait()
    cwd = os.getcwd()
    if rc and not ignore_errors:
        print 'Error : Working directory : %s' % (cwd)
        print 'Error : Failed to execute command: %s\n%s' % (command, data)
        sys.exit(1)
    return data.strip()

def main_call():
    """ Main Function call to invoke the script """

    try:
        for root, _, files in os.walk(crash_dir):
            for f in files:
                if re.match(r'vrouter-agent-core.*', f):
                    logger.debug("Atleast one existing core file in {} found. This program will not run. Bye...!".format(crash_dir))
                    break
                else:
                    proceed()
            else:
                proceed()
    except Exception as e:
        output = e.message
        logger.debug(output)

def proceed():
    """ Function call to proceed if no core file is found """

    logger.debug("NO existing core file in {} found. This program will proceed...!".format(crash_dir))
    generateCore()


# main
tmp_dir = "/var/log/contrail/"
crash_dir = "/var/crashes/"
searchstr = "ensureCanWrite: Realloc size 0 FAILED"
tempfile = "vrouter-agent-core"
corereport = "core_file_generatereport.log"
pidprs_name = "/usr/bin/contrail-vrouter-agent"

logger = logging.getLogger()
Log_Format = "%(levelname)s %(asctime)s %(message)s"
logging.basicConfig(filename=tmp_dir+corereport,
                    level= logging.DEBUG,
                    format= Log_Format)
main_call()
