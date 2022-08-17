set -e
MOCK_LAYER=~/.mocker/layer

build() {
  image_name=$1
  file_path=$2

  # init build space
  rm -rf $MOCK_LAYER/builder_space
  mkdir -p $MOCK_LAYER/builder_space

  # create cache layer base on mockerfile
  filename=$file_path
  while read line; do 
    echo "$line"
    create_cache_layer "$line" ""
  done < "$filename"
}

# move cache layer to container workspace ~/.MOCKER_DIR/container_workspace/
sync_container_workspace() {
  id=$1
  image_name=$2
}

test=0
create_cache_layer() {
  ((test+=1))
  cmd=$1
  previous_hash=$2

  # builder space
  cd $MOCK_LAYER/builder_space
  
  # calculate hash
  mix="$previous_hash-$cmd"
  new_hash="$(echo \"$mix\" | base64)"
  short_hash="${new_hash:0:200}"
  # echo $short_hash

  # execute
  executable_cmd=$(echo "${cmd:4}")
  eval "$executable_cmd"
  echo "hello" > $test.init

  # save cache layer
  mkdir -p "$MOCK_LAYER/$short_hash"
  # echo "cp -R $MOCK_LAYER/builder_space/* $MOCK_LAYER/$short_hash"
  cp -R $MOCK_LAYER/builder_space/* "$MOCK_LAYER/$short_hash"

  echo "[info]: shorthash: $short_hash"
  echo "[info]: executable_cmd: $executable_cmd"
  echo "[info]: tree "$MOCK_LAYER""

  # todo: using diff to detect cache layer change
  # scan new file
  # scan delete file
  # scan change file
  
  
  pwd
  tree "$MOCK_LAYER"
  # ex
  


  # echo
  # 1. copy previous_hash to builder space
  # 2. execute cmd
  # 3. calculate new hash
  # 4. copy builder space to new cache
}

case $1 in
  build) "$@"; exit;;
esac