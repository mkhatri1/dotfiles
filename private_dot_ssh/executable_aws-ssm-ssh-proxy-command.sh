#!/usr/bin/env sh
set -e

################################################################################
#
# For documentation see https://github.com/qoomon/aws-ssm-ssh-proxy-command
#
################################################################################

instance_id="${1}"
ssh_user="$2"
ssh_port="$3"
ssh_public_key_path="$4"

arr=(${instance_id//--/ })

instance_id=${arr[0]}
export AWS_DEFAULT_REGION="${arr[1]}"

if [[ ! -z ${arr[2]} ]]; then
    export AWS_PROFILE="${arr[2]:-$AWS_PROFILE}"
fi

>/dev/stderr echo "Add public key ${ssh_public_key_path} for ${ssh_user} at instance ${instance_id} for 10 seconds"
ssh_public_key="$(cat "${ssh_public_key_path}")"
aws ssm send-command \
  --instance-ids "${instance_id}" \
  --document-name 'AWS-RunShellScript' \
  --comment "Add an SSH public key to authorized_keys for 10 seconds" \
  --parameters commands="
  \"
    set -eu
    
    mkdir -p ~${ssh_user}/.ssh && cd ~${ssh_user}/.ssh

    authorized_key='${ssh_public_key} ssm-session'
    
    echo \\\"\${authorized_key}\\\" >> authorized_keys
    
    sleep 10
    
    (grep -v -F \\\"\${authorized_key}\\\" authorized_keys || true) > authorized_keys~
    mv authorized_keys~ authorized_keys
  \"
  "

>/dev/stderr echo "Start ssm session to instance ${instance_id}"
aws ssm start-session \
  --target "${instance_id}" \
  --document-name 'AWS-StartSSHSession' \
  --parameters "portNumber=${ssh_port}"

