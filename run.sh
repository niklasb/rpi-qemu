#!/bin/bash

set -x
SSH_PORT=5022

# -redir listens on 0.0.0.0, so shut the port
if ! sudo iptables -L -n | grep $SSH_PORT; then
  sudo iptables -A INPUT -p tcp -s 127.0.0.1 --dport $SSH_PORT -j ACCEPT
  sudo iptables -A INPUT -p tcp --dport $SSH_PORT -j DROP
fi

# We should use
# -netdev user,id=user.0 -device e1000,netdev=user.0
# But I don't know what device to use. The guest OS reports
# that a SMC91C11xFD controller is implicitly used, but I can't figure out how
# to select it explicitly, so that we can use  -netdev and -device
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
