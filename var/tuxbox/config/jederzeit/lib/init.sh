#!/bin/sh

addAutotimerConfToPrAutoTimer () {
	log "startin function: addAutoTimerConfToPrAutoTimer" 
	if [[ `grep Filme.sorted ${configdir}pr-auto-timer.conf | wc -l ` -eq 0 ]]; then
		cp ${configdir}pr-auto-timer.conf ${configdir}pr-auto-timer.conf.orig	
		echo "RULE_FILE_EXT=${filmFile}" >> ${configdir}pr-auto-timer.conf 
	fi
}

initGUI() {
	log "startin function: initGUI" 
	log "Testing if initialization has to be done"
	
		cp ${jederzeitdir}himmelJederzeit.cfg.template ${jederzeitdir}himmelJederzeit.cfg
		createBouquet
		identifyAndAddChannels
		getHimmelJederzeitBouquet
		sedConfigFile "bouquetId" $bouquetId
		addAutotimerConfToPrAutoTimer
		createAnytimeDirectories
		Stand
		removeAlreadyTimedEntries
		touch ${jederzeitdir}gelaufen
		echo -e "Intializierung ist fertig, die Konfigurationsdatei /var/tuxbox/config/jederzeit/himmelJederzeit.cfg ist fertig"
		echo
		echo -e "Es wurde ein neues Bouquet 'himmelJederzeit' mit der Nr. $bouquetId erstellt, enthalten sind folgende Sender:"
		echo
		echo -e "\tSky Cinema HD"
		echo -e "\tSky Action HD"
		echo -e "\tSky Hits HD"
		echo -e "\tSky Emotion"
		echo -e "\tSky Emotion"
		echo -e "\tDisney Channel HD"
		echo -e "\tDisney Cinemagic HD"
		echo -e "\tMGM HD"
		echo
		echo
	
}

init() {
	log "startin function: init" 
	log "Testing if initialization has to be done"
	
	if [ ! -f ${jederzeitdir}gelaufen ]; 
	then
		createBouquet
		identifyAndAddChannels
		#makeConfig
		addAutotimerConfToPrAutoTimer
		createAnytimeDirectories
		Stand
		removeAlreadyTimedEntries
		touch ${jederzeitdir}gelaufen
		echo -e "Intializierung ist fertig, die Konfigurationsdatei /var/tuxbox/config/jederzeit/himmelJederzeit.cfg ist fertig"
		echo
		echo -e "Es wurde ein neues Bouquet 'himmelJederzeit' mit der Nr. $bouquetId erstellt, enthalten sind folgende Sender:"
		echo
		echo -e "\tSky Cinema HD"
		echo -e "\tSky Action HD"
		echo -e "\tSky Hits HD"
		echo -e "\tDisney Channel HD"
		echo -e "\tDisney Cinemagic HD"
		echo
		echo
	fi
	
}



sedConfigFile() {
	log "startin function: sedConfigFile" 
	sed -e 's#%%'"$1"'%%#'"$2"'#' ${jederzeitdir}himmelJederzeit.cfg > ${jederzeitdir}himmelJederzeit.cfg.tmp
	mv ${jederzeitdir}himmelJederzeit.cfg.tmp ${jederzeitdir}himmelJederzeit.cfg
	
}

setUp() {
	log "startin function: setUp" 
	mkdir -p $tmp $output $wgetDirectory
	}