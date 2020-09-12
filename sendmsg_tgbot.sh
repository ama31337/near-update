#!/bin/bash

telegram_bot_token="bot_api" # Your bot api from @botfather
telegram_chat_id="chat_id" # Your tg id or any chat id to send msg

Title="$1"
Message="$2"

curl -s \
 --data parse_mode=HTML \
 --data chat_id=${telegram_chat_id} \
 --data text="<b>${Title}</b>%0A${Message}" \
 --request POST https://api.telegram.org/bot${telegram_bot_token}/sendMessage
