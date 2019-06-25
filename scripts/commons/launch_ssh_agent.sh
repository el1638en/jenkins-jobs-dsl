#!/usr/bin/env bash
set +x
set -e

ssh_id_rsa_key_file=~/.ssh/id_rsa
passphrase=""

# Find an eventual ssh-agent and kill them
if [ "$SSH_AGENT_PID" != "" ];then
  eval `ssh-agent -k`
fi

if [ "$SSH2_AGENT_PID" != "" ];then
  kill $SSH2_AGENT_PID
fi

# Launch ssh agent
eval $(ssh-agent)
expect <<EOF
spawn ssh-add ${ssh_id_rsa_key_file}
expect eof
exit
EOF

# # Launch ssh agent
# eval $(ssh-agent)
# expect <<EOF
# spawn ssh-add ${ssh_id_dsa_key_file}
# expect "Enter passphrase for ${ssh_id_dsa_key_file}:"
# send "${passphrase}\n"
# expect eof
# exit
# EOF
