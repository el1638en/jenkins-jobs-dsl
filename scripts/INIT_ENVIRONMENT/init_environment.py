#!/usr/bin/env python

__author__ = 'Eric LEGBA'

import paramiko
import sys
import time
import os

# Get the command-line arguments
system_ip = os.environ['ADDRESS_IP_DNS']
system_username = os.environ['USERNAME']
system_ssh_password = os.environ['PASSWORD']
system_su_password = os.environ['ROOT_PASSWORD']

shell_command = "sh /home/"+system_username+"/install_sudo_and_user_deploy_environment.sh "+system_username+"\n"
shell_command_remove_script = "rm -f /home/"+system_username+"/install_sudo_and_user_deploy_environment.sh"+"\n"
shell_command_result = "#"

def send_string_and_wait(command):
    # Send the su command
    shell.send(command)

    # Wait a bit, if necessary
    time.sleep(1)

    # Flush the receive buffer
    receive_buffer = shell.recv(1024)

    # Print the receive buffer, if necessary
    print receive_buffer

def send_string_and_wait_for_string(command, wait_string):
    # Send the su command
    shell.send(command)

    # Create a new receive buffer
    receive_buffer = ""

    while not wait_string in receive_buffer:
        # Flush the receive buffer
        resp = shell.recv(1024)
        receive_buffer += resp
        print resp


# Create an SSH client
client = paramiko.SSHClient()

# Make sure that we add the remote server's SSH key automatically
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# Connect to the client
client.connect(system_ip, username=system_username, password=system_ssh_password)

# Create a raw shell
shell = client.invoke_shell()

# Send the su command
send_string_and_wait("su\n")

# Send the client's su password followed by a newline
send_string_and_wait(system_su_password + "\n")

# Send the install command followed by a newline and wait for the done string
send_string_and_wait_for_string(shell_command, shell_command_result)
# Remove the script shell program.
send_string_and_wait_for_string(shell_command_remove_script, shell_command_result)

# Close the SSH connection
client.close()
