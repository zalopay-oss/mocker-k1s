set -e
# prepare state file
MOCK_STATE="$PWD/.mocker.state"
# prepare workspace
MOCK_DIR=~/.mocker/tmp/ns
mkdir -p $MOCK_DIR
mount --bind $MOCK_DIR $MOCK_DIR
mount --make-private $MOCK_DIR

ps() {
  cat $MOCK_STATE
}

run() {
  id=$1
  ./state.sh validate_id $id
  ./network.sh create $id
  ./process.sh create $id
  ip=$(./state.sh get_next_ip)
  pid=$(./process.sh get_bash_pid $id)
  echo "ip $id, ip $ip, pid $pid"
  ./network.sh link $id $ip $pid
  ./state.sh create $id
  echo "Success create $id, ip: $ip" | cowsay -e oO
}

rm() {
  id=$1
  ./process.sh delete $id
  ./network.sh delete $id
  ./state.sh delete $id
  echo "Remove $id" | cowsay -e @@
}

exec() {
  id=$1
  echo "exec $id" | cowsay -e ..
  ./process.sh exec $id
}

build() {
  image_name=$1
  file_path=$2

  ./mockerfile.sh build $image_name $file_path
  echo "Build $image_name success" | cowsay -e oO
}

case $1 in
  ps) "$@"; exit;;
  run) "$@"; exit;;
  rm) "$@"; exit;;
  exec) "$@"; exit;;
  build) "$@"; exit;;
esac