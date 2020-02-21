docker exec -i test-mysql mysql -uroot -ppinchen < init.sql
docker exec -i test-mysql chmod -R +rwx /tmp/Virus
docker exec -i test-mysql service ssh start
#docker cp /home/vm-0/Documents/Virus/. test-mysql:/tmp/Virus/
#docker cp ./main test-mysql:/tmp/escape
#docker cp ./rs test-mysql:/tmp/rs
