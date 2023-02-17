#!/bin/bash
set -e

sleep 1
echo "read Mockerfile

cat golang1.Mockerfile" | cowsay
cat golang1.Mockerfile

sleep 1
# image name need to be short
echo "build image from Mockerfile

mocker build img1 golang1.Mockerfile" | cowsay
mocker build img1 golang1.Mockerfile

sleep 1
echo "list all images

mocker images" | cowsay
mocker images

# container name need to be short
sleep 1
echo "run new container

mocker run con6 img1" | cowsay
mocker run con6 img1

sleep 1
echo "list container

mocker ps" | cowsay
mocker ps

IP=$(mocker ps | grep con6 | awk '{print $NF}')
PORT=10000
sleep 1
echo "container con6 running at $IP:$PORT

curl $IP:$PORT" | cowsay
curl $IP:$PORT

sleep 1
echo "Verify the host don't listen on $PORT

netstat -lnpt | grep $PORT" | cowsay
netstat -lnpt | grep $PORT || true

sleep 1
echo "execute to pod and check for network

mocker exec con6" | cowsay
mocker exec con6

sleep 1
echo "check network inside container

netstat -lnpt | grep $PORT" | cowsay
netstat -lnpt | grep $PORT

echo "demo success"