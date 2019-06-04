%consult('/Users/mr.blissfulgrin/Documents/UAH_2018_2019/RAZONAMIENTO/LAB/PECL1/exe.pl').
:-consult('./knowledge_base.pl').
:-consult('./preguntas.pl').

%Inicio del programa
jugar:-
    caracteristicas(ListaPreguntas),length(ListaPreguntas,LongitudPreguntas),
    crearListaRespuestas(1,LongitudPreguntas,ListaRespuestas),lenguajes(ListaLenguajes),
    nl,write('Akinator!!!'), nl,nl,
    crearListaIndices(ListaIndices),
    gameLoop(ListaRespuestas,ListaLenguajes,ListaIndices),
    nl,write('Game Over!!!'),nl,!.

%Bucle del juego
gameLoop(ListaRespuestas,ListaLenguajes,ListaIndices):-
    mejorIndice(ListaLenguajes,ListaIndices, Indice1),
    obtenerPregunta(Indice1,PrimeraPregunta),
    Indice is Indice1 - 1,
    delete(ListaIndices, Indice1, NuevaListaIndices),
    %write(ListaIndices),nl,
    write('Su lenguaje '),write(PrimeraPregunta),write('? (si/no/n/psi/pno): '),
    read(Respuesta),
    (Respuesta==e -> write('exit'),! ;
                 cambiarRespuesta(Respuesta,Answer),
                 reemplazar(ListaRespuestas,Indice,Answer,NuevaListaRespuestas),
                 write(NuevaListaRespuestas),nl,
                 validar(NuevaListaRespuestas,ListaLenguajes,[],NuevaListaLenguajes),
                 write(NuevaListaLenguajes),nl,
                 length(NuevaListaLenguajes,LongitudLenguajes),
                 (LongitudLenguajes=:=1 ->
                          write('Su lenguaje es '),[Solucion|_]=NuevaListaLenguajes,
                          write(Solucion),nl,
                          write('Quiere volver a jugar? (si/no): '),
                          read(VolverJugar),
                          (VolverJugar==si -> jugar;!);
                          (LongitudLenguajes=:=0 ->
                                    write('No se ha podido encontrar su lenguaje'),nl,
                                    write('Quiere introducir un lenguaje nuevo?(si/no): '),
                                    read(IntroducirLeng),
                                    cambiarRespuesta(IntroducirLeng,IntroducirL),
                                    (IntroducirL=:=1 ->
                                                      write('Escriba el nombre del lenguaje'),
                                                      read(NombreNuevo),
                                                      caracteristicas(ListaPreguntas),
                                                      nl,write('Deber? contestar unas respuestas extra!'),nl,
                                                      rellenarRespuestas(ListaPreguntas,NuevaListaRespuestas,NuevaListaRespuestas,0,ListaGuardar),
                                                      meterLenguaje(NombreNuevo, ListaGuardar),nl,

                                                      write('Quiere volver a jugar? (si/no): '),
                                                      read(VolverJugar),
                                                      (VolverJugar==si -> jugar;!);

                                                      write('Habria sido bueno colaborar!!!'),
                                                      nl,
                                                      write('Quiere volver a jugar? (si/no): '),
                                                      read(VolverJugar),
                                                      (VolverJugar==si -> jugar;!));

                          gameLoop(NuevaListaRespuestas,NuevaListaLenguajes,NuevaListaIndices)))).

gameLoop(_,_,_):-write('No quedan preguntas'),nl,
                          write('Quiere volver a jugar? (si/no): '),
                          read(VolverJugar),
                          (VolverJugar==si -> jugar;!).

%Funcion para rellenar la lista de respuestas al introducir un nuevo lenguaje
rellenarRespuestas([PrimeraPregunta|RestoPreguntas],[PrimeraRespuesta|RestoRespuestas],ListaRespuestas,Indice,ListaRetorno):-
    (PrimeraRespuesta=:=2-> write('Su lenguaje '),write(PrimeraPregunta),write('?(si/no/n): '),
                           read(Answer),
                           cambiarRespuesta(Answer,Respuesta),
                           reemplazar(ListaRespuestas,Indice,Respuesta,ListaGuardar),
                           write(ListaGuardar),nl,
                           Indice2 is Indice +1,
                           rellenarRespuestas(RestoPreguntas,RestoRespuestas,ListaGuardar,Indice2,ListaRetorno);
                           Indice2 is Indice +1,
                           rellenarRespuestas(RestoPreguntas,RestoRespuestas,ListaRespuestas,Indice2,ListaRetorno)).
rellenarRespuestas(_,_,ListaGuardar,_,ListaGuardar).

%Comparar caracteristicas y quitar lenguaje de la lista general
validar(ListaRespuestas,[Lenguaje1|RestoLenguajes],FinalAnterior,Final):-
    lenguaje(Lenguaje1,ListaCaract),
    validarAux(ListaRespuestas,ListaCaract,Lenguaje1,FinalAnterior,Resultado),
    validar(ListaRespuestas,RestoLenguajes,Resultado,Final).

validar(_,_,FinalAnterior,FinalAnterior).

validarAux([Respuesta1|RestoRespuestas],[Caracteristica1|RestoCaracteristicas],Lenguaje1,FinalAnterior,Final):-
    (((Respuesta1=:=2;Respuesta1=:=0), Caracteristica1=:=1)->validarAux(RestoRespuestas,RestoCaracteristicas,Lenguaje1,FinalAnterior,Final);
        ((Respuesta1=:=1)->
                      validarAux(RestoRespuestas,RestoCaracteristicas,Lenguaje1,FinalAnterior,Final);
                         ((Respuesta1==Caracteristica1)->
                                   validarAux(RestoRespuestas,RestoCaracteristicas,Lenguaje1,FinalAnterior,Final);
                                              (Respuesta1=:=0.5,Caracteristica1<2 ->
                                                            validarAux(RestoRespuestas,RestoCaracteristicas,Lenguaje1,FinalAnterior,Final);
                                                                       (Respuesta1=:=1.5,Caracteristica1>0 ->
                                                                                    validarAux(RestoRespuestas,RestoCaracteristicas,Lenguaje1,FinalAnterior,Final);
                                   validarAux([],[],FinalAnterior,Final)))))).

validarAux(_,_,Lenguaje1,FinalAnterior,[Lenguaje1|FinalAnterior]).
validarAux(_,_,FinalAnterior,FinalAnterior).

%Reemplazar valor de una lista en una cierta posici?n
reemplazar([_|Cola], 0, Valor, [Valor|Cola]).
reemplazar([Cabeza|Cola1], Indice, Valor, [Cabeza|Cola2]):-
    Indice > -1,
    NuevoIndice is Indice-1,
    reemplazar(Cola1, NuevoIndice, Valor, Cola2), !.
reemplazar(Lista, _, _, Lista).

%Construir lista de longitud N con valor X en sus posiciones
crearListaRespuestas(Valor, Longitud, ListaRespuestas):-
    length(ListaRespuestas, Longitud),
    maplist(=(Valor), ListaRespuestas).

%Funci?n que devuelve una lista con nombres de los lenguajes
lenguajes(Lenguajes):- lenguajes_aux([], Lenguajes).
lenguajes_aux(Lenguajes,Resultado):-
    lenguaje(NuevoLenguaje,_),
    not(member(NuevoLenguaje,Lenguajes)),
    lenguajes_aux([NuevoLenguaje|Lenguajes], Resultado), !.
lenguajes_aux(X,X).

%Funcione que obtiene una pregunta dado un indice
obtenerPregunta(Indice, Pregunta):-
    caracteristicas(Lista),
    nth1(Indice, Lista, Pregunta).

%Funcion para insertar lenguaje en la base de conocimiento
meterLenguaje(NombreLenguaje, Caracteristicas):-
    nl,write('Guardando el lenguaje '),
    write(NombreLenguaje),
    write(' con las respuestas:'),nl,
    write(Caracteristicas),nl,
    assertz(lenguaje(NombreLenguaje,Caracteristicas)),
    tell('./knoledge_base.pl'),
    listing(lenguaje),
    told,
    write('Guardado!!!'),nl.

%Transforma la respuesta del usuario a los datos internos
cambiarRespuesta(Respuesta,RespuestaTrans):-
    (Respuesta==si -> RespuestaTrans is 2;
    (Respuesta==no -> RespuestaTrans is 0;
    (Respuesta==psi -> RespuestaTrans is 1.5;
    (Respuesta==pno -> RespuestaTrans is 0.5;
    RespuestaTrans is 1)))).

%FUNCION QUE OBTIENE EL MEJOR INDICE
mejorIndice(LenguajesPosibles,ListaIndices, MejorIndice):-
    listaContadores(LenguajesPosibles,ListaIndices,[],ListaContadoresR),
    reverse(ListaContadoresR,ListaContadores),
    %nl,write(ListaContadores),
    random(1,11,Random),
    (Random > 9 -> replace('abc',0,ListaContadores,ListaContadoresFormated), max_list(ListaContadoresFormated,MejorValor);
                   replace('abc',9999,ListaContadores,ListaContadoresFormated), min_list(ListaContadoresFormated,MejorValor)),
    nth1(IndiceMejorContador,ListaContadores,MejorValor),
    nth1(IndiceMejorContador,ListaIndices,MejorIndice).
    %write('-->('),write(MejorIndice),write(","),write(MejorValor),write(")"),nl.

%Obtener columna de caracteristicas
obtenerColumna([PrimerLenguaje|RestoLenguajes], Indice, ColumnaCaracteristicasInicial,ColumnaCaracteristicasFinal):-
    lenguaje(PrimerLenguaje,Caracteristicas),
    nth1(Indice, Caracteristicas, Caracteristica),
    obtenerColumna(RestoLenguajes,Indice,[Caracteristica|ColumnaCaracteristicasInicial],ColumnaCaracteristicasFinal).
obtenerColumna(_,_,ColumnaCaracteristicasInicial,ColumnaCaracteristicasInicial).

%Recorrer caracteristicas y actualizar el contador dependiendo de ellas
%El flag indica si todas las caracteristicas son de incertidumbre
recorrerYContar([PrimeraCaracteristica|RestoCaracteristicas], ContadorInicial, FlagInicial, ContadorFinal, FlagFinal):-
    (PrimeraCaracteristica =:= 0 -> ContadorInicial1 is ContadorInicial - 1, Flag1 is 1;
                                   (PrimeraCaracteristica =:= 2 ->  ContadorInicial1 is ContadorInicial + 1, Flag1 is 1;
                                                                    ContadorInicial1 is ContadorInicial, Flag1 is FlagInicial)),
    recorrerYContar(RestoCaracteristicas,ContadorInicial1,Flag1, ContadorFinal, FlagFinal).
recorrerYContar(_,ContadorInicial,FlagInicial,ContadorInicial,FlagInicial).


%Diferencia absoluta de caracteristicas
diferenciaCaracteristicas(LenguajesPosibles, Indice, ContadorAbs,Flag):-
    obtenerColumna(LenguajesPosibles,Indice,[],ColumnaCaracteristicas),
    recorrerYContar(ColumnaCaracteristicas, 0, 0,Contador, Flag),
    ContadorAbs is abs(Contador).

%Lista contadores
listaContadores(LenguajesPosibles, [PrimerIndice|RestoIndices], ListaContadores,ListaContadoresResultado):-
    IndiceUsar is PrimerIndice +1,
    diferenciaCaracteristicas(LenguajesPosibles, IndiceUsar, ContadorAbs, Flag),
    (Flag \= 0 -> listaContadores(LenguajesPosibles, RestoIndices, [ContadorAbs|ListaContadores], ListaContadoresResultado) ;
                 listaContadores(LenguajesPosibles, RestoIndices, ['abc'|ListaContadores], ListaContadoresResultado)).
listaContadores(_,_,ListaContadores,ListaContadores).

%Cambiar todos los elementos iguales por otro en una lista
replace(_, _, [], []).
replace(O, Reemplazar, [O|Resto1], [Reemplazar|Resto2]) :- replace(O, Reemplazar, Resto1, Resto2).
replace(O, Reemplazar, [Cabeza|Resto1], [Cabeza|Resto2]) :- Cabeza \= O, replace(O, Reemplazar, Resto1, Resto2).

%Crea lista con numeros consecutivos de las caracteristicas
crearListaIndicesAux([_|RestoLista], ListaGuardar, ListaResultado):-
    length(RestoLista,LongitudLista),
    crearListaIndicesAux(RestoLista,[LongitudLista|ListaGuardar],ListaResultado).
crearListaIndicesAux(_,ListaGuardar,ListaGuardar).

crearListaIndices(ListaIndices):-
   caracteristicas(Preguntas),
   crearListaIndicesAux(Preguntas,[],ListaIndices).