echo "ContainerName= $1, MonitoringTime= $2s, filename= $3.$4.txt, SampleCount=$5"

collect()
{
cat <<EOF > /home/auresearch/Pinchen-PhD/SampleData/new_test/$3.$4.txt
"Sender ID": 1,
"VM ID": $1,
"Vector":{
	"Source": "Sysdig",
	"Type": "Syscall",
}, 
EOF
echo "\"Timestamp": "", "Data": "\"" >> /home/auresearch/Pinchen-PhD/SampleData/1003/$3.$4.txt

sudo sysdig -M $2 -pc container.name=$1 >> /home/auresearch/Pinchen-PhD/SampleData/1003/$3.$4.txt
echo "\""} >> /home/auresearch/Pinchen-PhD/SampleData/1003/$3.$4.txt

cd /home/auresearch/Pinchen-PhD/DataParser/
python /home/auresearch/Pinchen-PhD/DataParser/parser.py "/home/auresearch/Pinchen-PhD/SampleData/new_test/$3.$4.txt"
echo "$3.$4 Done!"
}

echo "Start!"
Name=$1
Time=$2
Mode=$3
Num=$4
C=1
echo "$Name, $Time, $Mode, $Num"
while [ "$C" -le "$5" ]
do
collect $Name $Time $Mode $Num
Num=$((Num+1))
C=$((C+1))
done
