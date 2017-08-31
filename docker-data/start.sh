supervisord
sleep 3

STATUS=$(echo "CLUSTER INFO" | redis-cli  -p 7000 | grep "cluster_state:ok"| wc -l)
if [ $STATUS -eq 1 ];
then
    exit
fi

IP=$DOCKER_REDIS_CLUSTER_IP

if [ -z "$IP" ]; then
  echo "DOCKER_REDIS_CLUSTER_IP not provided. Assuming eth0 interface address"
  IP=`ifconfig | grep "eth0" -A1 | grep "inet addr:1" | cut -f2 -d ":" | cut -f1 -d " "`
fi

echo "yes" | ruby /redis/src/redis-trib.rb create --replicas 1 ${IP}:7000 ${IP}:7001 ${IP}:7002 ${IP}:7003 ${IP}:7004 ${IP}:7005
tail -f /var/log/supervisor/redis-1.log
