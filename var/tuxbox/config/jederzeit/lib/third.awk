#!/bin/awk -f
BEGIN {
FS = "|";
ausgabe = "";
}
// {
  if ( match($7,"Kom.*ie") )
  {
    $7 = "Comedy";
  }
  if ( match($7,"Sci-Fi.*") )
  {
    $7 = "SciFi";
  }
  if ( match($7,"Drama.*") )
  {
    $7 = "Drama";
  }
  if ( match($7,"Abenteuer") )
  {
    $7 = "Adventure";
  }
  if ( match($7,"Familie") )
  {
    $7 = "Family";
  }
 
  if ( $5 != "&nbsp;" )
  {
    printf("%s|%s|%s|%s|%s\n",$1,$2,$5,$6,$7)    
  }
  else
  {
   printf("%s|%s|%s|%s|%s\n",$1,$2,$5,$6,$7)
  }
}