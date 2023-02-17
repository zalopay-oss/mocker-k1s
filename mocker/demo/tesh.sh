#!/bin/bash
set -e

echo "read Mockerfile

cat golang1.Mockerfile" | cowsay
cat golang1.Mockerfile

# image name need to be short
echo "build image from Mockerfile

mocker build img1 golang1.Mockerfile" | cowsay
mocker build img1 golang1.Mockerfile

echo "list all images

mocker images" | cowsay
mocker images

# container name need to be short
echo "run new container

mocker run con5 img1" | cowsay
mocker run con5 img1

echo "list container" | cowsay
mocker ps

IP=$(mocker ps | grep con5 | awk '{print $NF}')
PORT=10000
echo "container con5 running at $IP:$PORT - 
curl $IP:$PORT" | cowsay
curl $IP:$PORT

echo "Verify the host don't listen on $PORT - 
netstat -lnpt | grep $PORT" | cowsay
netstat -lnpt | grep $PORT || true

echo "execute to pod and check for network - 
mocker exec con5" | cowsay
mocker exec con5

echo "check network inside container - 
netstat -lnpt | grep $PORT" | cowsay
netstat -lnpt | grep $PORT

echo "demo success"