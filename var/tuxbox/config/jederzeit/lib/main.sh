#!/bin/sh

awkInfos() {
	log "startin function: awkInfos" 
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
