#!/bin/sh
# Copyright (C) 2013-2013  Erdal Akkaya, erdal@akkaya.info
#
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA

# Related files:
#	Configuration:		/var/tuxbox/config/jederzeit/pr-auto-timer.conf
#	AutoTimer file:		/var/tuxbox/config/jederzeit/autotimer/Filme.sorted
#	Neutrino plugin:	/lib/tuxbox/plugins/himmelJederzeit.{sh,cfg}
#	Executable:			/var/plugins/himmelJederzeit.sh
#	Logfile:			/tmp/himmelJederzeit.sh

# Todo:
#
#	- 

# Changelog:
#
# 1.0RC1
#	-added method to remove all movies stored on the hdd already to be timed again
#	-added proper target directory
#	-added new pictures to installation
#	-added new Text for installation
#	-removed reboot after installation as not needed
#	-removed wrong entries after installation in cfg file, added comment tag
#	-created two files while runtime 1: all movies on disk 2: all already found entries in Filme.sorted by autotimer ...
#   ...( regardless if really saved or not)
#
# 0.9 beta3
#	-added installation Script"
#	-added Neutrino Plugin for init and for runtime
#

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
export filmDeletionFile=${output}"deletionFilmFile"
export deletionExecutionFile=${output}"executeDeletion.sh"
filmFilePrevious=${output}${FilmName}".orig"
filmStatusFile=${output}${FilmStatusName}
serienFile=${output}${SerienName} 
weltFile=${output}${WeltName}

lib=$jederzeitdir"lib/"
tmp_file=${tmp}"tmp_file"
wgetDirectory=${tmp}"wget/"

log() {
	#Log message to log file
	#$*: Log message
	if [ "$log" != "" ]; then
		echo -e $(date +'%F %H:%M:%S') [$$]: "$*" >> $log
	fi
}


source ${lib}sky.sh
source ${lib}bouquet.sh
source ${lib}cleanup.sh

source ${lib}createTargetStructure.sh
source ${lib}unwanted.sh

source ${lib}init.sh
source ${lib}main.sh
source ${lib}getExistingMovies.sh

# cleanup all files not needed for deployement

if [ ! -f ${jederzeitdir}himmelJederzeit.cfg ]
then
	cp ${jederzeitdir}himmelJederzeit.cfg.template ${jederzeitdir}himmelJederzeit.cfg		
fi
removeWrongEntriesFromConfigFile() {
	grep -v "\[" ${jederzeitdir}himmelJederzeit.cfg > ${tmp_file}
	mv ${tmp_file} ${jederzeitdir}himmelJederzeit.cfg
	
}
	
removeWrongEntriesFromConfigFile

source ${jederzeitdir}himmelJederzeit.cfg
getMediaDirectory
length=`echo ${#mediaVerzeichnis}`
last_string=`echo $mediaVerzeichnis | cut -c${length}`
if [[ $last_string != "/" ]];then
	mediaVerzeichnis=${mediaVerzeichnis}"/"
fi

export existingMoviesFile=${mediaVerzeichnis}"existingMovies"
export allXMLFiles=${mediaVerzeichnis}"myFile"
getExistingMovies
rm $allXMLFiles




case $1 in
	"initGUI" )
		initGUI
	;;
	"init" )
		init
	;;
	"cleanup")
		cleanUp
	;;
	"connect" )
		getHTML
	;;
	"deleteFiles" )
	echo "existingMoviesFile="$existingMoviesFile
	echo "deletionExecutionFile="$deletionExecutionFile
	echo "filmDeletionFile="$filmDeletionFile
	
		deleteFiles
	;;
	"full" )
		getHimmelJederzeitBouquet
		cleanUp
		setUp
		getHTML
		awkInfos
		Stand
		removeAlreadyTimedEntries
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
		getHimmelJederzeitBouquet
		cleanUp
		setUp
		awkInfos
		Stand
		removeAlreadyTimedEntries
		removeUnwanted
	;;
	
esac
