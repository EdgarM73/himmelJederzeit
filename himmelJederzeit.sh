#!/bin/bash
output="autotimer/"
tmp="tmp/"
log="../himmelJederzeit.log"


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
  files="${tmp}1 ${tmp}Filme ${tmp}Welt ${tmp}Serien ${output}Filme.sorted ${output}Serien.sorted ${output}Welt.sorted "
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
  #rm -f 1 film.sorted serie.sorted welt.sorted
  #rm -f tmp/*
  #if [ -d tmp ]; then 
  #  rmdir tmp 
  #fi
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

  sort -n Filme > ${output}Filme.sorted
  sort -n Serien > ${output}Serien.sorted
  sort -n Welt > ${output}Welt.sorted

  echo "Anzahl : " `wc -l Filme` >> $log
  echo "Anzahl : " `wc -l Serien` >> $log
  echo "Anzahl : " `wc -l Welt` >> $log
  
  mkdir -p tmp
  mv Filme Serien Welt tmp 
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
  *)
    cleanUp
    setUp
    awkInfos
    ;;
esac
