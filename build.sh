#!/bin/bash

XPLANETDIR=/xplanet

# get cloud image
CLOUDSOURCE=http://xplanetclouds.com/free/local/clouds_2048.jpg
CLOUDFILE=${XPLANETDIR}/cloud.jpg
CLOUDOLDESTTIME=$(date -d 'now - 12 hours' +%s)

if [ ! -f "$CLOUDFILE" ]
then
 echo "No cloud picture, download it"
 curl ${CLOUDSOURCE} --output $CLOUDFILE
fi

CLOUDFILETIME=$(date -r "$CLOUDFILE" +%s)
if (( CLOUDFILETIME <= CLOUDOLDESTTIME )); then
 echo "Cloud file to old, get a new one"
 rm $CLOUDFILE
 curl ${CLOUDSOURCE} --output $CLOUDFILE
fi

# get tle files
TLESOURCE=http://www.celestrak.com/NORAD/elements/stations.txt
TLEFILE=${XPLANETDIR}/iss.tle
TLEOLDESTTIME=$(date -d 'now - 1 hours' +%s)

if [ ! -f "$TLEFILE" ]
then
 echo "No tle file, download it"
 curl ${TLESOURCE} --output $TLEFILE
fi

TLEFILETIME=$(date -r "$TLEFILE" +%s)
if (( TLEFILETIME <= TLEOLDESTTIME )); then
 echo "TLE file to old, get a new one"
 rm $TLEFILE
 curl $TLESOURCE --output $TLEFILE
fi
cp ${XPLANETDIR}/iss.tle /etc/xplanet/satellites/iss.tle

xplanet -num_times 1 --output ${XPLANETDIR}/xplanet.jpg -geometry 1289x1024 -projection rectangular -config=/xplanet.conf
