# curl https://raw.githubusercontent.com/dinhanhhuy/mocker-k1s/main/mocker/install.sh | bash
#!/bin/bash
set -e

echo "Start installing mocker"
yum install git -y
yum install cowsay -y
yum install coreutils -y # base64
git clone https://github.com/dinhanhhuy/mocker-k1s.git
cd mocker-k1s/mocker
./network.sh init