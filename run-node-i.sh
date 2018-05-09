NODENUMBER=$1
IPADDR=$(kubectl get svc --selector=node=node$NODENUMBER |awk 'NR>1 {print $4}')
OTHERIP=$(kubectl get svc --selector=node=node1 |awk 'NR>1 {print $4}')
echo "setting up node$1 with IP=$IPADDR and OTHERNODE=$OTHERIP"
kubectl exec $(kubectl get pods --selector=node=node$NODENUMBER|  awk 'NR>1 {print $1}') -- bash -c "cd quorum/Docker/7nodes &&source run-quorum.sh $NODENUMBER $IPADDR $OTHERIP"
