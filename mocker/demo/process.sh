set -e
MOCK_STATE="$PWD/.mocker.state"
MOCK_DIR=~/.mocker/tmp/ns

# need exec after create ns namespace
create() {
  id=$1
  
  mkdir -p $MOCK_DIR
  touch $MOCK_DIR/{$id-mnt,$id-pid}
  unshare \
    --pid=$MOCK_DIR/$id-pid \
    --mount=$MOCK_DIR/$id-mnt \
    --mount-proc \
    --fork \
    bash

  # mount --bind /root/mocker-k1s $PWD/k1
  # mount --bind @ROOT            @CONTAINER
}

create $@