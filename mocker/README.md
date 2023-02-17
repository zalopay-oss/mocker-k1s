# Mocker v1.0.0
> Mocker is a container engine will replace docker in future
 
## Test cript
> https://asciinema.org/a/w9yPrjdQhSOGMAvow7n13esB6
```bash
cowsay "First, We gonna test Mocker build feature"
cd /root/mocker-k1s/mocker/test/go-backend-1
ll
cat Mockerfile
cd /root/mocker-k1s/mocker
mocker images
mocker build go-backend /root/mocker-k1s/mocker/test/go-backend-1/Mockerfile
mocker build go-backend /root/mocker-k1s/mocker/test/go-backend-1/Mockerfile2
cowsay "Next, We test Mocker start a new container"
mocker ps
mocker run go300 go-backend
mocker exec go300
cd /root/workspace
ls -la
cat index.html
WORK_DIR=$PWD ./go-backend-linux-amd64 &
netstat -lnpt
curl 0.0.0.0:10000
exit
cowsay "After exit the container, we can't see the container PID tree or network listening port"
netstat -lnpt
mocker ps
curl 0.0.0.0:10000
```

## Setup env for Mocker
```bash
$ apt install tr
$ apt install diff
$ apt install cowsay
$ apt install base64
$ network.sh init
```

## Create mocker container and play with network
```bash
$ cd mocker-k1s/mocker

# run new mocker container
$ cmd.sh run nginx-1
 _______________________________________
< Success create nginx-1, ip: 10.0.0.18 >
 ---------------------------------------
        \   ^__^
         \  (oO)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

# enter container and check network
$ cmd.sh exec nginx-1
 ______________
< exec nginx-1 >
 --------------
        \   ^__^
         \  (..)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
$ netstat -lnpt
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name

# start nginx in container at port 80
$ mocker/test/binary/nginx-1.23.0/nginx/nginx
$ netstat -lnpt # container network show port 80 is up
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      8934/nginx: master  
tcp6       0      0 :::80                   :::*                    LISTEN      8934/nginx: master  

# testing nginx in container
$ curl 10.0.0.18:80
hello

# exit container
exit

# testing nginx of container in host
$ curl 10.0.0.18:80
hello

# host network don't show port 80
$ netstat -lnpt
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 127.0.0.1:46095         0.0.0.0:*               LISTEN      1019/node           
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      642/sshd: /usr/sbin 
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      404/systemd-resolve 
tcp6       0      0 :::22                   :::*                    LISTEN      642/sshd: /usr/sbin 
```

## Next feature
- Mockerfile
- Nat port from host to container (require for k1s)