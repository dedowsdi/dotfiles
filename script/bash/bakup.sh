#!/bin/bash

tar cpzf /bakup/root"$(date +%Y%m%d_%H%M)".tgz \
	--exclude=/proc \
	--exclude=/lost+found \
	--exclude=/bakup \
	--exclude=/mnt \
	--exclude=/sys \
	--exclude=/opt
	--exclude=/usr/local/source \
	--exclude=/usr/share/doc  \
	--exclude=/usr/lib/nvidia-nsight \
	--exclude=/cdrom/ \
	--exclude=/run/user/*/gvfs \
	--exclude=/home \
	--exclude=/boot \
	--exclude=/var/log \
	--exclude=/tmp \
	--one-file-system  /

    tar cpzf /bakup/boot"$(date +%Y%m%d_%H%M)".tgz --one-file-system  /boot

#you can retore as :
# tar -xpzf /path/to/root.tar.gz -C / --numeric-owner
# tar -xpzf /path/to/boot.tar.gz -C /boot --numeric-owner

exit $?
