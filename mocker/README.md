# Mocker v1.0.0
> Mocker is a container engine will replace docker in future
 
## Setup env for Mocker
```bash
$ ./network.sh init
```

## Create mocker container and play with network
```bash
$ cd mocker-k1s/mocker

# run new mocker container
$ ./cmd.sh run nginx-1
 _______________________________________
< Success create nginx-1, ip: 10.0.0.18 >
 ---------------------------------------
        \   ^__^
         \  (oO)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

# enter container and check network
$ ./cmd.sh exec nginx-1
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
$ nginx
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