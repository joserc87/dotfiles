#!/usr/bin/python
import json

import requests

HUB_ADDR = "http://192.168.100.125"
USR = "qtDL80G1DEeUctazVqefajK18GXPS2BbOa6WdQHK"


def get_ids_from(room: str):
    URL = f"{HUB_ADDR}/api/{USR}/lights/"
    response = requests.get(URL)
    all_lights = response.json()
    ids = [key for key, value in all_lights.items() if room in value["name"]]
    return ids


def get_status_of_light(light_id: str):
    URL = f"{HUB_ADDR}/api/{USR}/lights/{light_id}"
    response = requests.get(URL)
    return response.json()["state"]["on"]


def turn_light(light_id: str, on: bool, brightness: int):
    URL = f"{HUB_ADDR}/api/{USR}/lights/{light_id}/state"
    data = {"on": on}
    if on:
        data["bri"] = brightness
    response = requests.put(URL, data=json.dumps(data))
    if response.status_code != 200:
        print(response.json())


def main():
    brightness = 255
    ids = get_ids_from("PC")
    print(f"Lights: {ids}")
    total = len(ids)
    status = [get_status_of_light(i) for i in ids]
    on_lights = [s for s in status if s]
    print(f"On lights: {len(on_lights)}")
    if len(on_lights) < total:
        print(f"Turning lights on")
        for light in ids:
            turn_light(light, on=True, brightness=brightness)
    else:
        print(f"Turning lights off")
        for light in ids:
            turn_light(light, on=False, brightness=brightness)


if __name__ == "__main__":
    main()
