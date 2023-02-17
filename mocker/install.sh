# curl https://raw.githubusercontent.com/dinhanhhuy/mocker-k1s/main/mocker/install.sh | bash
# ami-0f2eac25772cd4e36
#!/bin/bash
set -e

echo "Start installing mocker"
yum install git -y
yum install cowsay -y
# install base64
yum install coreutils -y
git clone https://github.com/dinhanhhuy/mocker-k1s.git
# install hello world backend
cp mocker-k1s/mocker/test/go-backend-linux-amd64 /usr/bin
cd mocker-k1s/mocker
./network.sh init