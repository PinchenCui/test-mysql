#!/bin/bash
cd ~/test-mysql/1022-normal
FileList=$(find . -iname "*.sql" -type f)
echo "**************************************************"
echo "Start!"
echo "Start time: $( date +%s )" > ~/op-recorder.txt
echo "waiting for collection start...."
while [ "$(pgrep sysdig)" = "" ]; do
sleep 0.5
done
for File in $FileList
do
echo "$File"
thisgap=$(( ( $RANDOM % 50 )  + 1  ))
RESULT=$(echo "$thisgap/10" | bc -l)
echo "Sleep $RESULT seconds..."
sleep $RESULT
sudo docker exec -i test-mysql mysql -uroot -ppinchen < $File 2> /dev/null
echo "$( date +%s )" >> ~/op-recorder.txt
if [[ "$(pgrep sysdig)" = "" ]]; then
echo "Collection is detected to be done..."
echo "Operation stopped!"
break
fi
done
