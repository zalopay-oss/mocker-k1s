MOCK_STATE="$PWD/.mocker.state"

get_next_ip() {
  ip=$(tail -1 $MOCK_STATE | awk '{print $2}')
  if [ ! $ip ]; then                      
    ip="10.0.0.5"
  else
    IFS='.' read -ra ipnums <<<"$ip"
    last=ipnums[3]
    ((last++))
    ip="10.0.0.$last"
  fi
  echo $ip
}

validate_id() {
  id=$1
  # echo $id | grep -q '[A-z]'
  cat $MOCK_STATE | awk '{print $1}' | grep -q "^$id$"
  # if exit code is 0 then the id is existed in the state file and is invalid
  if [ $? -eq 0 ]; then
    echo "[ERR]: duplicate id '$id'" | cowsay -e "xx"
    return 1
  fi
}

create() {
  id=$1
  ip=$(get_next_ip)
  echo "$id $ip" >> $MOCK_STATE
}

delete() {
  sed -i "/$id\ /d" $MOCK_STATE
}

case $1 in
  create) "$@"; exit;;
  validate_id) "$@"; exit;;
  delete) "$@"; exit;;
  get_next_ip) "$@"; exit;;
esac