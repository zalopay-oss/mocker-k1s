MOCK_STATE="$PWD/.mocker.state"
MOCK_DIR=~/.mocker/tmp/ns

# need exec after create ns namespace
create() {
  id=$1
  ip=$2
  echo "touch $MOCK_DIR/{$id-mnt,$id-pid}"
  touch $MOCK_DIR/{$id-mnt,$id-pid}
  # execute unshare process under netns avoid persistent issue when using parameter --net
  echo "ip netns add $id-net"
  ip netns add $id-net
  unshare \
    --pid=$MOCK_DIR/$id-pid \
    --mount \
    --net=/var/run/netns/$id-net \
    --fork \
    --mount-proc \
    bash
}

start() {
  # todo: merge with create function
  # execute after create function
  id=$1
  image_name=$2
  cmd=$3
  # exec to container
    # export ENV container workspace
    # copy image cache layer to container workspace - ./network.sh sync_container_workspace
    # execute cmd in background mode
}

exec() {
  id=$1
  unshare_pid=$(lsns | grep "unshare --pid=/root/.mocker/tmp/ns/$id-pid --mount" | awk '{print $4}' | tail -1)
  bash_pid=$(pgrep -P $unshare_pid)
  nsenter -t $bash_pid -a
}

delete() {
  id=$1
  umount $MOCK_DIR/{$id-mnt,$id-pid}
}

inspect() {
  id=$1

  echo "[INFO]: list process running in $id"
  netns=$id-net
  find -L /proc/[1-9]*/task/*/ns/net -samefile /run/netns/"$netns" | cut -d/ -f5
  echo
  echo "[INFO]: network info"
  ip netns exec $netns ip addr
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
  inspect) "$@"; exit;;
esac