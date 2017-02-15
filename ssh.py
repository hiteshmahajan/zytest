from __future__ import print_function
import pexpect
import sys
import tempfile
from os import unlink

def ssh(host, cmd, user, key, timeout=30):   ##defining ssh fuction
   
    output_file = tempfile.NamedTemporaryFile(delete=False) #temporary file output and not to delete if after closing 
    option = ["-q", "-oStrictHostKeyChecking=no",
              "-oUserKnownHostsFile=/dev/null"]
    option.append("-o PreferredAuthentications=publickey") #passing options to skip verification and quite mode
    option.append('-f')
    options = " ".join(option) # combine options
    ssh_cmd = None
    ssh_cmd = 'ssh -i {0} {1}@{2} {3} "{4}"'.format(
              key, user, host, options, cmd)  # format for ssh

    child = pexpect.spawn(ssh_cmd, timeout=timeout) #interactive module for ssh 
    child.logfile = output_file # output file
    child.expect(pexpect.EOF) # exception
    child.close() # exit pexpect
    output_file.close() 

    read_file = open(output_file.name, 'rU') #read temp file 
    stdout = read_file.read() # standard o/p
    output_file.close() 
    read_file.close()
    unlink(output_file.name) # unlink the temp file
    print_output(host, stdout) # print current std o/p
    return stdout

def print_output(server, output): ## print defination
    print(server + ":\n")
    for line in output.split('\n')[1:]:
        print(line)

#Passing input to script
username = sys.argv[1] # passing username
keyfile = sys.argv[2] #path to keyfile
servers = sys.argv[3].split(',') # comma separated host
command = raw_input("> ") #commands to execute
while command != "quit": # to come out of shell use quit
	for each in servers: # execute for all servers passed to this script
		ssh(each,command,username,keyfile) 
	command = str(raw_input("> "))
print("session closed") # after quit

