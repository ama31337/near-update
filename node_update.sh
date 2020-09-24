#!/bin/bash

#choose your network
networktype=$betanet

SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`

OS_SYSTEM=`uname`
if [[ "$OS_SYSTEM" == "Linux" ]];then
    CALL_BC="bc"
else
    CALL_BC="bc -l"
fi

#check node version diff
diff <(curl -s https://rpc.$networktype.near.org/status | jq .version) <(curl -s http://127.0.0.1:3030/status | jq .version)

#start update if local version is different
if [ $? -ne 0 ]; then
    echo "start update";
    rustup default nightly
    rm -rf /home/$USER/nearcore.new
    version=$(curl -s https://rpc.$networktype.near.org/status | jq .version.version)
    strippedversion=$(echo "$version" | awk -F "\"" '{print $2}' | awk -F "-" '{print $1}')
    git clone --branch $strippedversion https://github.com/nearprotocol/nearcore.git /home/$USER/nearcore.new
    cd /home/$USER/nearcore.new
    make release
# make test of new build (atm it's always crashed)
#    python3 /home/$USER/nearcore.new/scripts/parallel_run_tests.py 

        #if make make was succesfully test a new node
        if [ $? -eq 0 ]; then
        echo "new build was successfull, run test nodes"
        "${SCRIPT_DIR}/sendmsg_tgbot.sh" "$HOSTNAME inform you:" "new build was successfull, run test nodes"  2>&1 > /dev/null
        rm -rf /home/$USER/near-update/localnet/node0/data
        rm -rf /home/$USER/near-update/localnet/node1/data
#        rm -rf /home/$USER/near-update/localnet/node2/data
#        rm -rf /home/$USER/near-update/localnet/node3/data
        /home/$USER/nearcore.new/target/release/neard --home /home/$USER/near-update/localnet/node0 run
        /home/$USER/nearcore.new/target/release/neard --home /home/$USER/near-update/localnet/node1 run --boot-nodes ed25519:7PGseFbWxvYVgZ89K1uTJKYoKetWs7BJtbyXDzfbAcqX@127.0.0.1:24550
#        /home/$USER/nearcore.new/target/release/neard --home /home/$USER/near-update/localnet/node2 run --boot-nodes ed25519:7PGseFbWxvYVgZ89K1uTJKYoKetWs7BJtbyXDzfbAcqX@127.0.0.1:24550
#        /home/$USER/nearcore.new/target/release/neard --home /home/$USER/near-update/localnet/node3 run --boot-nodes ed25519:7PGseFbWxvYVgZ89K1uTJKYoKetWs7BJtbyXDzfbAcqX@127.0.0.1:24550
        sleep 10
        echo "run test"
        testcount=0        
        for count in {0..1}
        do
            diff <(curl -s https://rpc."$networktype".near.org/status | jq .version) <(curl -s http://127.0.0.1:305"$count"/status | jq .version)
            if [ $? -eq 0 ]
            then
                testcount=$((testcount + 1))
                "${SCRIPT_DIR}/sendmsg_tgbot.sh" "$HOSTNAME inform you:" "testnode #$count run ok"  2>&1 > /dev/null
                echo $HOSTNAME ' inform you: testnode ' $count ' run ok'
            else
                testcount=$((testcount - 1))
                "${SCRIPT_DIR}/sendmsg_tgbot.sh" "$HOSTNAME inform you:" "testnode #$count failed, check it"  2>&1 > /dev/null
                echo $HOSTNAME ' inform you: testnode ' $count ' failed, check it'
            fi
        done
        echo 'kill test nodes'
        pkill neard

            if testcount=2; then
                echo 'test is succesfull, deploy a new node'
                mkdir -p /home/$USER/nearcore.bak
                mv /home/$USER/nearcore /home/$USER/nearcore.bak/nearcore-"`date +"%Y-%m-%d(%H:%M)"`"
                mv /home/$USER/nearcore.new /home/$USER/nearcore
                cd /home/$USER/
                nearup stop
                nearup run $networktype --binary-path ~/nearcore/target/release/
                "${SCRIPT_DIR}/sendmsg_tgbot.sh" "$HOSTNAME inform you:" "update finished, node status: active"  2>&1 > /dev/null
                echo $HOSTNAME 'inform you: update finished, node status: active'
            else
                "${SCRIPT_DIR}/sendmsg_tgbot.sh" "$HOSTNAME inform you:" "near update failed, check it manually"  2>&1 > /dev/null
                echo $HOSTNAME 'inform you: near update failed, check it manually'
            fi
        fi
fi
