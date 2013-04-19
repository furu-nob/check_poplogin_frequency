#!/bin/sh

#LOGPATH='./test_log'
LOGPATH='/var/log/maillog'

IFS=$'\n'

seconds='10'
hit_count='9'

#pop3conn_file=`mktemp /tmp/pop3conn_file_XXXXXX`
pop3conn_file='./pop3conn_file'
badpop3_file=`mktemp /tmp/badpop3_file_XXXXXX`
trap "rm $pop3conn_file $badpop3_file $clean_pop3conn_file; exit" 1 2 3 15


clean_pop3conn (){
  nowtime=$1
  now_before_time=`expr $nowtime - $seconds`
  clean_pop3conn_file=`mktemp /tmp/clean_pop3conn_file_XXXXXX`
  pop3conn_list=`cat $pop3conn_file`
  for LINE in $pop3conn_list
  do
    UNIXTIME=`echo $LINE | cut -d" " -f1`
    USER_DESTIP=`echo $LINE | cut -d" " -f2,3`
    if [ $UNIXTIME -gt $now_before_time ]
    then
      echo $UNIXTIME $USER_DESTIP >> $clean_pop3conn_file
    fi
  done
  mv $clean_pop3conn_file $pop3conn_file
}
    

FORMAT_LOG (){
  GREPLOG=`grep login $LOGPATH`
  
  for LINE in $GREPLOG
  do
    # DATE=`echo $LINE | cut -d" " -f1,2,3`
    USER=`echo $LINE | cut -d" " -f8`
    DESTIP=`echo $LINE | cut -d" " -f11`
    #UNIXTIME=`date +%s --date $DATE`
    UNIXTIME=`echo $LINE | cut -d" " -f6 | cut -d'.' -f 1`
    echo $UNIXTIME $USER $DESTIP
  done
}

count_badpop3 (){
  check_badip=$1
  count=`cat $pop3conn_file | grep $check_badip | wc -l | sed -e "s/^\ *//" | tr -d "\n"`
  if [ -n $count  ]
  then 
    if [ "$count" -gt $hit_count ]
    then
      echo $UNIXTIME $USER_DESTIP
    fi
  fi
}


FORMATEDLOG=`FORMAT_LOG`

for FORMATEDLINE in $FORMATEDLOG
do
  UNIXTIME=`echo $FORMATEDLINE | cut -d" " -f1`
  USER=`echo $FORMATEDLINE | cut -d" " -f2`
  DESTIP=`echo $FORMATEDLINE | cut -d" " -f3`
  clean_pop3conn $UNIXTIME
  count_badpop3 $DESTIP
  echo $FORMATEDLINE >> $pop3conn_file
done

IFS=$' \t\n'

