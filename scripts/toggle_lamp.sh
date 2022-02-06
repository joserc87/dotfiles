#!/usr/bin/env bash

ADDR="http://192.168.0.15"
USR="qtDL80G1DEeUctazVqefajK18GXPS2BbOa6WdQHK"
API="$ADDR/api/$USR"
DESK_LAMP=6

STATE_URL=$API/lights/1
lamp_on=$(curl $API/lights/$DESK_LAMP | jq .state.on)

BRIGHTNESS=${1:-255}

if [[ $lamp_on == 'true' ]]; then
    if [[ -z "$1" ]] || [[ $1 == '0' ]] || [[ $1 == 'off' ]]; then
        echo "The lamp is on. Turning off."
        curl -X PUT "$API/lights/$DESK_LAMP/state" -d '{"on":false}'
    else
        echo "The lamp is on. Adjusting."
        curl -X PUT "$API/lights/$DESK_LAMP/state" -d "{\"on\":true,\"bri\":$BRIGHTNESS}"
    fi
elif [[ $1 != 'off' ]]; then
    if [[ $1 == 'on' ]]; then
        BRIGHTNESS=255
    fi
    echo "The lamp is off. Turning on."
    curl -X PUT "$API/lights/$DESK_LAMP/state" -d "{\"on\":true,\"bri\":$BRIGHTNESS}"
fi
