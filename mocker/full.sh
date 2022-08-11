mkdir /tmp/ns
mount --bind /tmp/ns /tmp/ns
mount --make-private /tmp/ns
touch /tmp/ns/{mnt2,pid2}
