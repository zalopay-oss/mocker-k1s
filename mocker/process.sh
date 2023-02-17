MOCK_STATE="~/.mocker.state"
MOCK_DIR=~/.mocker/tmp/ns
MOCK_WORKSPACE=~/.mocker/workspace
CONTAINER_WORKSPACE="/root/workspace"
# todo: duplicate this variable, source trust need in dockerfile
MOCK_LAYER=/root/.mocker/layer

# need exec after create ns namespace
create() {
  id=$1
  image=$2
  touch $MOCK_DIR/$id-pid

  # execute unshare process under netns avoid persistent issue when using parameter --net
  (unshare \
    --pid=$MOCK_DIR/$id-pid \
    --mount \
    --net=/var/run/netns/$id-net \
    --fork \
    --mount-proc \
    tail -f /dev/null)&

  mount_workspace $id $image
  start_entry $id
}

start_entry() {
  id=$1
  exec $id "$CONTAINER_WORKSPACE/entry.sh" &
}

mount_workspace() {
  id=$1
  image=$2
  host_path="$MOCK_WORKSPACE/$id"
  container_path=$CONTAINER_WORKSPACE
  mkdir -p $host_path
  mkdir -p $container_path
  
  exec $id mount --bind $host_path $container_path
  # echo "exec $id cp -R $MOCK_LAYER/$image/* $container_path"
  exec $id cp -R $MOCK_LAYER/$image/* $container_path
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

get_bash_pid() {
  id=$1
  unshare_pid=$(lsns | grep "unshare --pid=/root/.mocker/tmp/ns/$id-pid --mount" | awk '{print $4}' | tail -1)
  bash_pid=$(pgrep -P $unshare_pid)
  echo $bash_pid
}

exec() {
  id=$1
  unshare_pid=$(lsns | grep "unshare --pid=/root/.mocker/tmp/ns/$id-pid --mount" | awk '{print $4}' | tail -1)
  bash_pid=$(pgrep -P $unshare_pid)
  nsenter -t $bash_pid -a "${@:2}"
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
  mount_workspace) "$@"; exit;;
  get_bash_pid) "$@"; exit;;
esac