# Mocker v1.0.0
> Playful container engine created by 500 lines bash script
## Demo
Tested with AWS Linux `ami-0f2eac25772cd4e36`
[![asciicast](https://asciinema.org/a/uUOjoz0e0oFdWdzFbljZfUATn.svg)](https://asciinema.org/a/uUOjoz0e0oFdWdzFbljZfUATn)
## Install on Centos
```bash
curl https://raw.githubusercontent.com/dinhanhhuy/mocker-k1s/main/mocker/install.sh | bash
```

## Basic usage
### Demo mocker file
```bash
$ cat golang1.Mockerfile
RUN wget https://github.com/dinhanhhuy/go-backend/releases/download/1.0.0/go-backend-linux-amd64
RUN chmod +x go-backend-linux-amd64
RUN echo 'this is go-backend 1000' > /root/.mocker/layer/builder_space/index.html
RUN ls -la
RUN ls -la
```

### Build image from Mockerfile
```bash
$ mocker build img1 golang1.Mockerfile
...
932ace9337a30e1f58841718c2624870
[INFO]: buding RUN chmod +x go-backend-linux-amd64
[INFO]: buding RUN echo 'this is go-backend 1000' > /root/.mocker/layer/builder_space/index.html
[INFO]: buding RUN ls -la
[INFO]: buding RUN ls -la
[INFO]: buding CMD ID=go-backend-1 WORK_DIR=/root/workspace /root/workspace/go-backend-linux-amd64
/root/.mocker/layer
|-- 2d15f0c52caa33fd679b2fdc8f14f642
|   |-- go-backend-linux-amd64
|   `-- index.html
|-- 90cb403239851d091015e1e2d98f489b
|   |-- entry.sh
|   |-- go-backend-linux-amd64
|   `-- index.html
|-- 932ace9337a30e1f58841718c2624870
|   `-- go-backend-linux-amd64
|-- ba8675a9a669696c12076f6c0b879a7d
|   |-- go-backend-linux-amd64
|   `-- index.html
|-- ddf58290b0367f3f695074b6ecde8985
|   `-- go-backend-linux-amd64
|-- f4d1ea5912242d002cc06053b6220342
|   |-- go-backend-linux-amd64
|   `-- index.html
`-- img1 -> 90cb403239851d091015e1e2d98f489b
 __________________________
< Build image img1 success >
 --------------------------
        \   ^__^
         \  (><)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
### List all images
```bash
$ mocker images
/root/.mocker/layer
|-- 2d15f0c52caa33fd679b2fdc8f14f642
|   |-- go-backend-linux-amd64
|   `-- index.html
|-- 90cb403239851d091015e1e2d98f489b
|   |-- entry.sh
|   |-- go-backend-linux-amd64
|   `-- index.html
|-- 932ace9337a30e1f58841718c2624870
|   `-- go-backend-linux-amd64
|-- ba8675a9a669696c12076f6c0b879a7d
|   |-- go-backend-linux-amd64
|   `-- index.html
|-- ddf58290b0367f3f695074b6ecde8985
|   `-- go-backend-linux-amd64
|-- f4d1ea5912242d002cc06053b6220342
|   |-- go-backend-linux-amd64
|   `-- index.html
`-- img1 -> 90cb403239851d091015e1e2d98f489b
```
### Run new container with isolate network
```bash
$ mocker run backend img1
ip backend, ip 10.0.0.5, pid 3832
 ___________________________________
< Success create backend, ip: 10.0.0.5 >
 -----------------------------------
        \   ^__^
         \  (oO)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

### List container
```bash
$ mocker ps
backend 10.0.0.5
```

### Test connection
container backend running at 10.0.0.5:10000
```bash
$ curl 10.0.0.5:10000
this is go-backend 1000
```

### Verify the host dont listen on 10000
```bash
$ netstat -lnpt | grep 10000
# exit 1
```
### Execute to pod and check for network
```bash
$ mocker exec backend
______________
< exec backend >
 -------------
        \   ^__^
         \  (..)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
[root@ip-172-31-20-239 /]# netstat -lnpt | grep 10000
tcp6       0      0 :::10000                :::*                    LISTEN      5/go-backend-linux-
```