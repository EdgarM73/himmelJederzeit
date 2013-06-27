#!/bin/sh

awkInfos() {
	log "startin function: awkInfos" 
	if [ ! -f $anytime ]; then
		echo "anytime ist nicht vorhanden!"
		exit 1 
	fi

	echo -en "\n\n...entferne die Wolken vom Himmel..."
	log "parse anytime auf Infos" 
	cat $anytime | 
	awk -f $lib/first.awk |
	awk -f $lib/second.awk 

	echo -en "\n\n...ziehe die Uhr auf..."
	sort -n  Filme > ${filmFile}
	# sort -n  Serien > ${serienFile}
	# sort -n  Welt > ${weltFile}


	echo -en "\n\n...bereite das Fleisch vor..."
	awk -v timeSpan=$timeSpan -v output_file=${tmp_file} -v bouquet=$bouquetId -v logfile=$log -v mediaVerzeichnis=$mediaVerzeichnis -f $lib/third_autotimer.awk ${filmFile} >> $log
	log "file should be now optimized "
	mv ${tmp_file} ${filmFile}

	echo -en "\n\n...bin jederzeit bereit..."
	log "Anzahl : " `wc -l Filme`
 	# echo "Anzahl : " `wc -l Serien` >> $log
 	# echo "Anzahl : " `wc -l Welt` >> $log

	mkdir -p $tmp
	# mv Filme Serien Welt tmp 
	mv Filme Welt Serien $tmp 

}
