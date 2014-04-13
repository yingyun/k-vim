#!/bin/bash
   
LABEL=$1
   
if [ -z $WORKSPACE ];then
  WORKSPACE=$PWD
fi
   
cd $WORKSPACE
LABEL_EXIST=$(repository listsnapshots -t protected | grep -e "^${LABEL}$")
if [ ${LABEL_EXIST} ]; then
  #PROTECTED="-t protected"
  PROTECTED=""
else
LABEL_EXIST=$(repository listsnapshots | grep -e "^${LABEL}$")    
  if [ -z ${LABEL_EXIST} ]; then
    echo "ERROR: Label $LABEL doesn't exist" >&2
    exit 1
  fi
fi
   
repository getpackage build-metadata $LABEL $PROTECTED
MANIFEST_BRANCH=$(dpkg-deb -f build-metadata_${LABEL}_all.deb | grep XB-SEMC-Manifest-Branch: | sed 's/XB-SEMC-Manifest-Branch: //' )
echo "Manifest branch for label $LABEL: $MANIFEST_BRANCH"
   
echo "Initiating $MANIFEST_BRANCH..."
repo init -u git://review.sonyericsson.net/platform/manifest -b $MANIFEST_BRANCH
   
dpkg -x build-metadata_${LABEL}_all.deb .
mv manifest_static.xml ${LABEL}_manifest_static.xml
cp ${LABEL}_manifest_static.xml .repo/manifests/default.xml
   
if [ "$2" = "sync" ]; then
  echo "Start syncing $MANIFEST_BRANCH..."
  repo sync -j10
fi

