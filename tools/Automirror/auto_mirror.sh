#!/bin/sh
#
# History:
# V5.1: 2013-02-08:Yufei Shi: Auto sync the BRANCHES list from buildmaster daily build list.
# V4.1: 2011-10-13:Yongyi: don't clean manifest.git before switching branch.
# V4: 2011-9-29:Horace: Support the restricted repositories (honeycomb),
#                       also replace 'set -o pipefail' with 'set -e'
# V3: 2011-3-29:Johnny: for initial repo using the first one in BRANCHES instead of master, as it still directs to AOSP
# V2: 2011-3-29:Johnny: don't do repo sync after creating the initial repository, as the manifest of master branch will connect to AOSP server to download code.
# V1: 2011-3-28:Johnny: initial code

set -e

VERSION=5.1

  LOCAL_REPO=default
  GIT_SERVER=ssh://shgit.marvell.com/git/android
  MANIFEST_REPO=${GIT_SERVER}/platform/manifest.git
  REPO_TOOL_REPO=${GIT_SERVER}/tools/repo.git
  BUILDMASTER=10.38.34.92
  BRANCHES=$(ssh $BUILDMASTER cat ~/buildbot/sandbox/master/master.cfg | awk -F'=|\"|\,' ' /timed.Nightly\(name=/ { print $8 } ')

PWD=$(pwd)
LOGFILE=$PWD/"mirror-$LOCAL_REPO.log"
LOCAL_REPO_FULLDIR=$PWD/$LOCAL_REPO

if [ ! -e $LOCAL_REPO_FULLDIR ] || [ ! -e $LOCAL_REPO_FULLDIR/.repo/manifests.git ]; then
  echo "Creating repository:$LOCAL_REPO_FULLDIR and sync the master branch" | tee -a $LOGFILE &&
  mkdir -p $LOCAL_REPO_FULLDIR | tee -a $LOGFILE &&
  cd $LOCAL_REPO_FULLDIR &&
  repo init -u $MANIFEST_REPO --mirror --repo-url ${REPO_TOOL_REPO} | tee -a $LOGFILE
fi 

if [ ! $? -eq 0 ]; then
  exit 1
fi

cd $LOCAL_REPO_FULLDIR 

for branch in $BRANCHES; do

  echo "" | tee -a $LOGFILE &&
  echo "[$(date)] start sync branch:$branch" | tee -a $LOGFILE &&

  while [ 1 ]; do
    repo init -b $branch 2>&1 | tee -a $LOGFILE
    if [ $? -eq 0 ]; then
      break
    else
      echo "[$(date)] error encounted in init branch $branch. retry in 10 seconds." | tee -a $LOGFILE
      sleep 10s
    fi
    done

  while [ 1 ]; do
    repo sync 2>&1 | tee -a $LOGFILE
    if [ $? -eq 0 ]; then
      echo "[$(date)] sync branch:$branch successfully." | tee -a $LOGFILE
      break
    else
      echo "[$(date)] error encounted in sync branch $branch. retry in 10 seconds." | tee -a $LOGFILE
      sleep 10s
    fi
  done
done
