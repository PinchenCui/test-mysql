echo "ContainerName= $1, MonitoringTime= $2s, filename= $3.$4.txt, SampleCount= $4"

collect()
{
cat <<EOF > ~/SQL-Dataset/$3.$4.txt
"Sender ID": 1,
"VM ID": $1,
"Vector":{
	"Source": "Sysdig",
	"Type": "Syscall",
}, 
EOF
echo "\"Timestamp": "", "Data": "\"" >> ~/SQL-Dataset/$3.$4.txt
sudo sysdig -M $2 -pc container.name=$1 >> ~/SQL-Dataset/$3.$4.txt &
echo "start collection..."
wait
echo "\""} >>  ~/SQL-Dataset/$3.$4.txt

cd  ~/Downloads/SQLBehavior/DataParser/
echo "Staring Parsing Collected Data..."
#sudo python parser.py "/home/vm-0/SQL-Dataset/$3.$4.txt"
echo "Parsing Skipped!"
}

echo "**************************************************"
echo "Start!"
Name=$1
Time=$2
Mode=$3
Num=$4
C=1
echo "$Name, $Time, $Mode, $Num"
collect $Name $Time $Mode $C
C=$((C+1))
sleep 3

