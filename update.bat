cls

@ECHO OFF

ECHO Install himmelJederzeit Plugin

ECHO Nur fuer Coolstream NG-RETURN Image

ECHO -----------------------------------------------------------------------------------------------------------

ECHO -----------------------------------------------------------------------------------------------------------
ECHO Ist die Konfiguration angepasst? Falls nicht, bitte Fenster schließen
ECHO var/tuxbox/config/jederzeit/himmelJederzeit.cfg.
ECHO -----------------------------------------------------------------------------------------------------------

Pause

ftp -s:config.txt

pause