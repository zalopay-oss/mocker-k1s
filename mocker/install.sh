# curl https://raw.githubusercontent.com/dinhanhhuy/mocker-k1s/main/mocker/install.sh | bash
#!/bin/bash
set -e

echo "Start installing mocker"
yum install git
yum install tr
yum install diff
yum install cowsay
yum install base64
git clone https://github.com/dinhanhhuy/mocker-k1s.git .
cd mocker-k1s/mocker
./network.sh init