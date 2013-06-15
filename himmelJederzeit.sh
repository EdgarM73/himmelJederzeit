#!/bin/bash
#set -x
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

function getHTML() {
  
  if [ -f anytime ]; then
    rm anytime
  fi
  wget --append-output=$log www.sky.de/anytime
  echo "Hole Daten von Sky: '" $# "'" >> $log
}

function setUp() {
  mkdir -p tmp autotimer
}

function cleanUp () {
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

function awkInfos() {
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

function removeUnwanted() {
  i=0;
  for x in $Adventure $Action $Drama $Family $Horror $Comedy $SciFi $Thriller $Western
  do
    echo "lauf nummer $i" >> $log
    echo " ist gesetzt auf $x" >> $log 
    if [[ $x -eq 1 ]]; then      
      grep -v ${Categories[$i]} ${filmFile} 
      echo ${Categories[$i]} " wird entfernt" >> $log
      cp tmp_file ${filmFile}
    fi

   i=`expr $i + 1`;
  done
  
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
