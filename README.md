### Near-update
Automatically update, test and run a new near node.
With info messages to telegram.


### Installations a
 1. Clone this repo to your home dir
```sh
cd $HOME && git clone https://github.com/ama31337/near-update.git && cd ./near-update && chmod +x ./*.sh
```
 2. Edit your network in node_update.sh
 3. Put your telegram bot api key and chat id sendmsg_tgbot.sh
 4. Add node_update.sh OR node_update_git.sh to crontab, it's enought to run it twice a day(every 12h on the example below, you can chenge it to suit your needs), put absolute path in cron.
```sh
crontab -e
0 /12 * * *    cd /home/$USER/near-update/ && ./node_update.sh >> /home/$USER/near-update/node_update.log
0 /12 * * *    cd /home/$USER/near-update/ && ./node_update_git.sh >> /home/$USER/near-update/node_update.log
```
 5. Wait for messages in your telegram about new updates.

### How does this script work
 1. There are two versions
    - node_update.sh is check difference between your local node and node on the network (from rpc.betanet.near.org for example)
    - node_update_git.sh check difference between your local node and latest branch on github, this way will update your node faster.
 2. Every x hours (or days/minutes) which you set in the cron, script will check does your node is still up to date.
 3. If your node is outdated, script will clone new repo and make a fresh build.
 4. If build was succesfull, script will run two nodes locally (in parallel with your main one).
 5. Process a check about new nodes are running fine and up to date.
 6. If both test nodes are working fine, your old node is backuped and node is new one is goes online.
 7. On the way you'll get all nessesary messages directly in your telegram.
