#! command to create sin file
SIN_TOOLS_CREATE_HEADER=./vendor/semc/build/sin/create_sin_header
SIN_COMAND=./vendor/semc/build/sin/semcsc.py
FSCONFIG_FILE=./fsconfig-8GB-vbp.xml
COMMAND="$[SIN_TOOLS_CREATE_HEADER] System"
export $COMMAND
echo $OUT
echo $SIN_TOOLS_CREATE_HEADER
echo $SIN_COMAND
echo $FSCONFIG_FILE
echo $COMMAND
echo ${SIN_TOOLS_CREATE_HEADER}+${FSCONFIG_FILE}
. $SIN_TOOLS_CREATE_HEADER System
#echo "${SIN_TOOLS_CREATE_HEADER} System ${FSCONFIG_FILE} ${OUT}/system.si_"
#echo cat $OUT/system.img >> $OUT/system.si_
#echo $SIN_COMAND -c $FSCONFIG_FILE -p System -t external -i $OUT/system.si_ -o $OUT/system.sin