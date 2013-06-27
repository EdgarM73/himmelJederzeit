#!/bin/sh

createAnytimeDirectories () {
	log "startin function: createAnytimeDirectories" 
	
	mkdir -p $mediaVerzeichnis"anytime/Adventure"
	mkdir -p $mediaVerzeichnis"anytime/Action"
	mkdir -p $mediaVerzeichnis"anytime/Drama"
	mkdir -p $mediaVerzeichnis"anytime/Family"
	mkdir -p $mediaVerzeichnis"anytime/Horror"
	mkdir -p $mediaVerzeichnis"anytime/Comedy"
	mkdir -p $mediaVerzeichnis"anytime/SciFi"
	mkdir -p $mediaVerzeichnis"anytime/Thriller"
	mkdir -p $mediaVerzeichnis"anytime/Western"
		

}