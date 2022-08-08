set -e
# prepare state file
MOCK_STATE="$PWD/.mocker.state"
# prepare workspace
WORK_DIR=~/.mocker/tmp/ns
mkdir -p $WORK_DIR
mount --bind $WORK_DIR $WORK_DIR
mount --make-private $WORK_DIR

ps() {
  cat $MOCK_STATE
}

run() {
  id=$1
  ./state.sh validate_id $id
  ./network.sh create $id
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