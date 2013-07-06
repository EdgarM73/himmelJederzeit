#!/bin/sh
touch /var/tuxbox/config/jederzeit/gelaufen
/bin/dt -t"Rebooting..."
sleep 3
/bin/sync
sleep 2
/sbin/reboot
