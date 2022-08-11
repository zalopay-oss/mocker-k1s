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
  ip=$(./state.sh get_next_ip)
  ./state.sh validate_id $id
  ./network.sh create $id $ip
  ./process.sh create $id
  ./state.sh create $id
  echo "Success create $id" | cowsay -e oO
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
  ./process.sh exec $id
}

case $1 in
  ps) "$@"; exit;;
  run) "$@"; exit;;
  rm) "$@"; exit;;
  exec) "$@"; exit;;
esac