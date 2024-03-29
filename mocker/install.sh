# curl https://raw.githubusercontent.com/dinhanhhuy/mocker-k1s/main/mocker/install.sh | bash
# ami-0f2eac25772cd4e36
#!/bin/bash
set -e

# disable warning rollback locale
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.UTF-8

echo "Start installing mocker"
yum install git -y
yum install cowsay -y
yum install tree -y
# install base64
yum install coreutils -y
git clone https://github.com/dinhanhhuy/mocker-k1s.git
# install hello world backend
cp -R mocker-k1s/mocker/* /usr/bin
# install test binary
network.sh init