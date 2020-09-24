#!/bin/bash

telegram_bot_token="1300378017:AAEoicYcVG1KAPv2ZyHWmJq1oJVQNGPyD5Q"
telegram_chat_id="-466217161"

Title="$1"
Message="$2"

curl -s \
 --data parse_mode=HTML \
 --data chat_id=${telegram_chat_id} \
 --data text="<b>${Title}</b>%0A${Message}" \
 --request POST https://api.telegram.org/bot${telegram_bot_token}/sendMessage
