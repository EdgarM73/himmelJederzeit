platform=`uname`

VERSION=0.18beta
ME=${0##*/}

CONFIG_FILE=/var/tuxbox/config/$ME.conf
PID_FILE=/var/run/$ME.pid

EXIT_SIGNAL=1
EXIT_NO_RULE_FILE=2
EXIT_ALREADY_RUNNING=3

TIMERD_EVENT_TYPE_ZAPTO=3
TIMERD_EVENT_TYPE_RECORD=5

AWK=/bin/awk
CAT=/bin/cat
CUT=/bin/cut
DATE=/bin/date
EGREP=/bin/egrep
GREP=/bin/grep
MKDIR=/bin/mkdir
MKTEMP=/bin/mktemp
MSGBOX=/bin/msgbox
PZAPIT=/bin/pzapit
RM=/bin/rm
SED=/bin/sed
WC=/bin/wc
WGET=/bin/wget


pwd=`pwd`
var=`dirname $pwd`
root=`dirname $var`
root=${root}"/"
		
FilmName="Filme.sorted"
FilmStatusName="Film.status"
SerienName="Serien.sorted"
WeltName="Welt.sorted"

log=${root}"tmp/himmelJederzeit.log"
configdir=${root}"var/tuxbox/config/"

jederzeitdir=${configdir}"jederzeit/"
output=$jederzeitdir"autotimer/"
tmp=${jederzeitdir}"tmp/"
anytime=$jederzeitdir"anytime"

filmFile=${output}${FilmName}
filmFilePrevious=${output}${FilmName}".orig"
filmStatusFile=${output}${FilmStatusName}
serienFile=${output}${SerienName} 
weltFile=${output}${WeltName}

lib=$jederzeitdir"lib"
tmp_file="./tmp_file"

source ${jederzeitdir}himmelJederzeit.cfg

getHTML() {

	if [ -f $anytime ]; then
		rm $anytime
	fi
	wget -O $anytime http://www.sky.de/anytime -U "Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20100101 Firefox/10.0.2" --header="Accept-Language: en-us,en;q=0.5" --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" --header="Connection: keep-alive"
	log "Hole Daten von Sky: '" $# "'" 
}

setUp() {
	mkdir -p $tmp $output
}

# cleanup all files not needed for deployement
cleanUp () {

	if [ -f $filmFile ]; then
		Stand
		cp $filmFile ${filmFilePrevious}
	fi
	
	files="${tmp}1 ${tmp}Filme ${tmp}Welt ${tmp}Serien ${filmFile}  ${serienFile} ${weltFile} "
	dirs=$tmp $autotimer

	for do in $files
	do
		if [ -f $do ]; then
			rm $do
		fi
	done
  
	for do in $dirs
	do
		log "testing $do"
		if [ -d $do ]; then
			log "deleting" $do
			rmdir $do
		fi
	done
}

awkInfos() {
	if [ ! -f $anytime ]; then
		echo "anytime ist nicht vorhanden!"
		exit 1 
	fi

	log "parse anytime auf Infos" 
	cat $anytime | 
	awk -f $lib/first.awk |
	awk -f $lib/second.awk 

	sort -n  Filme > ${filmFile}
	# sort -n  Serien > ${serienFile}
	# sort -n  Welt > ${weltFile}


	awk -v timeSpan=$timeSpan -v output_file=${tmp_file} -v bouquet=$BouquetId -v logfile=$log -v mediaVerzeichnis=$mediaVerzeichnis -f $lib/third_autotimer.awk ${filmFile} >> $log
	log "file should be now optimized "
	mv ${tmp_file} ${filmFile}

	log "Anzahl : " `wc -l Filme`
 	# echo "Anzahl : " `wc -l Serien` >> $log
 	# echo "Anzahl : " `wc -l Welt` >> $log

	mkdir -p $tmp
	# mv Filme Serien Welt tmp 
	mv Filme Welt Serien $tmp 

}
#
#Abenteuer 
#Action
#Drama &amp; Emotion
#Drama &amp; Emotion 
#Drama &amp;  Emotion
#Familie
#Horror
#Komödie
#Sci-Fi &amp; Fantasy
#Thriller
#Western
#


createAnytimeDirectories () {

		mkdir -p $mediaVerzeichnis"/anytime/Adventure"
		mkdir -p $mediaVerzeichnis"/anytime/Action"
		mkdir -p $mediaVerzeichnis"/anytime/Drama"
		mkdir -p $mediaVerzeichnis"/anytime/Family"
		mkdir -p $mediaVerzeichnis"/anytime/Horror"
		mkdir -p $mediaVerzeichnis"/anytime/Comedy"
		mkdir -p $mediaVerzeichnis"/anytime/SciFi"
		mkdir -p $mediaVerzeichnis"/anytime/Thriller"
		mkdir -p $mediaVerzeichnis"/anytime/Western"
			
	
}

# Arg1 Variable for Filmtype
# Arg2 English String for Filmtype
# Arg3 German Name for Filmtype
_removeUnwanted() {
set +x
log "testing now "${1} " mit " ${2}  ":" ${3} "<--" 
	if [[ ${1} == 1 ]]; then
		log ${3}" sind nicht erwünscht, werden gelöscht" 
		grep -v ${2} $filmFile > ${tmp_file}
		mv ${tmp_file} $filmFile
	fi
set -x
}

removeUnwanted() {

	_removeUnwanted $Adventure "Adventure" "Abenteuer"
	_removeUnwanted $Western "Western" "Western"
	_removeUnwanted $Drama "Drama" "Drama"
	_removeUnwanted $Action "Action" "Action"
	_removeUnwanted $Family "Family" "Familie"
	_removeUnwanted $Horror "Horror" "Horror"
	_removeUnwanted $Comedy "Comedy" "Komödien"
	_removeUnwanted $SciFi "SciFi" "Science Fiction"
	_removeUnwanted $Thriller "Thriller" "Thriller"
}

addAutotimerConfToPrAutoTimer () {
	if [[ `grep Filme.sorted ${configdir}pr-auto-timer.conf | wc -l ` -eq 0 ]]; then
		cp ${configdir}pr-auto-timer.conf ${configdir}pr-auto-timer.conf.orig	
		echo "RULE_FILE_EXT=${filmFile}" >> ${configdir}pr-auto-timer.conf 
	fi
}

log() {
	#Log message to log file
	#$*: Log message
	if [ "$log" != "" ]; then
		echo -e $($DATE +'%F %H:%M:%S') [$$]: "$*" >> $log
	fi
}

removeAlreadyTimedEntries () {
		for do in `cuts -d";" -f3 ${filmStatusFile} | sed -e 's/ /(/g'`;
		do
			echo "vorher?"
			string=`echo $do | sed -e 's/(/ /g'`
			grep -v "${string}" ${filmFile} > ${tmp_file}
			mv ${tmp_file} ${filmFile}
			log "Filme aufgenommen:" ${string}
		done
}

Stand () {
	cp ${filmFile} $filmFilePrevious
	grep "#" ${filmFile} >> ${filmStatusFile}
	grep -v "#" ${filmFile} > ${tmp_file}
	mv $tmp_file $filmFile
}



case $1 in
	"cleanup")
		cleanUp
	;;
	"connect" )
		getHTML
	;;
	"full" )
		addAutotimerConfToPrAutoTimer
		createAnytimeDirectories
		cleanUp
		setUp
		getHTML
		awkInfos
		removeUnwanted
	;;
	"removeUnwanted" )
		removeUnwanted
	;;
	"addAutotimerConfToPrAutoTimer" )
		addAutotimerConfToPrAutoTimer
	;;
	"Stand" )
		Stand
		removeAlreadyTimedEntries
	;;
	*)
		Stand
		removeAlreadyTimedEntries
		addAutotimerConfToPrAutoTimer
		createAnytimeDirectories
		cleanUp
		setUp
		awkInfos
		Stand
		removeAlreadyTimedEntries
		removeUnwanted
	;;
	
esac
