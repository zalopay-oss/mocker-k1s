set -e
MOCK_HOME="$PWD/.mocker.state"

ps() {
  cat $MOCK_HOME
}

run() {
  id=$1
  ./state.sh create $id
  echo "Running" $id | cowsay -e oO
}

rm() {
  echo "Killing" $1 | cowsay -e xx
}

case $1 in
  ps) "$@"; exit;;
  run) "$@"; exit;;
  rm) "$@"; exit;;
esac