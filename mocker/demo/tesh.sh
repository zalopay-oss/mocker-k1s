#!/bin/bash
set -e

echo "read Mockerfile" | cowsay
cat golang1.Mockerfile

# image name need to be short
echo "build image `go1` from Mockerfile" | cowsay
mocker build img1 golang1.Mockerfile

echo "list all images" | cowsay
mocker images

# container name need to be short
echo "run new container" | cowsay
mocker run con1 img1

echo "list container" | cowsay
mocker ps

IP=$(mocker ps | grep con1 | awk '{print $NF}')
PORT=10000
echo "container con1 running at $IP:$PORT\n
send request to container\n
curl $IP:$PORT" | cowsay
curl $IP:$PORT

echo "check if host have port $PORT\n
netstat -lnpt | grep $PORT" | cowsay
netstat -lnpt | grep $PORT

echo "execute to pod and check for network\n
mocker exec con1" | cowsay
mocker exec con1

echo "check network inside container\n
netstat -lnpt | grep $PORT" | cowsay
netstat -lnpt | grep $PORT