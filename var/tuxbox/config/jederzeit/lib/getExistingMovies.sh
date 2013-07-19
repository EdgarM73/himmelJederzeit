#!/bin/sh

getExistingMovies()
{
log "starting function getExistingMovies"
		rm -f /media/sda1/movies/myFile
        rm -f $existingMoviesFile
        listdir ${mediaVerzeichnis}
        for do in `cat /media/sda1/movies/myFile`
        do
        	echo
                getEpgTitle $do >> $existingMoviesFile
        done
        log "end of function getExistingMovies"
}
