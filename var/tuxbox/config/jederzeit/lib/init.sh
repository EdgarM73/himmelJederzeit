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
	fi
	
}

makeConfig() {
	log "startin function: makeConfig" 
	if [ ! -f ${jederzeitdir}himmelJederzeit.cfg ];
	then
		echo "Es gibt bereits eine Konfiguration, soll sie ersetzt werden? (J/N)"
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
		echo -n "Wo werden Filme gespeichert, bitte mit abschließendem / ( default: /media/sda1/movies/ )? #"
		read mediaVerzeichnis
		if [[ $mediaVerzeichnis == ""  ]];
		then
			mediaVerzeichnis=/media/sda1/movies/
			break;
		elif [[ -d $mediaVerzeichnis && `expr match "$mediaVerzeichnis" '.*/$'` -gt 0 ]]
		then
			break;
		fi
	done

	echo -n "Von wann bis wann darf aufgenommen werden (format: 23:00-20:00 oder 06:00-18:00, Leer für immer)? #"
	read timeSpan

	echo -n "Sollen Abenteuerfilme aufgenommen werden ( J/N default:J ))? #"
	read Adventure
	if [[ "$Adventure" == "j" || "$Adventure" == "J" || "$Adventure" == "" ]];
	then
		Adventure=0
	else
		Adventure=1
	fi

	echo -n "Sollen Actionfilme aufgenommen werden ( J/N default:J ))? #"
	read Action
	if [[ "$Action" == "j" || "$Action" == "J" || "$Action" == "" ]];
	then
		Action=0
	else
		Action=1
	fi

	echo -n "Sollen Drama aufgenommen werden ( J/N default:J ))? #"
	read Drama
	if [[ "$Drama" == "j" || "$Drama" == "J" || "$Drama" == "" ]];
	then
		Drama=0
	else
		Drama=1
	fi

	echo -n "Sollen Familienfilme aufgenommen werden ( J/N default:J ))? #"
	read Family
	if [[ "$Family" == "j" || "$Family" == "J" || "$Family" == "" ]];
	then
		Family=0
	else
		Family=1
	fi
	
	echo -n "Sollen Horrorfilme aufgenommen werden ( J/N default:J ))? #"
	read Horror
	if [[ "$Horror" == "j" || "$Horror" == "J" || "$Horror" == "" ]];
	then
		Horror=0
	else
		Horror=1
	fi

	echo -n "Sollen Comedyfilme aufgenommen werden ( J/N default:J ))? #"
	read Comedy
	if [[ "$Comedy" == "j" || "$Comedy" == "J" || "$Comedy" == "" ]];
	then
		Comedy=0
	else
		Comedy=1
	fi

	echo -n "Sollen ScienceFiction und Fantasyfilme aufgenommen werden ( J/N default:J ))? #"
	read SciFi
	if [[ "$SciFi" == "j" || "$SciFi" == "J" || "$SciFi" == "" ]];
	then
		SciFi=0
	else
		SciFi=1
	fi

	echo -n "Sollen Thriller aufgenommen werden ( J/N default:J ))? #"
	read Thriller
	if [[ "$Thriller" == "j" || "$Thriller" == "J" || "$Thriller" == "" ]];
	then
		Thriller=0
	else
	Thriller=1
	fi

	echo -n "Sollen Western aufgenommen werden ( J/N default:J ))? #"
	read Western
	if [[ "$Western" == "j" || "$Western" == "J" || "$Western" == "" ]];
	then
		Western=0
	else
		Western=1
	fi

	cp ${jederzeitdir}himmelJederzeit.cfg.template ${jederzeitdir}himmelJederzeit.cfg
	
	log "Template copied to cfg file "

	sedConfigFile "bouqueId" $bouquetId
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
	sed -e 's#%%$1%%#$2#' ${jederzeitdir}himmelJederzeit.cfg > ${jederzeitdir}himmelJederzeit.cfg.tmp
	mv ${jederzeitdir}himmelJederzeit.cfg.tmp ${jederzeitdir}himmelJederzeit.cfg
	
}

setUp() {
	log "startin function: setUp" 
	mkdir -p $tmp $output
}