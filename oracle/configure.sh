#!/bin/sh

_step_counter=0
step() {
	_step_counter=$(( _step_counter + 1 ))
	printf '\n\033[1;36m%d) %s\033[0m\n' $_step_counter "$@" >&2  # bold cyan
}


step 'Set up timezone'
setup-timezone -z Europe/Prague

step 'Set up networking'
cat > /etc/network/interfaces <<-EOF
	auto lo
	iface lo inet loopback
	
	auto eth0
	iface eth0 inet dhcp
EOF
ln -s networking /etc/init.d/net.lo
ln -s networking /etc/init.d/net.eth0

step 'Enable services'
rc-update add swclock boot
rc-update add chronyd default
rc-update add sshd default
rc-update add net.eth0 default
rc-update add net.lo boot

step 'Setup Cloud-init'
setup-cloud-init