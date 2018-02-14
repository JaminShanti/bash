#!/bin/bash
#######################################################################################
# Script to get all repos on bitbucket and clone / pull the master branch #############
########################################################################################



# Script Defaults
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
logfile=/archive_workspace/logs/backupbitbucket.log
REPO="ssh://git@bitbucket.org/${bitbucketUser}/"
BACKUPDIR="${BASEDIR}/BACKUP"
Application_User=$( whoami )
HOST=$( hostname )
APPLICATION="$( basename "$0" )"
bitbucketUser="DEFAULT"
bitbucketapiKey="DEFAULT"
project_name="DEFAULT"

####################################################################################
#
# Log File setup
#
####################################################################################
runInitializeLogfile()
{
  if [ -f  ${logfile} ]
  then
    runLogPrint "Application log file exist" "INFO"
  else
    mkdir -p /archive_workspace/logs
    touch ${logfile}
    runLogPrint "Creating Deploy Log, since it does not exist" "INFO"
    if [ $? == 0 ]; then
      runLogPrint "Successfully created deploy log file, ${logfile}" "INFO"
    else
      runLogPrint "Error creating the deploy log file, check the directory ${logfile} exist and ${Application_User} is got right permission and ownership" "ERROR"
    fi
  fi

}

####################################################################################
#
# Verbose Logger
#
####################################################################################
runLogPrint()
# logging function for ERROR, WARN, INFO, and DEBUG
{
  # Throws Log Statement if not classified as ERROR Level.
  if [[ $2 == "" ]]
  then
    loglevel="ERROR"
  else
    loglevel=$2
  fi
  echo  "$( date "+%m/%d/%y %H:%M:%S.%3N" )   ${loglevel}   ${HOST}   ${Application_User}   ${1}"
  echo  "$( date "+%m/%d/%y %H:%M:%S.%3N" )  LEVEL=${loglevel}  HOST=${HOST}  APPLICATION-USER=${Application_User}  APPLICATION=${APPLICATION}  MESSAGE=${1}  " >> ${logfile}
}

####################################################################################
#
# Validate and set script arguments
#
####################################################################################
runValidateSetArgs()
{
  ################################# Determine the Arguments ########################################
  runLogPrint "Base Directory: ${BASEDIR}" "INFO"
  runLogPrint "Backup Directory: ${BACKUPDIR}" "INFO"
  runLogPrint "logfile: ${logfile}" "INFO"
  runLogPrint "BitBucket Owner: ${REPO}" "INFO"

}




####################################################################################
#
# Exit program - display error messages if needed
#
####################################################################################
runExit()
{
  runLogPrint "$( date "+%m/%d/%y %H:%M:%S.%3N" )" "INFO"
  if [[ ${GRC} -gt 0 ]]
  then
    runLogPrint "#######################################################################" "ERROR"
    runLogPrint "               !!! Errors Detected During Deploy !!!" "ERROR"
    runLogPrint "        Please review the output of this script for error messages." "ERROR"
    runLogPrint "Re-run this script for the apps that failed. This can be done with the -a flag." "ERROR"
    runLogPrint "#######################################################################" "ERROR"
    exit ${GRC}
  else
    runLogPrint "Command Completed Successfully..." "INFO"
    exit 0
  fi
}



####################################################################################
#
# Main driver for script
#
####################################################################################
runMain()
{
  runLogPrint "Removing ${BASEDIR}/repodata ${BASEDIR}/repo ${BASEDIR}/repotemp" "DEBUG"
  rm -f ${BASEDIR}/repodata
  rm -f ${BASEDIR}/repo
  rm -f ${BASEDIR}/repotemp

  ####### Get the List of Repos from Bitbucket############################################
  runLogPrint "Creating ${BASEDIR}/repodata from api.bitbucket.org" "INFO"
  curl --silent --request GET -H "Authorization: Basic ${bitbucketapiKey}" "https://api.bitbucket.org/2.0/repositories/${bitbucketUser}?pagelen=100" >> ${BASEDIR}/repodata
  totalsize=$( cat ${BASEDIR}/repodata | jq  '.size' )
  runLogPrint "Total Size of repodata: $totalsize" "INFO"
  pages=$(( totalsize / 100))
  remainder=$(( totalsize % 100))
  if [ ${remainder} > 0 ]; then
    pages=$((pages + 1))
  fi
  runLogPrint "Total Pages of repodata: ${pages}" "INFO"
  if [ pages > 2 ]; then
    curl --silent --request GET -H "Authorization: Basic ${bitbucketapiKey}" "https://api.bitbucket.org/2.0/repositories/${bitbucketUser}?pagelen=100&page=2" >> ${BASEDIR}/repodata
  else
    curl --silent --request GET -H "Authorization: Basic ${bitbucketapiKey}" "https://api.bitbucket.org/2.0/repositories/${bitbucketUser}?pagelen=100&page=[2-$pages]" >> ${BASEDIR}/repodata
  fi
  allreponames=$( cat ${BASEDIR}/repodata | jq -r '. ["values"] [].name' | sed 's/\\n/\n/g; s/\\t/\t/g' )
  echo ${allreponames} >> ${BASEDIR}/repotemp
  runLogPrint "Repo Full List" "DEBUG"
  runLogPrint "cat ${BASEDIR}/repo" "DEBUG"
  cat ${BASEDIR}/repotemp | tr ' ' '\n' >> ${BASEDIR}/repo
  if [ $? -eq 0 ];
  then
    runLogPrint "Extracted Repo Information succesfully" "INFO"
  else
    runLogPrint  "Unable to extract the Repo's" "FATAL"
    exit 100
  fi
  runLogPrint "$( cat ${BASEDIR}/repo )" "DEBUG"
  #################################################################################################
  ############################ Clone or Pull from the Repo's as needed ############################

  if [ ! -d ${BACKUPDIR} ]; then
    cd ${BASEDIR}
    mkdir BACKUP
    if [ $? == 0 ]; then
      runLogPrint "Succesfully created the back up directory" "INFO"
    else
      runLogPrint "Unable to create the back up directory" "FATAL"
      exit 100
    fi
  else
    runLogPrint "Backup Directory Already exist" "INFO"
  fi
  for i in $(cat ${BASEDIR}/repo); do
    if [ ! -d "${BACKUPDIR}/${i}" ]; then
      runLogPrint "cloning ${REPO}${i}" "INFO"
      cd ${BACKUPDIR}
      git clone ${REPO}${i}
      if [ $? == 0 ]; then
        runLogPrint "Successfully cloned the repo ${i}" "INFO"
      else
        runLogPrint "Unable to Clone the Repo ${i}" "ERROR"
      fi
    else
      runLogPrint "Backup Exist: Pulling ${REPO}${i}" "INFO"
      cd ${BACKUPDIR}/${i}
      git pull
      if [ $? == 0 ]; then
        runLogPrint "Successfully pulled the latest from Remote for repo ${i}" "INFO"
      else
        runLogPrint "Unable to Pull the repo ${i}" "ERROR"
      fi
    fi
    runLogPrint "syncing to ${BACKUPDIR}/${i} to s3://s3backups-${project_name}/bitbucketbackup/${i}" "INFO"
    aws s3 sync ${BACKUPDIR}/${i} s3://s3backups-${project_name}/bitbucketbackup/${i}
  done

}


####################################################################################
#                               EXECUTE PROGRAM
####################################################################################
runInitializeLogfile
runLogPrint "$( date "+%m/%d/%y %H:%M:%S.%3N" )" "INFO"
runLogPrint  "$( basename "$0" )" "INFO"
runValidateSetArgs
runMain
runExit
