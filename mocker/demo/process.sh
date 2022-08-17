MOCK_STATE="$PWD/.mocker.state"
MOCK_DIR=~/.mocker/tmp/ns

# need exec after create ns namespace
create() {
  id=$1
  
  touch $MOCK_DIR/{$id-mnt,$id-pid}
  unshare \
    --pid=$MOCK_DIR/$id-pid \
    --mount=$MOCK_DIR/$id-mnt \
    --fork \
    --mount-proc \
    bash
}