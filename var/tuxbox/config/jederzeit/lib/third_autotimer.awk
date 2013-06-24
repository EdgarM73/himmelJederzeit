#!/bin/awk -f
BEGIN {
FS = "|";
ausgabe = "starting match for Typereplacement:";
ausgabe = ausgabe "\nBouquet Nr.:"bouquet ;
hans=1;
}
// {

  if ( substr($7,0,3) == "Kom" )
  {
    $7 = "Comedy";
  }
  if ( substr($7,0,6) == "Sci-Fi") 
  {
    $7 = "SciFi";
  }
  if ( substr($7,0,5) == "Drama") 
  {
    $7 = "Drama";
  }
  if ( substr($7,0,9) =="Abenteuer" )
  {
    $7 = "Adventure";
  }
  if ( substr($7,0,7) =="Familie")
  {
    $7 = "Family";
  }
 
 # if ( substr($5,2,1) != "n" )
 # {
 # printf("*1|%s|%s|%s|%s\n",$1,$2,$5,$6,$7)    
 # }
 # else
 # {
    printf("*%s;*;%s;O;%sanytime/%s\n",bouquet,$2,mediaVerzeichnis,$7) >> output_file
 # }
}
END {
print ausgabe;
}