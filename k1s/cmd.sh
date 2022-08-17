set -e
# prepare state file
K1_STATE="$PWD/.k1s.state"
# prepare workspace
K1_DIR=~/.k1/tmp/ns
mkdir -p $K1_DIR
mount --bind $K1_DIR $K1_DIR
mount --make-private $K1_DIR

get_node() {
  cat $K1_STATE
}

run() {
  name=$1
  image=$2
  # todo: using random_node
  first_node=$(get_node | tail -1)
  ssh $first_node "/root/mocker-k1s/mocker images"
}

case $1 in
  get_pod) "$@"; exit;;
  get_node) "$@"; exit;;
  run) "$@"; exit;;
esac