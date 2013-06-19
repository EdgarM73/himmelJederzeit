platform=`uname`

pwd=`pwd`
var=`dirname $pwd`
root=`dirname $var`
root=${root}"/"
		
FilmName="Filme.sorted"
SerienName="Serien.sorted"
WeltName="Welt.sorted"

log=${root}"tmp/himmelJederzeit.log"
configdir=${root}"var/tuxbox/config/"

jederzeitdir=${configdir}"jederzeit/"
output=$jederzeitdir"autotimer/"
tmp=${jederzeitdir}"tmp/"
anytime=$jederzeitdir"anytime"

filmFile=${output}${FilmName}
serienFile=${output}${SerienName} 
weltFile=${output}${WeltName}

lib=$jederzeitdir"lib"

. ${jederzeitdir}himmelJederzeit.cfg

getHTML() {
  
if [ -f $anytime ]; then
    rm $anytime
  fi
  wget -O $anytime http://www.sky.de/anytime -U "Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20100101 Firefox/10.0.2" --header="Accept-Language: en-us,en;q=0.5" --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" --header="Connection: keep-alive"
  echo "Hole Daten von Sky: '" $# "'" >> $log
}

setUp() {
  mkdir -p $tmp $output
}

cleanUp () {
  files="${tmp}1 ${tmp}Filme ${tmp}Welt ${tmp}Serien ${filmFile}  ${serienFile} ${weltFile} "
  dirs=$tmp $autotimer
  
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
  if [ ! -f $anytime ]; then
    echo "anytime ist nicht vorhanden!"
    exit 1 
  fi
  
  echo "parse anytime auf Infos" >> $log
  cat $anytime | 
  awk -f $lib/first.awk |
  awk -f $lib/second.awk 

  sort -n  Filme > ${filmFile}
 # sort -n  Serien > ${serienFile}
 # sort -n  Welt > ${weltFile}

 
  cat ${filmFile} |
 awk -v logfile=$log -f $lib/third.awk > tmp_file
  
echo "file should be now optimized " >> $log
  mv tmp_file ${filmFile}
  
  echo "Anzahl : " `wc -l Filme` >> $log
 # echo "Anzahl : " `wc -l Serien` >> $log
 # echo "Anzahl : " `wc -l Welt` >> $log
  
  mkdir -p $tmp
 # mv Filme Serien Welt tmp 
  mv Filme $tmp 
  
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
    echo "Abenteuer sind nicht erwünscht, werden gelöscht" >> $log
    grep -v "Adventure" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Action == 1 ]]; then
    echo "Action ist nicht erwünscht, werden gelöscht" >> $log
    grep -v "Action" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Drama == 1 ]]; then
    echo "Drama sind nicht erwünscht, werden gelöscht" >> $log
    grep -v "Drama" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Family == 1 ]]; then
  
    echo "Familienfilme sind nicht erwünscht, werden gelöscht" >> $log
    grep -v "Family" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Horror == 1 ]]; then 
    echo "Horror ist nicht erwünscht, werden gelöscht" >> $log
    grep -v "Horror" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Comedy == 1 ]]; then
  
    echo "Comedy ist nicht erwünscht, werden gelöscht" >> $log
    grep -v "Comedy" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $SciFi == 1 ]]; then
    echo "SciFi ist nicht erwünscht, werden gelöscht" >> $log
    grep -v "SciFi" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Thriller == 1 ]]; then
    echo "Thriller sind nicht erwünscht, werden gelöscht" >> $log
    grep -v "Thriller" $filmFile > tmp_file
    mv tmp_file $filmFile
  fi
  
  if [[ $Western == 1 ]]; then
    echo "Western sind nicht erwünscht, werden gelöscht" >> $log
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
	removeUnwanted
    ;;
  "removeUnwanted" )
    removeUnwanted
    ;;
  *)
    cleanUp
    setUp
    awkInfos
    removeUnwanted
    ;;
    
esac
