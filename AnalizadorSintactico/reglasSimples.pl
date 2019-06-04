%Reglas Gramaticales Simples

oracion2(Output,Input,[]):- oracion2_simple(Output,Input,[]).
oracion2(Output,Input,[]):- oracion2_ccordinada(Output,Input,[]).
oracion2_simple(o(GV))-->g_verbal2(GV).
oracion2_simple(o(GN,GV))-->g_nominal2(GN),g_verbal2(GV).
oracion2_simple(o(GV,GN))-->g_verbal2(GV),g_nominal2(GN).

oracion2_ccordinada(o(OS1,C,OS2))-->oracion2_simple(OS1),conjuncion(C),oracion2_simple(OS2).
oracion2_ccordinada(o(OS1,C1,OS2,C2,OS3))-->oracion2_simple(OS1),conjuncion(C1),oracion2_simple(OS2),conjuncion(C2),oracion2_simple(OS3).

g_nom2(gn(N))-->nombre(N,_,_,_).
g_nom2(gn(PN))-->pronombre(PN,_,_,_).
g_nom2(gn(N,A))-->nombre(N,_,_,_),g_adjetival2(A).
g_nom2(gn(N1,N2))-->nombre(N1,_,_,_),nombre(N2,_,_,_).
g_nom2(gn(A,N))-->g_adjetival2(A),nombre(N,_,_,_).
g_nom2(gn(D,A,N))-->determinante(D,_,_),g_adjetival2(A),nombre(N,_,_,_).
g_nom2(gn(D,N))-->determinante(D,_,_),nombre(N,_,_,_).
g_nom2(gn(D,N,A))-->determinante(D,_,_),nombre(N,_,_,_),g_adjetival2(A).

g_nominal2(GN)-->g_nom2(GN).
g_nominal2(gn(GN1,C,GN2))-->g_nom2(GN1),conjuncion(C),g_nom2(GN2).
g_nominal2(gn(GN1,C,GN2,A))-->g_nom2(GN1),conjuncion(C),g_nom2(GN2),g_adjetival2(A).
g_nominal2(gn(GN1,GP))-->g_nom2(GN1),g_preposicional2(GP).
g_nominal2(gn(GN1,GA))-->g_nom2(GN1),g_adjetival2(GA).
g_nominal2(gn(GN1,OR))-->g_nom2(GN1),o_relativo2(OR).
g_nominal2(gn(GN1,GA,OR))-->g_nom2(GN1),g_adjetival2(GA),o_relativo2(OR).

o_relativo2(or(PR,OS))-->p_relativo(PR),oracion2_simple(OS).

g_verbal2(gv(V))-->verbo(V,_,_,_).
g_verbal2(gv(V,GN))-->verbo(V,_,c,_),g_nominal2(GN).
g_verbal2(gv(V,GN))-->verbo(V,_,n,_),g_nominal2(GN).
g_verbal2(gv(V,GN,GP))-->verbo(V,_,_,_),g_nominal2(GN),g_preposicional2(GP).
g_verbal2(gv(V,GN,GA))-->verbo(V,_,_,_),g_nominal2(GN),g_adjetival2(GA).
g_verbal2(gv(V,A))-->verbo(V,_,_,_),g_adjetival2(A).
g_verbal2(gv(V,GP))-->verbo(V,_,_,_),g_preposicional2(GP).
g_verbal2(gv(V,GA))-->verbo(V,_,_,_),g_adverbial2(GA).
g_verbal2(gv(V,GA,GN))-->verbo(V,_,c,_),g_adverbial2(GA),g_nominal2(GN).
g_verbal2(gv(V,GA,GN))-->verbo(V,_,n,_),g_adverbial2(GA),g_nominal2(GN).
g_verbal2(gv(V,GAD))-->verbo(V,_,_,_),g_adjetival2(GAD).

g_preposicional2(gp(P,GN))-->preposicion(P),g_nominal2(GN).

g_adverbial2(gad(AD1,AD2,GP))-->adverbio(AD1),adverbio(AD2),g_preposicional2(GP).
g_adverbial2(gad(AD1,AD2))-->adverbio(AD1),adverbio(AD2).
g_adverbial2(gad(ADV))-->adverbio(ADV).

g_adjetival2(gaj(AD,GP))-->adjetivo(AD,_,_),g_preposicional2(GP).
g_adjetival2(gaj(ADV,ADJ))-->adverbio(ADV),adjetivo(ADJ,_,_).
g_adjetival2(gaj(ADJ))-->adjetivo(ADJ,_,_).
