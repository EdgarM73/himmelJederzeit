#!/bin/sh

getHTML() {
	log "startin function: getHTML" 
	if [ -f $anytime ]; then
		rm $anytime
	fi
	wget -O $anytime http://www.sky.de/anytime -U "Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20100101 Firefox/10.0.2" --header="Accept-Language: en-us,en;q=0.5" --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" --header="Connection: keep-alive"
	log "Hole Daten von Sky: '" $# "'" 
}

