%Reglas Gramaticales Concordancia

oracion(Output,Input,[]):- oracion_simple(Output,Input,[]).
oracion(Output,Input,[]):- oracion_ccordinada(Output,Input,[]).
oracion_simple(o(GV))-->g_verbal(GV,_,_,_).
oracion_simple(o(GN,GV))-->g_nominal(GN,Gen,Num,Per),g_verbal(GV,Gen,Num,Per).
oracion_simple(o(GV,GN))-->g_verbal(GV,Gen,Num,Per),g_nominal(GN,Gen,Num,Per).

oracion_ccordinada(o(OS1,C,OS2))-->oracion_simple(OS1),conjuncion(C),oracion_simple(OS2).
oracion_ccordinada(o(OS1,C1,OS2,C2,OS3))-->oracion_simple(OS1),conjuncion(C1),oracion_simple(OS2),conjuncion(C2),oracion_simple(OS3).

g_nom(gn(N),Gen,Num,Per)-->nombre(N,Gen,Num,Per).
g_nom(gn(PN),Gen,Num,Per)-->pronombre(PN,Gen,Num,Per).
g_nom(gn(N,A),Gen,Num,Per)-->nombre(N,Gen,Num,Per),g_adjetival(A,Gen,Num).
g_nom(gn(N1,N2),Gen,_,_)-->nombre(N1,Gen,_,_),nombre(N2,Gen,_,_).
g_nom(gn(A,N),Gen,Num,Per)-->g_adjetival(A,Gen,Num),nombre(N,Gen,Num,Per).
g_nom(gn(D,A,N),Gen,Num,Per)-->determinante(D,Gen,Num),g_adjetival(A,Gen,Num),nombre(N,Gen,Num,Per).
g_nom(gn(D,N),Gen,Num,Per)-->determinante(D,Gen,Num),nombre(N,Gen,Num,Per).
g_nom(gn(D,N,A),Gen,Num,Per)-->determinante(D,Gen,Num),nombre(N,Gen,Num,Per),g_adjetival(A,Gen,Num).

g_nominal(GN,Gen,Num,Per)-->g_nom(GN,Gen,Num,Per).
g_nominal(gn(GN1,C,GN2),_,p,t)-->g_nom(GN1,_,_,_),conjuncion(C),g_nom(GN2,_,_,_).
g_nominal(gn(GN1,C,GN2,A),_,p,t)-->g_nom(GN1,_,_,_),conjuncion(C),g_nom(GN2,_,_,_),g_adjetival(A,_,p).
g_nominal(gn(GN1,GP),_,Num,Per)-->g_nom(GN1,_,Num,Per),g_preposicional(GP,_,_).
g_nominal(gn(GN1,GA),Gen,Num,Per)-->g_nom(GN1,Gen,Num,Per),g_adjetival(GA,Gen,Num).
g_nominal(gn(GN1,OR),Gen,Num,Per)-->g_nom(GN1,Gen,Num,Per),o_relativo(OR).
g_nominal(gn(GN1,GA,OR),Gen,Num,Per)-->g_nom(GN1,Gen,Num,Per),g_adjetival(GA,Gen,Num),o_relativo(OR).

o_relativo(or(PR,OS))-->p_relativo(PR),oracion_simple(OS).

g_verbal(gv(V),_,Num,Per)-->verbo(V,Num,_,Per).
g_verbal(gv(V,GN),_,Num,Per)-->verbo(V,Num,c,Per),g_nominal(GN,_,Num,_).
g_verbal(gv(V,GN),_,Num,Per)-->verbo(V,Num,n,Per),g_nominal(GN,_,_,_).
g_verbal(gv(V,GN,GP),Gen,Num,Per)-->verbo(V,Num,_,Per),g_nominal(GN,Gen,_,_),g_preposicional(GP,Gen,Num).
g_verbal(gv(V,GN,GA),Gen,Num,Per)-->verbo(V,Num,_,Per),g_nominal(GN,Gen,_,_),g_adjetival(GA,Gen,Num).
g_verbal(gv(V,A),Gen,Num,Per)-->verbo(V,Num,_,Per),g_adjetival(A,Gen,Num).
g_verbal(gv(V,GP),_,Num,Per)-->verbo(V,Num,_,Per),g_preposicional(GP,_,_).
g_verbal(gv(V,GA),Gen,Num,Per)-->verbo(V,Num,_,Per),g_adverbial(GA,Gen,_).
g_verbal(gv(V,GA,GN),Gen,Num,Per)-->verbo(V,Num,c,Per),g_adverbial(GA,_,_),g_nominal(GN,Gen,Num,_).
g_verbal(gv(V,GA,GN),_,Num,Per)-->verbo(V,Num,n,Per),g_adverbial(GA,_,_),g_nominal(GN,_,_,_).
g_verbal(gv(V,GAD),Gen,Num,Per)-->verbo(V,Num,_,Per),g_adjetival(GAD,Gen,Num).

g_preposicional(gp(P,GN),Gen,Num)-->preposicion(P),g_nominal(GN,Gen,Num,_).

g_adverbial(gad(AD1,AD2,GP),Gen,Num)-->adverbio(AD1),adverbio(AD2),g_preposicional(GP,Gen,Num).
g_adverbial(gad(AD1,AD2),_,_)-->adverbio(AD1),adverbio(AD2).
g_adverbial(gad(ADV),_,_)-->adverbio(ADV).

g_adjetival(gaj(AD,GP),Gen,Num)-->adjetivo(AD,Gen,Num),g_preposicional(GP,_,_).
g_adjetival(gaj(ADV,ADJ),Gen,Num)-->adverbio(ADV),adjetivo(ADJ,Gen,Num).
g_adjetival(gaj(ADJ),Gen,Num)-->adjetivo(ADJ,Gen,Num).
