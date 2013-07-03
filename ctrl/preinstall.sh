#!/bin/sh
mkdir /var/tuxbox/config/jederzeit
mkdir /var/tuxbox/config/jederzeit/lib
killall start_neutrino
sleep 2
killall neutrino
sleep 5
/bin/dt -t"Updating..."
sleep 3
