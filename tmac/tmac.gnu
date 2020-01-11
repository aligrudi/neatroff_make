.\" Groff compatibility registers and macros
.\"
.nr yr \n[.yr]-1900
.nr year \n[.yr]
.\" Groff file I/O macros
.de open
.	ds gnufile\\$1 "\\$2
.	rm gnudata\\$1
..
.de opena
.	ds gnufile\\$1 "\\$2
.	co< \\*[gnudata\\$1] "\\$2
..
.de close
.	co> gnudata\\$1 "\\*[gnufile\\$1]
..
.de write
.	am gnudata\\$1 write.end
\\$2
.	write.end
..
.de writec
.	as gnudata\\$1 "\\$2
..
.de writem
.	co+ gnudata\\$1 \\$2
..
.\" Miscellaneous macros
.de pso . sy
.	sy \\$1 >/tmp/pso.\n($$
.	so /tmp/pso.\n($$
.	sy rm /tmp/pso.\n($$
..
.de mso
.	so \n(.D/\\$1.tmac
.	so \n(.D/tmac.\\$1
..
.de device . dv
.	dv \\$1
..
.de dei . de
.	de \\*[\\$1] \\*[\\$2]
..
.de ami . am
.	am \\*[\\$1] \\*[\\$2]
..
.de kern
.	ie (\\n(.$=0):(\\$1) .kn 1
.	el .kn 0
..
