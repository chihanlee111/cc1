#!/bin/bash
NODENUM=$1
IPADDR=$2
OTHERIP=$3
echo "SET nodenumber=$1, IP Address=$2, OtherIP=$3"
#rm -rf qdata
#mkdir -p qdata/logs

source stop.sh

source raft-init$NODENUM.sh
./create-constellation.sh "$NODENUM" "$IPADDR" "$OTHERIP"
#####source raft-start$NODENUM.sh
#####start of raft-start.sh
set -u
set -e

mkdir -p qdata/logs
echo "[*] Starting Constellation nodes"
#########constellation-start.sh

source constellation-start.sh

########end of constellation-start.sh file
echo "[*] Starting Ethereum nodes"
set -v
ARGS="--nodiscover --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"
PRIVATE_CONFIG=qdata/c$NODENUM/tm.ipc nohup geth --datadir qdata/dd$NODENUM $ARGS --permissioned --raftport 50402 --rpcport 22001 --port 21001 2>>qdata/logs/$NODENUM.log 
set +v

echo
echo "All nodes configured. See 'qdata/logs' for logs, and run e.g. 'geth attach qdata/dd1/geth.ipc' to attach to the first Geth node."
echo "To test sending a private transaction from Node 1 to Node 7, run './runscript script1.js'"
exit
#####end of raft-start.sh



