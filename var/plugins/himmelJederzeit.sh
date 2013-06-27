platform=`uname`

pwd=`pwd`
var=`dirname $pwd`
root=`dirname $var`
#root=${root}"/"
		
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

lib=$jederzeitdir"lib/"
tmp_file=${tmp}"tmp_file"
wgetDirectory=${tmp}"wget"

source ${jederzeitdir}himmelJederzeit.cfg
source ${lib}sky.sh
source ${lib}bouquet.sh
source ${lib}cleanup.sh

source ${lib}createTargetStructure.sh
source ${lib}unwanted.sh

source ${lib}init.sh
source ${lib}main.sh

# cleanup all files not needed for deployement


log() {
	#Log message to log file
	#$*: Log message
	if [ "$log" != "" ]; then
		echo -e $(date +'%F %H:%M:%S') [$$]: "$*" >> $log
	fi
}

init

case $1 in
	"cleanup")
		cleanUp
	;;
	"connect" )
		getHTML
	;;
	"full" )
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
		cleanUp
		setUp
		awkInfos
		Stand
		removeAlreadyTimedEntries
		removeUnwanted
	;;
	
esac
