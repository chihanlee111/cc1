#!/bin/bash
NODENUM=$1
IPADDR=$2
OTHERIP=$3
echo "SET nodenumber=$1, IP Address=$2, OtherIP=$3"
#rm -rf qdata
#mkdir -p qdata/logs
source stop.sh
source raft-init$NODENUM.sh
#####source raft-start$NODENUM.sh
#####start of raft-start.sh
set -u
set -e
mkdir -p qdata/logs
echo "[*] Starting Constellation nodes"
#########constellation-start.sh
set -u
set -e
DDIR="qdata/c$NODENUM"
mkdir -p $DDIR
mkdir -p qdata/logs
cp "keys/tm$NODENUM.pub" "$DDIR/tm.pub"
cp "keys/tm$NODENUM.key" "$DDIR/tm.key"
rm -f "$DDIR/tm.ipc"
CMD="constellation-node --url=https://$IPADDR:900$NODENUM/ --port=900$NODENUM --workdir=$DDIR --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key --othernodes=https://$OTHERIP:9
001/"
echo "$CMD >> qdata/logs/constellation$NODENUM.log 2>&1 &"
$CMD >> "qdata/logs/constellation$NODENUM.log" 2>&1 &
DOWN=true
while $DOWN; do
    sleep 0.1
    DOWN=false
        if [ ! -S "qdata/c$NODENUM/tm.ipc" ]; then
                        echo "waiting qdata/c$NODENUM/tm.ipc"
            DOWN=true
        fi
done

########end of constellation-start.sh file
echo "[*] Starting Ethereum nodes"
set -v
ARGS="--nodiscover --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"
PRIVATE_CONFIG=qdata/c$NODENUM/tm.ipc nohup geth --datadir qdata/dd$NODENUM $ARGS --permissioned --raftport 50402 --rpcport 22001 --port 21001 2>>qdata/logs/$NODENUM.log &
set +v

echo
echo "All nodes configured. See 'qdata/logs' for logs, and run e.g. 'geth attach qdata/dd1/geth.ipc' to attach to the first Geth node."
echo "To test sending a private transaction from Node 1 to Node 7, run './runscript script1.js'"
exit
#####end of raft-start.sh
