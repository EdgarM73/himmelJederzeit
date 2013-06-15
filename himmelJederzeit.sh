output="autotimer/"
tmp="tmp/"
log="../himmelJederzeit.log"
FilmName="Filme.sorted"
SerienName="Serien.sorted"
WeltName="Welt.sorted"
filmFile=${output}${FilmName}
serienFile=${output}${SerienName} 
weltFile=${output}${WeltName}
. ./himmelJederzeit.cfg

getHTML() {
  
  if [ -f anytime ]; then
    rm anytime
  fi
  wget --append-output=$log www.sky.de/anytime
  echo "Hole Daten von Sky: '" $# "'" >> $log
}

setUp() {
  mkdir -p tmp autotimer
}

cleanUp () {
  files="${tmp}1 ${tmp}Filme ${tmp}Welt ${tmp}Serien ${filmFile}  ${serienFile} ${weltFile} "
  dirs="tmp autotimer"
  
  for do in $files
  do
    if [ -f $do ]; then
      rm $do
    fi
  done
  
  for do in $dirs
  do
    echo "testing $do"
    if [ -d $do ]; then
      echo "deleting" $do
      rmdir $do
    fi
  done
}

awkInfos() {
  if [ ! -f anytime ]; then
    echo "anytime ist nicht vorhanden!"
    exit 1 
  fi
  
  echo "parse anytime auf Infos" >> $log
  cat anytime | 
  awk -f lib/first.awk |
  awk -f lib/second.awk 

  sort -n  Filme > ${filmFile}
 # sort -n  Serien > ${serienFile}
 # sort -n  Welt > ${weltFile}

  cat ${filmFile} |
  awk -f lib/third.awk > tmp_file
  
  mv tmp_file ${filmFile}
  
  echo "Anzahl : " `wc -l Filme` >> $log
 # echo "Anzahl : " `wc -l Serien` >> $log
 # echo "Anzahl : " `wc -l Welt` >> $log
  
  mkdir -p tmp
 # mv Filme Serien Welt tmp 
  mv Filme tmp 
  
}
#
#Abenteuer 
#Action
#Drama &amp; Emotion
#Drama &amp; Emotion 
#Drama &amp;  Emotion
#Familie
#Horror
#Komödie
#Sci-Fi &amp; Fantasy
#Thriller
#Western
#

removeUnwanted() {
  
  if [[ $Adventure == 1 ]]; then
    grep -v "Adventure" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Action == 1 ]]; then
    grep -v "Action" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Drama == 1 ]]; then
    grep -v "Drama" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Family == 1 ]]; then
    grep -v "Family" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Horror == 1 ]]; then
    grep -v "Horror" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Comedy == 1 ]]; then
    grep -v "Comedy" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $SciFi == 1 ]]; then
    grep -v "SciFi" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Thriller == 1 ]]; then
    grep -v "Thriller" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Western == 1 ]]; then
    grep -v "Western" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
}


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
    ;;
  "removeUnwanted" )
    removeUnwanted
    ;;
  *)
    cleanUp
    setUp
    awkInfos
    ;;
    
esac
