#!/usr/bin/env bash
##############################################################
#
#  Created On:  03/16/2016
#  Author:  Jamin Shanti
#  Purpose: Sweep_Servers.sh
#
###############################################################
set -e
myname=myUserID
source set_env_serverlist.sh

for LIST in "${LIST_NAMES[@]}"
do
    echo "-------------------------------"
    echo "${LIST} Environment..."
    looparray="$LIST[@]"
    for server in "${!looparray}"
    do
        ssh -o StrictHostKeyChecking=no ${myname}@${server} 'bash -s' < Sample_Script.sh
    done
done
