MOCK_STATE="$PWD/.mocker.state"
MOCK_DIR=~/.mocker/tmp/ns

# need exec after create ns namespace
create() {
  id=$1
  # instead of rely on pid, we use bind mount filesystem as id
  # /var/run/netns is default folder of netns when exec "ip netns add"
  touch $MOCK_DIR/{$id-mnt,$id-pid}
  (unshare \
    --pid=$MOCK_DIR/$id-pid \
    --mount=$MOCK_DIR/$id-mnt \
    --net=/var/run/netns/$id-net \
    --fork \
    --mount-proc \
    tail -f /dev/null)&
    # ip netns exec $id tail -f /dev/null) &
}

exec() {
  id=$1
  # ip netns exec $id 
  nsenter --pid=$MOCK_DIR/$id-pid --mount=$MOCK_DIR/$id-mnt --net=/var/run/netns/$id-net
}

delete() {
  id=$1
  umount $MOCK_DIR/{$id-mnt,$id-pid}
}

demo() {
  # https://unix.stackexchange.com/questions/710971/how-do-you-get-the-child-pid-of-unshare-when-using-fork-for-nsenter-t-pid

  # So, when you supply --fork to unshare, 
  # it will fork your program (in this case busybox sh) as a child process 
  # of unshare and place it in the new PID namespace.

  # create ns
  ip netns exec hello unshare --fork --pid --mount-proc bash
  netcat -l 8080&
  ps aux

  # find parrent
  target_pid=$(ps $(ip netns pids $id) | awk 'FNR == 2 {print $1}')
  # UID        PID  PPID  C STIME TTY      STAT   TIME CMD
  # root     40355  7090  0 00:21 pts/0    S+     0:00 netcat -l 8080
  nsenter -a -t $target_pid ps aux
}

case $1 in
  create) "$@"; exit;;
  exec) "$@"; exit;;
esac