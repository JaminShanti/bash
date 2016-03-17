#!/usr/bin/env bash
##############################################################
#
#  Created On:  03/16/2016
#  Author:  Jamin Shanti
#  Purpose: Sample_Script.sh
#
###############################################################
echo "-------------------------------"
echo "ServerName: $(hostname)"
echo "$(cat /etc/*release)"  | egrep  'Oracle Solaris|Red Hat Enterprise Linux' | uniq | sed 's:    ::g'
echo "-------------------------------"


