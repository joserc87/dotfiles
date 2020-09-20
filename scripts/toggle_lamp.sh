#!/usr/bin/env bash

ADDR="http://192.168.18.2"
USR="qtDL80G1DEeUctazVqefajK18GXPS2BbOa6WdQHK"
API="$ADDR/api/$USR"
DESK_LAMP=1

STATE_URL=$API/lights/1
lamp_on=$(curl $API/lights/$DESK_LAMP | jq .state.on)


if [[ $lamp_on == 'true' ]]; then
    echo "Then lamp is on. Turning off."
    curl -X PUT "$API/lights/$DESK_LAMP/state" -d '{"on":false}'
else
    echo "Then lamp is off. Turning on."
    curl -X PUT "$API/lights/$DESK_LAMP/state" -d '{"on":true,"bri":255}'
fi
