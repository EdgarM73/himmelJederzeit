#!/bin/sh
echo "Die Grundstruktur f&uuml;r himmelJederzeit wird erzeugt"
cd /var/plugins;./himmelJederzeit.sh initGUI
echo "Dieses Script wird deaktiviert"
sed -e 's#hide=0#hide=1#' /lib/tuxbox/plugins/InitialisierehimmelJederzeit.cfg > /lib/tuxbox/plugins/tmp && mv /lib/tuxbox/plugins/tmp /lib/tuxbox/plugins/InitialisierehimmelJederzeit.cfg
cd /var/plugins;./himmelJederzeit.sh full