#!/usr/bin/env bash

ADDR="http://192.168.100.125"
USR="qtDL80G1DEeUctazVqefajK18GXPS2BbOa6WdQHK"
API="$ADDR/api/$USR"
DESK_LAMP=1

STATE_URL=$API/lights/1
lamp_on=$(curl $API/lights/$DESK_LAMP | jq .state.on)


if [[ $lamp_on == 'true' ]]; then
    echo "Then lights are on. Turning off."
    curl -X PUT "$API/lights/1/state" -d '{"on":false}'
    curl -X PUT "$API/lights/2/state" -d '{"on":false}'
    curl -X PUT "$API/lights/3/state" -d '{"on":false}'
    curl -X PUT "$API/lights/4/state" -d '{"on":false}'
    curl -X PUT "$API/lights/5/state" -d '{"on":false}'
else
    echo "Then lights are off. Turning on."
    curl -X PUT "$API/lights/1/state" -d '{"on":true,"bri":255}'
    curl -X PUT "$API/lights/2/state" -d '{"on":true,"bri":255}'
    curl -X PUT "$API/lights/3/state" -d '{"on":true,"bri":255}'
    curl -X PUT "$API/lights/4/state" -d '{"on":true,"bri":255}'
    curl -X PUT "$API/lights/5/state" -d '{"on":true,"bri":255}'
fi
