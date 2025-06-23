#!/bin/bash
PRIVATE_KEY_DIR=/dev/shm/.ssh
PRIVATE_KEY_FILE=${PRIVATE_KEY_DIR}/id_ansible
# ensure output directory exists
mkdir -p $PRIVATE_KEY_DIR
# obtain the token
INFISICAL_TOKEN=$(infisical login --client-id=${INFISICAL_CLIENT_ID} --client-secret=${INFISICAL_CLIENT_SECRET} --method=universal-auth --plain)
# use the token to obtain the private key and write it to file
infisical secrets get --token=${INFISICAL_TOKEN} --projectId=${INFISICAL_PROJECT_ID} --plain OPENSSH_PRIVATE_KEY > $PRIVATE_KEY_FILE
# change the permissions to 0600 (required by ssh-add)
chmod 0600 $PRIVATE_KEY_FILE
# eval the ssh-agent's bourne-shell commands
eval $(ssh-agent -s)
# add the key to ssh-agent
ssh-add $PRIVATE_KEY_FILE
# and fade away - you were never there
rm $PRIVATE_KEY_FILE
rmdir $PRIVATE_KEY_DIR
# to infinity and beyond!
/opt/builder/bin/entrypoint dumb-init "$@"
