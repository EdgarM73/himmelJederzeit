#!/bin/sh
touch /var/tuxbox/config/jederzeit/gelaufen
wget -q -O - "http://localhost/control/message?popup=himmelJEderzeit%20wurde%20installiert."
wget -q -O - "http://localhost/control/reloadplugins"