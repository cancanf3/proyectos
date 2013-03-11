(*
 *
 * AnalisisDescendente.pas
 *
 * Este es el esqueleto de lo que seria un juego de Clue.
 * Contiene los tipos de datos, funciones con sus 
 * especificaciones y esquema general del juego.
 *
 * Autores:
 * 	Jose Pena
 *	Jose Pascarella
 *
 * Ultima Modificacion: 
 *	11 / 03 2013
 *
 *)

PROGRAM AnalisisDescendente;

TYPE 

    (* Todas las cartas del juego *)

    pha = (SenoraBlanco, SenorVerde, SenoraCeleste, ProfesorCiruela,
	   SenoritaEscarlata, CoronelMostaza, Biblioteca, Cocina, Comedor,
	   Estudio, Vestibulo, Salon, Invernadero, SalaDeBaile, SalaDeBillar,
	   Candelabro, Cuchillo, Cuerda, LlaveInglesa, Revolver, Tubo);

    (* Subrango de las cartas *)

    p = SenoraBlanco..CoronelMostaza; // Personajes
    h = Biblioteca..SalaDeBillar; // Habitaciones
    a = Candelabro..Tubo; // Armas

    cartas= Array[0..20] of pha;
    prjs = Array[0..5] of p;
    habts = Array[0..8] of h;
    armas  = Array[0..5] of a;
	   
    lugar = Record // Tipo para las Habitacion.
	            nombre : h; // Nombre de la Habitacion.
		        x : integer; // Coordenada x de la habitacion.
		        y : integer; // Coordenada y de la habitacion.
		        alcanzable : boolean; // Alcanzable o no en un turno.
	        End;
    
    sbr  =  Record
		        arma : a; // Carta de arma en el sobre.
		        habt : h; // Carta de habitacion en el sobre.
		        prj  : p; // Carta de personaje en el sobre.
	        End;
	
    user =  Record
		x : integer; // Coordenada x del jugador.
		y : integer; // Coordenada y del jugador.
		usuario : boolean; // True : El jugador es el usuario.
		vida : boolean; //Determina si el jugador esta vivo.
		mano : array[0..2] of pha; // Cartas repartidas al Jugador.
		donde : h; // Nombre de la habitacion donde se encuentra.
		peon  : p;  // Ficha que usa para jugar.
		posicion : integer; // posicion en la mesa del jugador.
	    End;

    (* Procedimiento que inicializa las variables necesitadas *)
    Procedure Inicializa(var player : array of user; 
			    var phaInit : cartas; 
			    var Habitacion : array of lugar
			    var ultimoJ : integer);
    Begin
	    {Precondicion: True}
	
	    {Postcondicion: True}
    End;
    
    (* Procedimiento que da la bienvenida y explica las reglas *)
    Procedure Introduccion( phaInit : cartas; 
			   Habitacion : array of lugar);
    Begin
	    {Precondicion: True}
	
	    {Postcondicion: True}
    End;
    
    (* Procedimiento que informa en que turno se consiguieron los hechos 
	    y agradece al usuario por jugar *)
    Procedure Despedida(Turno : integer);
    Begin
	    {Precondicion: True}
	
	    {Postcondicion: True}
    End;
    
    (* Funcion que genera numeros aleatorios en un rango dado *)
    Function Aleatorio(inicio : integer; tope : integer) : integer;
    Begin
	    {Precondicion: True}
	
	    {Postcondicion: Aleatorio >= inicio /\ Aleatorio <= tope} 
    End;
    
    (* Funcion emula un dado *)
    Function Dado(): integer;
    Begin
	    {Precondicion: True}
	
	    {Postcondicion: Dado >= 0 /\ Dado <= 6} 
    End;
    
    (* Asignacion de las cartes *) 
    Procedure AsignaCartas (phaInit : cartas; var sobre : sbr; var pc : Array of user; ultimoJ : integer;)

        Procedure RepatirCartas (x : integer; 
                                 y : integer; 
                                 z : integer;
                                 Var pc : Array of user;
                                 phaInit  : cartas );
        Begin
            {precondicion: x <= 5 /\ x >= 0 /\
                           y <= 14 /\ y >= 6 /\
                           z <= 20 /\ z >= 15 }


            {Postcondicion: (%forall a : 0 <= a <= ultimoJ : 
                            (%forall b : 0 <= b <= 2 :
                            (%forall c : 0 <= c <= ( ultimoJ * 3 ) : 
                            pc[a].mano[b] = phaInit[c] ))) 
			    /\ (%forall g : 0 <= g <= ( 17 - ultimoJ*3 ) : 
			    (%forall h : 2 <= h <= ( 17 - ultimoj*3 ) : pc[0].mano[h] = phaInit[g] ))
				}
        End;
   
    Begin
    
        {Precondicion: True }


        {Postcondicion:  x <= 5 /\ x >= 0 /\
                         y <= 14 /\ y >= 6 /\
                         z <= 20 /\ z >= 15 /\
                         (%exist q: 0 <= q <= 5 : sobre.prj = phaInit[q] ) /\
                         (%forall w: 0<= w <= 5 /\ w <> q 
                             : sobre.prj <> phaInit[w] ) /\
                         (%exist q: 6 <= q <= 14 : sobre.habt = phaInit[q] ) /\
                         (%forall w: 6 <= w <= 14 /\ w <> q 
                             : sobre.habt <> phaInit[w] ) /\
                         (%exist q: 15 <= q <= 20 : sobre.arma = phaInit[q] )/\
                         (%forall w: 15 <= w <= 20 /\ w <> q 
                             : sobre.arma <> phaInit[w] ) }

    End;

    (* Proceso para eleccion de personajes *)

    Procedure SeleccionPersonaje(phaInit : cartas; var pc : Array of user; var ultimoJ : integer);
    Begin
	    {Precondicion: True}

	    {Postcondicion: (%forall i \ 0 < i <= ultimoJ :
		        (%existis j \ 0 <= j <= 5 : pc[i] = phaInit[j])) }
    End;
    
    (* Funcion que calcula el valor absoluto de un entero dado *)

    Function VA(n : integer): integer;
    Begin
	    {Precondicion: True}

	    {Postcondicion: n < 0 ==> (n = n * -1) 
			    /\ n >= 0 ==> (n = n)}
    End;
    
    (* Funcion que calcula la distancia ente un usuario y una habitacion *)

    Function Distancia(player : user ; Habitacion : lugar): integer;
    Begin
	    {Precondicion: True}

	    {Postcondicion: Distancia = \Habitacion.x - player.x\  
			    + \Habitacion.y - player.y\}
    End;
    
    (* Procedimiento que permite mover a los jugadores *)  

    Procedure Mover (var player : user; // Usurio o Computadora.
			 n: integer;    // Lo que saco con el dado.
			 Habitacion : array of lugar);
    Begin
	    {Pre: n >= 1 /\ n <= 6}
	
	    {Post: (%exits i \ 0 <= i <= 8 : player.x = Habitacion[i].x 
				    /\ player.y = Habitacion[i].y
				    /\ player.donde = Habitacion[i].nombre)}
    End;
    
    (* Proceso para sospechar *)

    Procedure sospecha_usuario( var sospech : sbr; var sospechaON : boolean; 
				var player : user ; 
				var pc : array of user; phaInit : cartas );

	Procedure Refutar ( var player : user; sospech : sbr;
			    var muestro : integer ; var k : integer);
	Begin
	
	    {Precondicion: (%existe i : 0 <= i <= 5 :
		(%exist j : 0 <= j <= 2 
		    : sospech = pc[i].mano[j] )) }

	    {Postcondicion: sospechaON == !( (%exist a :
		0 <= a <= 2 : carta[a] = sospech.arma) \/
		(%exist b : 0 <= b <= 2 /\ a <> b : 
		    carta[b] = sospech.habt ) \/
		(%exist c : 0 <= c <= 2 /\ c <> a /\ b <> c :
		    carta[c] = sospech.prj ) ) }
	End;

    Begin
	(* Elegir arma a sospechar *)

	(* Elegir personaje a sospechar *)

    	{Precondicion: player == ( % exist x : 0 <= x <= 5 : pc[x] }
    
	(* Mover el personaje al lugar de la sospecha *)

	(* Match de las cartas *)

	    {Postcondicion: sospechaON == !( % Exist x : 0 <= x <= 5 : 
			    ( % exist y : 0 <= y <= 2 : sospech = pc[x].mano[y] ))}

    End;

    Procedure Sospecha_computadora( var sospech : sbr ;var sospechaON : boolean; 
                                    var player : user ; var pc : array of user; 
                                        phaInit : cartas );

	Procedure Refutar ( var player : user; sospech : sbr;
			    var muestro : integer ; var k : integer);
	Begin
		
	    {Precondicion: (%existe i : 0 <= i <= 5 :
		(%exist j : 0 <= j <= 2 
		    : sospech = pc[i].mano[j] )) }

	    {Postcondicion: sospechaON == !( (%exist a :
		0 <= a <= 2 : pc[0].mano.[a] = sospech.arma) \/
		(%exist b : 0 <= b <= 2 /\ a <> b : 
		    pc[0].mano[b] = sospech.habt ) \/
		(%exist c : 0 <= c <= 2 /\ c <> a /\ b <> c :
		    pc[0].mano[c] = sospech.prj ) ) }
	End;

    Begin

	(* Computadora elegira arma a sospechar *)
	(* Computadora elegira personaje a sospechar *)

	    {Precondicion: player == ( % exist x : 0 <= x <= 5 : pc[x] }

	(* Mover el personaje al lugar de la sospecha *)

	(* Match de las cartas *)
	    (* Si el usuario tiene una carta de la sospecha *)

	    {Postcondicion: sospechaON == !( % Exist x : 0 <= x <= 5 : 
			    ( % exist y : 0 <= y <= 2 : sospech = pc[x].mano[y] ))}

    End;

    (* Proceso para Acusar *)

    Procedure Acusacion_usuario( var player : user; sobre : sbr);
    Var 
	acus : sbr; // Variables que almacenaran la acusasion del jugador
    Begin
	    
	    (* Usuario acusa *)

		{Precondicion: sospechaON == true }  
	    (* Verificacion de la acusacion *) 

	    (* Pierde el jugador o Gana y se Termina el juego *)
	    {Postcondicion: player.vida == ( acus.arma = sobre.arma /\
			    acus.prj = sobre.prj /\ acus.habt = acus.habt ) }
    End;	


    Procedure Acusacion_computadora( var player : user; sobre : sbr);
    Begin
	    
	    (* Computador acusa *)
    
		{Precondicion: sospechaON == true }  
	    (* Verificacion de la acusacion *) 


	    (* Pierde el jugador o Gana y se Termina el juego *)
	    {Postcondicion: player.vida == ( acus.arma = sobre.arma /\
			    acus.prj = sobre.prj /\ acus.habt = acus.habt ) }
    End;	

    (* Mover personaje *)

    Procedure MoverSospechoso (sospech : sbr ; var pc : Array of user ; 
                               acus : sbr );

    Begin
        {Precondicion: True }

        {Postcondiccion: (%exist z : 0 <= z <= 5 : 
                        sospech.habt = pc[z].donde \/ acus.habt = pc[z].donde) }
            
    End;

    (* Procedimiento que elimina un personaje si falla la acusacion *)

    Procedure Eliminar ( var player : user; acus : sbr; sobre : sbr);
 
    Begin
        {Precondicion: True }


        {Postcondicion: player.vida == ( ( acus.arma = sobre.arma ) /\ 
                    ( acus.prj = sobre.prj ) /\ ( acus.habt = sobre.habt ) )}

    End;
    
    (* Proceso que verifica y finaliza el juego *)

    Procedure Fin ( pc : Array of user; juegoON : boolean);
    Begin
        {Precondicion: True }

        {Postcondicion: juegoON == !( pc[0].vida == false \/
                        ( acus.arma = sobre.arma /\ acus.habt = sobre.habt
                            /\ acus.prj = sobre.prj ) \/
                        (%forall z : 1 <= z <= 5 : pc[z].vida == false ) )}

    End;

    (* Procedimiento que del turno *)

    Procedure Turno ( var player : user; habitacion : Array of lugar;
                      phaInit : cartas; var pc : Array of user; 
                      var sospech : sbr; var acus : sbr; juegoON : boolean);
    Begin
	    {Precondicion: player.vida == true }

	    (* Emulacion de Dado *)
	    (* El jugador va a moverse *)
	    (* El jugador realiza una sospecha *)
	    (* El jugador realiza una acusacion *)
	    (* Fin de su turno *) 

	    {Postcondicion: player.vida == ( ( acus.arma = sobre.arma ) /\ 
                    ( acus.prj = sobre.prj ) /\ ( acus.habt = sobre.habt ) )} 
    End;

Var
    
    habitacion : Array[0..8] of lugar; 	// Arreglo de las habitaciones.
    pc         : Array[0..5] of user; 	// Arreglo de Jugadores pc[0]:Usuario.
    
    
    phaInit : cartas; 	// Arreglo con todas las cartas del juego.
    sobre   : sbr; 	// Variable que contiene los hechos reales.
       
    i	    : integer; // Variables para Iteracion y contadores.
    n,x,y,z : integer; // Variables de usos multiples: swap, etc.
    Turn    : integer; // Contador de los Turnos.
    
    juegoON : boolean; // Booleano para terminar el juego.
    
    sospecha   : sbr; 		// Variable para realizar sospechas.
    acus       : sbr; 		// Variable para realizar acusaciones.
    ultimoJ    : integer;       // Variable que determina el numero de jugadores.
    
Begin

    Introduccion(PhaInit,habitacion);

    Inicializa(pc,PhaInit,habitacion);

    SeleccionPersonaje(phaInit,pc);
    
    AsignaCartas(phaInit,sobre);
    
    While juegoON Do
    Begin
	    For i := 0 To 5 Do
	    Begin
	        Turno(pc[i],habitacion,phaInit,pc,sospecha,acus,juegoON);
	    End;
    End;
    
    Despedida(Turn);

End.
