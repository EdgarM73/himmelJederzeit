#!/bin/sh

cleanUp () {
	log "startin function: cleanup" 
	if [ -f $filmFile ]; then
		Stand
		cp $filmFile ${filmFilePrevious}
	fi
	
	files="${tmp}1 ${tmp}Filme ${tmp}Welt ${tmp}Serien ${filmFile}  ${serienFile} ${weltFile} "
	dirs="${wgetDirectory} ${tmp}"
	
	for do in $files
	do
		if [ -f $do ]; then
			rm $do
		fi
	done
  
#	for do in $dirs
#	do
#		log "testing $do"
#		if [ -d $do ]; then
#			log "deleting" "$do"
#			rmdir $do
#		fi
#	done
}

removeAlreadyTimedEntries () {
	log "startin function: removeAlreadyTimedEntries" 
	for do in `cut -d";" -f3 ${filmStatusFile} | sed -e 's/ /(/g'`;
	do
		string=`echo $do | sed -e 's/(/ /g'`
		grep -v "${string}" ${filmFile} > ${tmp_file}
		mv ${tmp_file} ${filmFile}
		log "Filme aufgenommen:" ${string}
	done
}

Stand () {
	log "startin function: Stand" 
	cp ${filmFile} $filmFilePrevious
	grep "#" ${filmFile} >> ${filmStatusFile}
	grep -v "#" ${filmFile} > ${tmp_file}
	mv $tmp_file $filmFile
}
