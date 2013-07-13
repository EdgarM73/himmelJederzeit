#!/bin/sh
###############################################################################
#
# EPGscan.sh 0.97 vanhofen [NG-Team] (basiert auf einer Idee von SnowHead)
#
# Ziel:
# Jeden ersten TV-Kanal eines Transponders in den Bouquets fuer EPG-
# Aktualisierung anzappen.
# Erster Aufruf des Skripts dauert lange, da die Datei EPGscan.dat erstellt
# wird (mit einem Kanal pro Transponder). Die Datei kann danach auch manuell
# bearbeitet werden.
# Bei einem Durchlauf wird jeder Sender für 15 Sekunden eingeschaltet.
# Das sollte für die EPG Daten ausreichen.
# Bei laufenden Aufnahmen wird gewartet, bis die Aufnahme fertig ist.
#
# Parameter einstellbar in /var/tuxbox/config/EPGscan.conf:
# * Wartezeit pro Sender in Sekunden		(wait_period=<sec>)
# * Löschen von gespeicherten EPG-Daten		(del_epgstore=0|1)
# * Löschen von gecachten EPG-Daten		(del_epgcache=0|1)
# * Standby-Modus nach dem Zappen erzwingen	(force_standby=0|1)
# * Zappen nur im Standby-Modus starten		(need_standby=0|1)
# * mit 'rcsim' zu den Favoriten zurück zappen	(rezap_hack=0|1)
# * pr-auto-timer nach Zappen starten		(pr_auto_timer=0|1)
#
###############################################################################

create_DATFILE() {
	console "creating $DATFILE"
	fbpopup "Erzeuge Kanalliste... Das kann etwas dauern."
	echo -e "# $DATFILE: data for automatic epg-scan\n#" > $DATFILE
	while read tag line
	do
		case ${tag:1:1} in
			"T") # transponder
				tsid=$(echo $line | cut -d'"' -f2)
				done=
				continue
			;;
			"S") # service
				test $done 								&& continue
				echo $line | grep -E 't="1"|t="11"|t="16"|t="19"|t="d3"' > /dev/null	|| continue

				chid=$(echo $line | cut -d'"' -f2 | sed -e 's/^0*//')
				name=$(echo $line | cut -d'"' -f4)

				grep "i=\"$chid\" n=\"$name\"" $bouquets > /dev/null			|| continue
				test $(echo "$name" | sed 's/[[:print:]]//g')				&& continue
				
				console "found on TS $tsid: $name"
				echo "$tsid" "$name" >> $DATFILE
				done=$tsid
			;;
		esac
	done < $services
	fbpopup "Kanalliste erzeugt. Beginne Zapping..."
	console "$DATFILE created"
}

fbpopup() {
	wget -q -O /dev/null -Y off $hturl/control/message?popup="${0##*/}%0A${@}"
}

console() {
	echo -e "\033[40;0;33m[${0##*/}] ${@}\033[0m"
}

KILLFILE=/tmp/EPGscan.kill

exist_KILLFILE() {
	abort=false
	ret=1
	if [ -e $KILLFILE ]
	then
		fbpopup "Breche EPGscan ab."
		console "aborting scan"
		abort=true
		ret=0
	fi
	return $ret
}

cleanup() {
	rm -f $KILLFILE
}

eXit() {
	cleanup
	exit $1
}

sig_handler() {
	console "Signal caught - will exiting asap"
	touch $KILLFILE
}

case "$1" in
	-b)
		console "go ahead"

		CONFIGDIR="/var/tuxbox/config"

		neutrino=${CONFIGDIR}"/neutrino.conf"
		services=${CONFIGDIR}"/zapit/services.xml"

		if [ -e ${CONFIGDIR}"/zapit/ubouquets.xml" ]
		then
			bouquets=${CONFIGDIR}"/zapit/ubouquets.xml"
		else
			bouquets=${CONFIGDIR}"/zapit/bouquets.xml"
		fi

		# ensure to get access to controlapi
		nhttpd=${CONFIGDIR}"/nhttpd.conf"
		htauth=$(grep "^mod_auth.authenticate"	$nhttpd | cut -d"=" -f2)
		htuser=$(grep "^mod_auth.username"	$nhttpd | cut -d"=" -f2)
		htpass=$(grep "^mod_auth.password"	$nhttpd | cut -d"=" -f2)
		htport=$(grep "^WebsiteMain.port"	$nhttpd | cut -d"=" -f2)
		if [ "$htauth" = "true" ]; then
			hturl="http://$htuser:$htpass@127.0.0.1:$htport"
		else
			hturl="http://127.0.0.1:$htport"
		fi

		DATFILE=${CONFIGDIR}"/EPGscan.dat"
		CONFIGFILE=${CONFIGDIR}"/EPGscan.conf"

		# create .dat if necessary
		test -e $DATFILE || create_DATFILE

		# read/parse keywords in .conf
		test -e $CONFIGFILE && . $CONFIGFILE 2> /dev/null

		case $wait_period in
			''|*[!0-9]*) wait_period=15 ;;
		esac

		# wait until standby (or timeout) if desired
		if [ "$need_standby" = "1" ]
		then
			t=81
			m=$t
			while [ $(wget -q -O - $hturl/control/standby | dos2unix -u) = "off" ]
			do
				if [ ${t:1:1} -eq ${t:0:1} ]; then
					console "timeout reached - exiting undone"
					eXit 1
				fi
				t=$((t+1))
				console "wait until standby (or timeout)"
				sleep 900
			done
			test $t -ne $m && sleep 60 # a safety sleep
		fi

		# wait while recording
		while [ $(wget -q -O - $hturl/control/setmode?status | dos2unix -u) = "on" ]
		do
			fbpopup "Eine Aufnahme laeuft. Ich warte..."
			console "wait while recording"
			sleep 900
		done

		# remember standby-mode
		standby=$(wget -q -O - $hturl/control/standby | dos2unix -u)

		# leave standby-mode if necessary
		if [ "$standby" = "on" ]
		then
			console "leave standby-mode"
			wget -q -O /dev/null $hturl/control/standby?off
			sleep 10
		fi

		# remove stored epg-data if desired and allowed
		epg_save=$(grep "^epg_save=" $neutrino | cut -d'=' -f2)
		if [ "$del_epgstore" = "1" -a "$epg_save" = "true" ]
		then
			console "remove stored epg-data"
			epg_dir=$(grep "^epg_dir=" $neutrino | cut -d'=' -f2)
			test $epg_dir && rm -f $epg_dir/*.*
		fi

		# remove cached epg-data if desired
		if [ "$del_epgcache" = "1" ]
		then
			sectionsdcontrol --freemem > /dev/null
		fi

		# catch some signals from here till end
		trap sig_handler INT TERM

		# remember volume-level and turn mute
		volume=$(wget -q -O - $hturl/control/volume | dos2unix -u)
		pzapit -vol 0 > /dev/null

		# remember current channel
		curr=$(pzapit -gi | cut -d' ' -f1)

		# get new epg-data
		while read tsid chan
		do
			test "${tsid:0:1}" = "#" && continue

			fbpopup "Verbleibe auf TS $tsid fuer $wait_period Sekunden."
			console "stay on TS $tsid ($chan) for $wait_period seconds"

			pzapit -n "$chan" > /dev/null

			i=0
			while [ $i -lt $wait_period ]
			do
				i=$((i+1))
				sleep 1
				exist_KILLFILE && break
			done

			test "$abort" = "true" && break
		done < $DATFILE

		# rezap
		pzapit -zi $curr

		if [ "$rezap_hack" = "1" ]
		then
			keys="FAVORITES OK OK"
			for key in $keys
			do
				# a terrible solution :/
				rcsim KEY_${key} && sleep 1
			done
		fi

		# pump up the volume
		pzapit -vol $volume > /dev/null

		# enter standby-mode if necessary or desired
		if [ "$standby" = "on" -o "$force_standby" = "1" ]
		then
			console "enter standby-mode"
			wget -q -O /dev/null $hturl/control/standby?on
		fi

		# start pr-auto-timer if desired and found
		if [ "$pr_auto_timer" = "1" -a -x /lib/tuxbox/plugins/pr-auto-timer ]
		then
			console "start pr-auto-timer"
			/lib/tuxbox/plugins/pr-auto-timer --menu &
		fi

		console "done."
		eXit 0
	;;
	*)
		if ps -ef | grep '[E]PGscan.sh -b' > /dev/null
		then
			touch $KILLFILE
		else
			($0 -b > /dev/console) &
		fi
	;;
esac

exit 0
