#PowerShell
#
#Robocopy is a conmmand line diretory and/or file replication.
#Need enviroment variables:
#        MIRROR_DIR:                        Destination Dir (Please define it by yourself)
#        MIRROR_SOURCE:                     Source Directory (\\sh-srv06\common\ImageDatabase)
#        Set-ExecutionPolicy RemoteSigned   Please open a cmd by admin and add signed to trust the publisher
#History
#V1 2014-01-27: yfshi: initial code

$LOGFILE="$(get_date).log"
$MIRROR_DIR="D:\mirror_dir"
$MIRROR_SOURCE="\\sh-srv06\common\ImageDatabase"
$TMP_LOG=".tmp.log"

Function get_date(){
  echo $(date "+%Y-%m-%d-%H-%M-%S")
}

echo "[$(get_date)]: Start to mirror the files." 2>&1 | tee $TMP_LOG
cat $TMP_LOG  2>&1 | Out-File -append $LOGFILE

robocopy $MIRROR_SOURCE $MIRROR_DIR * /e 2>&1 | tee $TMP_LOG
cat $TMP_LOG  2>&1 | Out-File -append $LOGFILE

$ret=$?
if(!$ret){
  echo "[$(get_date)]: Auto mirror is failure." 2>&1 | tee $TMP_LOG
  cat $TMP_LOG  2>&1 | Out-File -append $LOGFILE
  exit 1
}

echo "[$(get_date)]: Auto mirror is done." 2>&1 | tee $TMP_LOG
cat $TMP_LOG  2>&1 | Out-File -append $LOGFILE
exit 0