#!/bin/sh
echo "Die Grundstruktur f&uuml;r himmelJederzeit wird erzeugt"
sed -e 's#hide=0#hide=1#' ./initialisierehimmelJederzeit.cfg > tmp && mv tmp ./initialisierehimmelJederzeit.cfg
cd /var/plugins;./himmelJederzeit.sh initGUI
echo "Dieses Script wird deaktiviert"