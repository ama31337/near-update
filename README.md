### Near-update
Automatically update, test and run a new near node.
With info messages to telegram.


### Installation
 1. Clone this repo to ypur home dir
```sh
cd $HOME && git clone https://github.com/ama31337/near-update.git && cd ./near-update && chmod +x ./*.sh
```
 2. Edit your network in node_update.sh
 3. Put your telegram bot api key and chat id sendmsg_tgbot.sh
 4. Add node_update.sh to crontab, it's enought to run it twice a day.
 5. Wait for messages in your telegram about new updates.

