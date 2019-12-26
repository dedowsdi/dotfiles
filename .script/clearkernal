#!/bin/bash

#dpkg -l linux-{image,headers}-"[0-9]*"       list all kernal packages
#awk '/^ii/{print $2}'						  regex match line start with ii, print it
#uname -r | sed -r 's/-[a-z]+//'			  get front part of current kernal name

apt-get purge $(dpkg -l linux-{image,headers}-"[0-9]*" | awk '/^ii/{print $2}' | grep -ve "$(uname -r | sed -r 's/-[a-z]+//')")
