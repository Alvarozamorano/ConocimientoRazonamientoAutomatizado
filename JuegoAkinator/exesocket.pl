%consult('/Users/mr.blissfulgrin/Documents/UAH_2018_2019/RAZONAMIENTO/LAB/PECL1/exe.pl').
:-consult('./knowledge_base.pl').
:-consult('./preguntas.pl').

%Inicio para crear el socket
jugarConSocket:-udp_socket(S),
    tcp_bind(S, 49153),
    jugar(S).

%Inicio del programa
jugar(S):-
    caracteristicas(ListaPreguntas),length(ListaPreguntas,LongitudPreguntas),
    crearListaRespuestas(1,LongitudPreguntas,ListaRespuestas),lenguajes(ListaLenguajes),
    nl,
    send(S,'%'),send(S,'Jugando...'),
    gameLoop(S,ListaPreguntas,ListaRespuestas,ListaLenguajes,0),
    send(S,'%'),send(S,'Game Over!!!'),tcp_close_socket(S),!.

%Bucle del juego
gameLoop(S,[PrimeraPregunta|RestoPreguntas],ListaRespuestas,ListaLenguajes,Indice):-
    send(S,'@'),send(S,'Su lenguaje '),send(S,PrimeraPregunta),send(S,'?'),
    receive(S,Respuesta),write(Respuesta),
    (Respuesta==e -> !;
                 cambiarRespuesta(Respuesta,Answer),
                 reemplazar(ListaRespuestas,Indice,Answer,NuevaListaRespuestas),
                 Indice1 is Indice+1,
                 validar(NuevaListaRespuestas,ListaLenguajes,[],NuevaListaLenguajes),
                 send(S,'#'),enviarLisLenguajes(S,NuevaListaLenguajes),
                 length(NuevaListaLenguajes,LongitudLenguajes),
                 (LongitudLenguajes=:=1 ->
                          send(S,'%'),send(S,'Su lenguaje es '),[Solucion|_]=NuevaListaLenguajes,
                          send(S,Solucion),
                          send(S,'@'),send(S,'Quiere volver a jugar?'),
                          receive(S,VolverJugar),
                          (VolverJugar==si -> jugar(S);!);
                          (LongitudLenguajes=:=0 ->
                                    send(S,'%'),send(S,'No se ha podido encontrar su lenguaje'),
                                    send(S,'@'),send(S,'Quiere introducir un lenguaje nuevo?'),
                                    receive(S,IntroducirLeng),
                                    cambiarRespuesta(IntroducirLeng,IntroducirL),
                                    (IntroducirL=:=1 ->
                                                      send(S,'@'),send(S,'Escriba el nombre del lenguaje'),
                                                      receive(S,NombreNuevo),
                                                      caracteristicas(ListaPreguntas),
                                                      send(S,'%'),send(S,'Debera contestar unas respuestas extra!'),
                                                      rellenarRespuestas(S,ListaPreguntas,NuevaListaRespuestas,NuevaListaRespuestas,0,ListaGuardar),
                                                      meterLenguaje(S,NombreNuevo, ListaGuardar),

                                                      send(S,'@'),send(S,'Quiere volver a jugar?'),
                                                      receive(S,VolverJugar),
                                                      (VolverJugar==si -> jugar(S);!);

                                                      send(S,'%'),send(S,'Habria sido bueno colaborar!!!'),
                                                      send(S,'@'),send(S,'Quiere volver a jugar?'),
                                                      receive(S,VolverJugar),
                                                      (VolverJugar==si -> jugar(S);!));
                       gameLoop(S,RestoPreguntas,NuevaListaRespuestas,NuevaListaLenguajes,Indice1)))).

gameLoop(_,_,_,_,_):-send(S,'%'),send(S,'No quedan preguntas'),
                  send(S,'@'),send(S,'Quiere volver a jugar?'),
                  receive(S,VolverJugar),
                  (VolverJugar==si -> jugar(S);!).

%Funcion para enviar la lista de lenguajes posibles por el socket
enviarLisLenguajes(S,[PrimerLenguaje|RestoLenguajes]):-
    send(S,PrimerLenguaje),send(S,' '),
    enviarLisLenguajes(S,RestoLenguajes).

enviarLisLenguajes(_,_).

%Funci�n para rellenar la lista de respuestas al introducir un nuevo lenguaje
rellenarRespuestas(S,[PrimeraPregunta|RestoPreguntas],[PrimeraRespuesta|RestoRespuestas],ListaRespuestas,Indice,ListaRetorno):-
    (PrimeraRespuesta=:=2-> send(S,'@'),send(S,'Su lenguaje '),send(S,PrimeraPregunta),send(S,'?'),
                           receive(S,Answer),
                           cambiarRespuesta(Answer,Respuesta),
                           reemplazar(ListaRespuestas,Indice,Respuesta,ListaGuardar),
                           write(ListaGuardar),nl,
                           Indice2 is Indice +1,
                           rellenarRespuestas(S,RestoPreguntas,RestoRespuestas,ListaGuardar,Indice2,ListaRetorno);
                           Indice2 is Indice +1,
                           rellenarRespuestas(S,RestoPreguntas,RestoRespuestas,ListaRespuestas,Indice2,ListaRetorno)).

rellenarRespuestas(_,_,_,ListaGuardar,_,ListaGuardar).

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

%Reemplazar valor de una lista en una cierta posicion
reemplazar([_|Cola], 0, Valor, [Valor|Cola]).
reemplazar([Cabeza|Cola1], Indice, Valor, [Cabeza|Cola2]):-
    Indice > -1,
    NuevoIndice is Indice-1,
    reemplazar(Cola1, NuevoIndice, Valor, Cola2), !.
reemplazar(Lista, _, _, Lista).

%Construir lista de longitud N con valor X en sus posiciones
crearListaRespuestas(Valor, Longitud, ListaRespuestas)  :-
    length(ListaRespuestas, Longitud),
    maplist(=(Valor), ListaRespuestas).

%Funcion que devuelve una lista con nombres de los lenguajes
lenguajes(Lenguajes):- lenguajes_aux([], Lenguajes).
lenguajes_aux(Lenguajes,Resultado):-
    lenguaje(NuevoLenguaje,_),
    not(member(NuevoLenguaje,Lenguajes)),
    lenguajes_aux([NuevoLenguaje|Lenguajes], Resultado), !.
lenguajes_aux(X,X).

%Funcion para insertar lenguaje en la base de conocimiento
meterLenguaje(S,NombreLenguaje, Caracteristicas):-
    assertz(lenguaje(NombreLenguaje,Caracteristicas)),
    tell('./knoledge_base.pl'),
    listing(lenguaje),
    told,
    send(S,'%'),send(S,'Guardado!!!').

%Recibir datos del socket UDP
receive(S,Data) :-
        udp_receive(S, Data, _, [as(atom)]),
        write("Recivel: "),
        write(Data),nl.


%Enviar datos al socket UDP
send(S,Message) :-
        write("Sent: "),
        write(Message),nl,
        udp_send(S, Message, localhost:49260, []).

cambiarRespuesta(Respuesta,RespuestaTrans):-
    (Respuesta==si -> RespuestaTrans is 2;
    (Respuesta==no -> RespuestaTrans is 0;
    (Respuesta==psi -> RespuestaTrans is 1.5;
    (Respuesta==pno -> RespuestaTrans is 0.5;
    RespuestaTrans is 1)))).
%Iniciar programa automaticamente al iniciar el Java
:-jugarConSocket.