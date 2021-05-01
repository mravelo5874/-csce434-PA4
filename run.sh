yacc -dv zinc.y
flex zinc.l
gcc y.tab.c -ll