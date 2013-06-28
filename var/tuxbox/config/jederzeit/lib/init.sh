#!/bin/sh

addAutotimerConfToPrAutoTimer () {
	log "startin function: addAutoTimerConfToPrAutoTimer" 
	if [[ `grep Filme.sorted ${configdir}pr-auto-timer.conf | wc -l ` -eq 0 ]]; then
		cp ${configdir}pr-auto-timer.conf ${configdir}pr-auto-timer.conf.orig	
		echo "RULE_FILE_EXT=${filmFile}" >> ${configdir}pr-auto-timer.conf 
	fi
}

init() {
	log "startin function: init" 
	log "Testing if initialization has to be done"
	
	if [ ! -f ${jederzeitdir}gelaufen ]; 
	then
		createBouquet
		identifyAndAddChannels
		makeConfig
		addAutotimerConfToPrAutoTimer
		createAnytimeDirectories
		Stand
		removeAlreadyTimedEntries
		touch ${jederzeitdir}gelaufen
		echo -e "Intializierung ist fertig, die Konfigurationsdatei /var/tuxbox/config/jederzeit/himmelJederzeit.cfg ist fertig"
		echo
		echo -e "Es wurde ein neues Bouquet mit der Nr. $bouquetId erstellt, enthalten sind folgende Sender:"
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

makeConfig() {
	log "startin function: makeConfig" 
	if [ ! -f ${jederzeitdir}himmelJederzeit.cfg ];
	then
		echo -en "\nEs gibt bereits eine Konfiguration, soll sie ersetzt werden? (J/N)\t# "
		read answer
		if [[ $answer != "j" && $answer !="J" ]];
		then
			log "Konfiguration nicht angepasst"
			return
		fi
	fi

	getHimmelJederzeitBouquet

	while [ true ];
	do
		echo -en "\nWo werden Filme gespeichert, bitte mit abschließendem / ( default: /media/sda1/movies/ )?\t# "
		read mediaVerzeichnis
		if [[ "$mediaVerzeichnis" == ""  ]];
		then
			mediaVerzeichnis="/media/sda1/movies/"
			break;
		elif [[ -d $mediaVerzeichnis && `expr match "$mediaVerzeichnis" '.*/$'` -gt 0 ]]
		then
			break;
		fi
	done
	
	echo -en "\nVon wann bis wann darf aufgenommen werden (format: 23:00-20:00 oder 06:00-18:00, Leer für immer)?\t# "
	read timeSpan

	echo -en "\nSollen Abenteuerfilme aufgenommen werden ( J/N default:J ))?\t# "
	read Adventure
	if [[ "$Adventure" == "j" || "$Adventure" == "J" || "$Adventure" == "" ]];
	then
		Adventure=0
	else
		Adventure=1
	fi

	echo -en "\nSollen Actionfilme aufgenommen werden ( J/N default:J ))?\t# "
	read Action
	if [[ "$Action" == "j" || "$Action" == "J" || "$Action" == "" ]];
	then
		Action=0
	else
		Action=1
	fi

	echo -en "\nSollen Drama aufgenommen werden ( J/N default:J ))?\t# "
	read Drama
	if [[ "$Drama" == "j" || "$Drama" == "J" || "$Drama" == "" ]];
	then
		Drama=0
	else
		Drama=1
	fi

	echo -en "\nSollen Familienfilme aufgenommen werden ( J/N default:J ))?\t# "
	read Family
	if [[ "$Family" == "j" || "$Family" == "J" || "$Family" == "" ]];
	then
		Family=0
	else
		Family=1
	fi
	
	echo -en "\nSollen Horrorfilme aufgenommen werden ( J/N default:J ))?\t# "
	read Horror
	if [[ "$Horror" == "j" || "$Horror" == "J" || "$Horror" == "" ]];
	then
		Horror=0
	else
		Horror=1
	fi

	echo -ne "\nSollen Comedyfilme aufgenommen werden ( J/N default:J ))?\t# "
	read Comedy
	if [[ "$Comedy" == "j" || "$Comedy" == "J" || "$Comedy" == "" ]];
	then
		Comedy=0
	else
		Comedy=1
	fi

	echo -en "\nSollen ScienceFiction und Fantasyfilme aufgenommen werden ( J/N default:J ))?\t# "
	read SciFi
	if [[ "$SciFi" == "j" || "$SciFi" == "J" || "$SciFi" == "" ]];
	then
		SciFi=0
	else
		SciFi=1
	fi

	echo -en "\nSollen Thriller aufgenommen werden ( J/N default:J ))?\t# "
	read Thriller
	if [[ "$Thriller" == "j" || "$Thriller" == "J" || "$Thriller" == "" ]];
	then
		Thriller=0
	else
	Thriller=1
	fi

	echo -en "\nSollen Western aufgenommen werden ( J/N default:J ))?\t# "
	read Western
	if [[ "$Western" == "j" || "$Western" == "J" || "$Western" == "" ]];
	then
		Western=0
	else
		Western=1
	fi

	cp ${jederzeitdir}himmelJederzeit.cfg.template ${jederzeitdir}himmelJederzeit.cfg
	
	log "Template copied to cfg file "

	sedConfigFile "bouquetId" $bouquetId
	sedConfigFile "mediaVerzeichnis" "$mediaVerzeichnis"
	sedConfigFile "timeSpan" $timeSpan
	sedConfigFile "Drama" $Drama
	sedConfigFile "Action" $Action
	sedConfigFile "Adventure" $Adventure
	sedConfigFile "Family" $Family
	sedConfigFile "Horror" $Horror
	sedConfigFile "Comedy" $Comedy
	sedConfigFile "SciFi" $SciFi
	sedConfigFile "Thriller" $Thriller
	sedConfigFile "Western" $Western

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