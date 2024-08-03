#!/usr/bin/bash

uid=$(id -u)
gid=$(id -g)

sudo mount -t cifs -o username=jose,uid=$uid,gid=$gid //192.168.100.205/photos /mnt/photos
sudo mount -t cifs -o username=jose,uid=$uid,gid=$gid //192.168.100.205/jose /mnt/jose
