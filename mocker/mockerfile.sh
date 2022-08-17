set -e
MOCK_LAYER=/root/.mocker/layer

build() {
  image_name=$1
  file_path=$2

  # init build space
  rm -rf $MOCK_LAYER/builder_space
  mkdir -p $MOCK_LAYER/builder_space

  # create cache layer base on mockerfile
  filename=$file_path
  last_layer=""
  while read line; do 
    short_hash=$(get_short_hash "$line" "$last_layer")
    echo $short_hash
    if [ -d "$MOCK_LAYER/$short_hash" ]
    then
      echo "[CACHED] $short_hash" | grep --color=always -z 'CACHED'
    else
      echo "[INFO]: buding $short_hash"
      create_cache_layer "$line" "$short_hash"
    fi
    last_layer=$short_hash
  done < "$filename"

  # clean ln avoid link many time
  rm -rf $MOCK_LAYER/$image_name
  ln -s $last_layer $MOCK_LAYER/$image_name
  tree $MOCK_LAYER
}

# move cache layer to container workspace ~/.MOCKER_DIR/container_workspace/
sync_container_workspace() {
  id=$1
  image_name=$2
}

get_short_hash() {
  cmd=$1
  previous_hash=$2
  
  # calculate hash
  mix="$previous_hash-$cmd"
  new_hash="$(echo \"$mix\" | base64 | tr -d -c \".[:alnum:]\")"
  short_hash="${new_hash:0:200}"
  echo $short_hash
}

create_cache_layer() {
  # todo: insert diff logic instead of duplicate
  
  # builder space
  cd $MOCK_LAYER/builder_space
  
  cmd=$1
  short_hash=$2
  # echo "short_hash $short_hash"

  # execute
  executable_cmd=$(echo "${cmd:4}")
  # echo "[INFO]: RUN ${executable_cmd}"
  eval "$executable_cmd"
  # echo

  # save cache layer
  mkdir -p "$MOCK_LAYER/$short_hash"
  # echo "cp -R $MOCK_LAYER/builder_space/* $MOCK_LAYER/$short_hash"
  cp -R $MOCK_LAYER/builder_space/* "$MOCK_LAYER/$short_hash"

  echo "$MOCK_LAYER/$short_hash"
}

images() {
  mkdir -p $MOCK_LAYER
  ls -la $MOCK_LAYER
}

case $1 in
  build) "$@"; exit;;
  images) "$@"; exit;;
esac