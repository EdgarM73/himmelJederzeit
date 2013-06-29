#!/bin/sh
echo "Die Grundstruktur f&uuml;r himmelJederzeit wird erzeugt"
cd /var/plugins;./himmelJederzeit.sh initGUI
echo "Dieses Script wird deaktiviert"
sed -e 's#hide=0#hide=1#' ./InitialisierehimmelJederzeit.cfg > tmp && mv tmp ./InitialisierehimmelJederzeit.cfg
