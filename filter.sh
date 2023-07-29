#!/bin/bash
set +x
DTE=$(date "+%d-%m-%Y-v%H%m%s")
startdate=yyyy/mm/dd
enddate=yyyy/mm/dd
start_time=hh:mm
end_time=hh:mm
keyword=anyword
BKT=storagebucketpath
i=$start_time
i1=$(sed 's/.\{3\}$//' <<< "$i")   #splitting start hour from time input
#echo "$i1"
j=$end_time
j1=$(sed 's/.\{3\}$//' <<< "$j")   #splitting end hour from time input
#echo "$j1"
k=23
startdate=$(date -d $startdate +%s)
enddate=$(date -d $enddate +%s)
d="$startdate"
#echo StartDate: $startdate
#echo EndDate: $enddate
#echo StartTime: $start_time
#echo EndTime: $end_time
#echo Keyword: $keyword
while [[ $d -le $enddate ]]
do
 declare -A myDate=$(date -d @$d +%Y/%m/%d)
 echo $myDate      
  if [[ $d == $enddate ]]; then
    k=$j1
  fi
   for a in $(seq $i1 $k)
   {
    if [ $a -le 09 ]; then
     output=$(gsutil cat -h gs://logbucketname/foldername/"$myDate"/"0$a:00:00_0$a:59:59*" | egrep -i "$keyword")
     echo $output >> $"/tmp/localfolder/filename-$DTE"
    else
     output=$(gsutil cat -h gs://logbucketname/foldername/"$myDate"/"$a:00:00_$a:59:59*" |  egrep -i "$keyword")
     echo $output >> $"/tmp/localfolder/filename-$DTE"
    fi
   }
 date -d @$d +%Y/%m/%d
 d=$(( $d + 86400 ))
 i1=00
done
 gsutil cp -r /tmp/localfolder/filename-$DTE gs://anotherbucketname/foldername/
 echo "please use this link to download log output and save it as .txt format"
 echo "https://console.cloud.google.com/storage/browser/anotherbucketname/foldername/filename-$DTE"
