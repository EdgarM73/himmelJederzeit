#!/bin/awk -f
BEGIN {
	start=0;
}

// {
	gsub ("<td>","");
	gsub ("</td>","|");
	gsub ("<tr>","");
	gsub ("</tr>","");
	gsub(/\r/,"")
	
	
}

/Tabelle zum austauschen Ende/ {
	start=0;
	next;
}

/id="demo"/ {
	start=1;
	next;
}

/Select|table|thead|tbody/ {
	next;
}

// {
	if ( start == 1 ) {
		print $0;
	}
	next;
}


// {
	start=0;
	next;
}

END {
}
