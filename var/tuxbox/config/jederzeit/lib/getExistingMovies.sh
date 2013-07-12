#!/bin/sh

getExistingMovies()
{	
	rm -f $existingMoviesFile
	all_files=`find ${mediaVerzeichnis} -type f -name \*xml -exec ls -1 {} \;`
	for do in $all_files
	do

		cat $do |
		awk '
			/epgtitle/{
			gsub("<epgtitle>","");
			gsub("</epgtitle>","");
			gsub("\t","");

			print "\"" $0 "\"";
			}
		' >> $existingMoviesFile

	done
}