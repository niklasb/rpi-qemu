#!/bin/bash
SSH_PORT=5022
IFACE=eth0
set -x
if ! sudo iptables -L -n | grep $SSH_PORT; then
  sudo iptables -A INPUT -p tcp -s 127.0.0.1 --dport $SSH_PORT -j ACCEPT
  sudo iptables -A INPUT -p tcp --dport $SSH_PORT -j DROP
fi
# We should use
# -netdev user,id=user.0 -device e1000,netdev=user.0
# BUT I don't know what device to use. Seems like QEMU implicitly uses
# some kind of
qemu-system-arm \
  -cpu arm1176 \
  -m 256 \
  -redir tcp:5022::22 \
  -kernel kernel-qemu \
  -M versatilepb \
  -no-reboot \
  -serial stdio \
  -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
  -hda *.img
