

$NODENUM=$1
rm -rf raft-start.sh

echo "
set -u
set -e

mkdir -p qdata/logs
echo \"[*] Starting Constellation nodes\"
./constellation-start.sh
echo \"[*] Starting Ethereum nodes\"
set -v
ARGS=\"--nodiscover --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints\"
PRIVATE_CONFIG=qdata/c$NODENUM/tm.ipc nohup geth --datadir qdata/dd$NODENUM \$ARGS --permissioned --raftport 50401 --rpcport 22000 --port 21000 --unlock 0 --password passwords.txt 2>>qdata/logs/$NODENUM.log &" >raft-start.sh
chmod 777 raft-start.sh