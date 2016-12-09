#!/bin/bash
./b2 install \
    --with-date_time \
    --with-regex \
    --with-filesystem \
    --with-program_options \
    --with-thread \
    --with-atomic \
    --with-chrono
ln -s `pwd` /var/www/html/boost 
