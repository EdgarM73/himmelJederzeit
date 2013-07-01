#!/bin/sh

# Arg1 Variable for Filmtype
# Arg2 English String for Filmtype
# Arg3 German Name for Filmtype
_removeUnwanted() {
	log "startin function: _removeUnwanted" 
	log "testing now "${1} " mit " ${2}  ":" ${3} "<--" 
	if [[ ${1} == 0 ]]; then
		log ${3}" sind nicht erwünscht, werden gelöscht" 
		grep -v ${2} $filmFile > ${tmp_file}
		mv ${tmp_file} $filmFile
	fi
}

removeUnwanted() {
	log "startin function: removeUnwanted"
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