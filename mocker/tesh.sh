#!/bin/bash
set -echo

echo "build image `go1` from Mockerfile" | cowsay
mocker build img1 /root/mocker-k1s/mocker/demo/golang1.Mockerfile

echo "list all images" | cowsay
mocker images

echo "run new container" | cowsay
mocker run container1 img1