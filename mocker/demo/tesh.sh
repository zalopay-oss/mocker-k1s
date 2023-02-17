#!/bin/bash
set -echo

echo "read Mockerfile" | cowsay
cat golang1.Mockerfile

echo "build image `go1` from Mockerfile" | cowsay
mocker build img1 golang1.Mockerfile

echo "list all images" | cowsay
mocker images

echo "run new container" | cowsay
mocker run container1 img1