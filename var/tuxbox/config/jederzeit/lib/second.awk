#!/bin/awk -f
BEGIN {
	serie="Serien";
	film="Filme";
	welt="Welt";
}

/Serie/ {
	print $0 > serie;
	next;
}
/Welt/ {
    print $0 > welt;
    next;
}
/Film/ {
	print $0 > film;
	next;
}
