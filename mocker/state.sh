MOCK_HOME="$PWD/.mocker.state"

get_next_ip() {
  ip=$(tail -1 ./.mocker.state | awk '{print $2}')
  if [ ! $ip ]; then                      
    ip="10.0.0.0"
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
  echo $id | grep -q '[A-z]'
  cat $MOCK_HOME | awk '{print $1}' | grep -q "^$id$"
  # if exit code is 0 then the id is existed in the state file and is invalid
  if [ $? -eq 0 ]; then
    echo "error"
  else
    echo 0
  fi
}

create() {
  echo thef
  id=$1
  ip=$(get_next_ip)
  status_code=$(validate_id $id)
  if [[ $status_code == "error" ]]; then
    echo "[ERR]: duplicate id '$id'"
  else
    echo "$id $ip" >> $MOCK_HOME
    cat $MOCK_HOME
  fi
}

# delete() {

# }

case $1 in
  create) "$@"; exit;;
esac