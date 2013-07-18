#!/bin/sh

getExistingMovies()
{	
log "starting function getExistingMovies"
	rm -f $existingMoviesFile
#	all_files=`find ${mediaVerzeichnis} -type f -name \*xml -exec ls -1 {} \;`
	all_files=`listdir ${mediaVerzeichnis}`
	for do in $all_files
	do
		`getEpgTitle $do` > $existingMoviesFile
#		cat $do |
#		awk '
#			/epgtitle/{
#			gsub("<epgtitle>","");
#			gsub("</epgtitle>","");
#			gsub("\t","");
#
#			print "\"" $0 "\"";
#			}
#		' >> $existingMoviesFile

	done
	log "end of function getExistingMovies"
}