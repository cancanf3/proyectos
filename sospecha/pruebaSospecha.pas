PROGRAM CLUE;

TYPE 
 
    pha = (SenoraBlanco, SenorVerde, SenoraCeleste, ProfesorCiruela,
	   SenoritaEscarlata, CoronelMostaza, Biblioteca, Cocina, Comedor,
	   Estudio, Vestibulo, Salon, Invernadero, SalaDeBaile, SalaDeBillar,
	   Candelabro, Cuchillo, Cuerda, LlaveInglesa, Revolver, Tubo);
    
    p = SenoraBlanco..CoronelMostaza;
    h = Biblioteca..SalaDeBillar;
    a = Candelabro..Tubo;
    
    cartas= Array[0..20] of pha;
    prjs = Array[0..5] of p;
    habts = Array[0..8] of h;
    armas  = Array[0..5] of a;
	   
    lugar = Record
		nombre : h;
		x : integer;
		y : integer;
		alcanzable : boolean;
	        End;
    
    sbr  =  Record
		arma : a;
		habt : h;
		prj  : p;
	        End;
	contadores = Record // Variable contadora de descarte para las jugadores 
        arma : integer;
        habt : integer;
        prj  : integer;
      cartas : integer;
               End;
    lista_cartas = Record
        arma : armas;
        habt : habts;
        prj  : prjs; 
             End;

    user =  Record
		x : integer;
		y : integer;
		usuario : boolean;
        vida : boolean;
        mano : Array[0..8] of pha;
		donde : h;
		peon  : p;  // Ficha que usa para jugar
		lista : lista_cartas;  // Lista de cartas
        conta : contadores;
     posicion : integer; 
        
            End;
  
    
    (* Permite ingresar el numero de Computadoras *)
    Procedure NComputadoras(var ultimoJ : integer);
    Begin
	write('Ingrese el numero de jugadoras contra las que desea jugar (2-5): ');
	read(ultimoJ);
	While (ultimoJ < 2) Or (ultimoJ > 5) Do
	Begin
	    writeln('Numero ingresado no valido, Puede elejir entre 2 y 5 computadoras');
	    write('Intente de nuevo: ');
	    read(ultimoJ);
	End;
    End;
    
    
    (* Inicializacion de variables *)
    Procedure Inicializa (var phaInicio : cartas;
			    ultimoJ : integer;
			    var habitacion : array of lugar;
			    var jugadores : Array of user;
			    var Turn : integer;
			    var SioNo : boolean;
			    var juegoActivo : boolean);
    Var 
    
	i, j : integer;
	x, y : integer;
	co : integer;
        
    Begin
	(* Habitaciones *)
	co := 0;
	For i := 6 To 14 Do
	Begin
	    habitacion[co].nombre := phaInicio[i];
	    habitacion[co].alcanzable := False;
	    co := co + 1;
	End;
	
	co := 0;
	y  := 0;
	For i := 0 To 2 Do
	Begin
	    x := 0;
	    For j := 0 to 2 Do
	    Begin
		habitacion[co].x := x;
		habitacion[co].y := y;
		x := x + 2;
		co := co + 1;
	    End;
	    y := y + 2;
	End;
	
	juegoActivo := True;
	SioNo := True; // Variable del procedimiento decision
	Turn := 0;
	
	
	For i := 0 to ultimoJ Do // Inicializo a todos los jugadores
	Begin
	    jugadores[i].conta.arma := 0;
	    jugadores[i].conta.habt := 0;
	    jugadores[i].conta.prj  := 0;
	    jugadores[i].conta.cartas := -1;
	    jugadores[i].conta.sospecha := 0;
	    jugadores[i].x := 2;
	    jugadores[i].y := 2;
	    jugadores[i].usuario := False;
	    jugadores[i].donde := Vestibulo;
	    jugadores[i].posicion := i;
	    jugadores[i].vida := True;
	    For j := 0 To 5 Do
	    Begin
		jugadores[i].lista.arma[j] := phaInicio[j + 15 ];
	    End;
	    For j := 0 To 5 Do
	    Begin
		jugadores[i].lista.prj[j] := phaInicio[j];
	    End;
	    For j := 0 To 8 Do
	    Begin
		jugadores[i].lista.habt[j] := phaInicio[j + 6 ];
	    End;
	End;
	
	For i := ultimoJ + 1 To 5 Do // Descarto las computadoras que no juegan
	Begin
	    jugadores[i].vida := False;
	End;
	
	
	jugadores[0].usuario := True; // Determinar que el jugador jugadores[0] es el Usuario
    
    End;
   
   
   
   
   
   
   
   (* Funcion que hace swap para descartar de la lista *)

    Procedure Swap_descarte(var jugador : user; n : integer; 
                                m : integer; k : integer);
    Var
	tmp1 : a;
	tmp2 : h;
	tmp3 : p;
    Begin
        Case k of 
            0 :
            Begin
	            tmp1 := jugador.lista.arma[n];
	            jugador.lista.arma[n] := jugador.lista.arma[m];
	            jugador.lista.arma[m] := tmp1;
            End;
            2 :
            Begin
	            tmp2 := jugador.lista.habt[n];
	            jugador.lista.habt[n] := jugador.lista.habt[m];
	            jugador.lista.habt[m] := tmp2;
            End;
            1 :
            Begin
	            tmp3 := jugador.lista.prj[n];
	            jugador.lista.prj[n] := jugador.lista.prj[m];
	            jugador.lista.prj[m] := tmp3;
            End;
        End;
    End;
 

    Procedure Swap (var n : integer; var m : integer);
    Var
	tmp : integer;
    Begin
	tmp := n;
	n := m;
	m := tmp;
    End;   
    
    
    
    (* Funcion que genera numeros aleatorios en un rango dado *)
    Function Aleatorio(inicio : integer; tope : integer) : integer;
    Var 
	amplitud : integer;
    Begin
	amplitud := (tope - inicio) + 1;
	Aleatorio := Random(amplitud) + inicio;
    End;
    
    
    (* Funcion que emula un dado *)
    Function Dado () : integer;
    Begin
	Dado := Aleatorio(1,6);
    End;
    
    
    
    
    
    (* Proceso para Seleccionar Personaje *)
    Procedure SeleccionPersonaje(phaInicio : cartas; 
				 var jugadores : Array of user;
				 ultimoJ : integer);
    Var
	i : integer;
	repartir: Array[0..5] of integer = (0,1,2,3,4,5);
    Begin
	writeln('Seleccione un personaje ingresando el numero correspondiente.');
	For i := 0 To 5 Do
	Begin
	    Writeln(i+1, '.- ', phaInicio[i]);
	End;
	
	write('Usuario Selecciona: ');
	read(i);
	While (i > 6) Or (i < 1) Do
	Begin
	    writeln('Numero ingresado no valido');
	    write('Usuario Selecciona: ');
	    read(i);
	End;
	jugadores[0].peon := phaInicio[i-1];
	writeln('El personaje seleccionado fue: ', jugadores[0].peon);
	writeln;
	
	(* Asignamos los personajes a las Computadoras *)
	Swap(repartir[i-1], repartir[5]);
	
	For i:= 1 To ultimoJ Do
	Begin
	    jugadores[i+1].peon := phaInicio[repartir[i]];
	    writeln('Jugador ', i + 1, ' Selecciona a: ', jugadores[i].peon);
	End;
    End;
    
    
    
    (* Proceso que elije las cartas del sobre y reparte las demas *)
    Procedure AsignarCartas (phaInicio : cartas;
			      var jugadores : array of user; 
			      var sobre : sbr; 
			      ultimoJ : integer);
    Var 
    	repartir   : Array[0..20] of integer = (0,1,2,3,4,5,6,7,8,9,10,11,12,
						    13,14,15,16,17,18,19,20);
	n,x,y,z : integer;
	i,j : integer;
	co : integer;
    Begin
    	(* Se seleccionan los hechos reales *)
	x := Aleatorio(0,5);
	sobre.prj := phaInicio[x];
	y := Aleatorio(6,14);
	sobre.habt := phaInicio[y];
	z := Aleatorio(15,20);
	sobre.arma := phaInicio[z];
	
	(* Muevo las variables a las tres posiciones finales para 
	    no repartir las cartas del sobre *)
	Swap(repartir[z], repartir[20]);
	Swap(repartir[y], repartir[19]);
	Swap(repartir[x], repartir[18]);
	
	(* Aqui hago Shuffle del arreglo de todas las cartas 
	    excluyendo las del sobre *)
	For i := 17 Downto 1 Do
	Begin
	    n := Aleatorio(0,i);
	    Swap(repartir[i], repartir[n]);
	End;
	writeln;
    
	(* Reparto las cartas dependiendo del numero de jugadores *)
	co := 0;
	j := 0;
	While (co < 18) Do
	Begin
	    i := 0;
	    While (i < ultimoJ + 1) And (co < 18) Do
	    Begin
		jugadores[i].mano[j] := phaInicio[repartir[co]];
//		writeln('Jugador', i,j, '   Carta: ', jugadores[i].mano[j]);    Probar Funcion
		jugadores[i].conta.cartas := jugadores[i].conta.cartas + 1;
		co := co + 1;
		i := i + 1;
	    End;
	    j := j + 1;
	End;
    End;
    
        
    
    
    (* Funcion que calcula el valor absoluto de un entero dado *)
    Function VA(n : integer): integer;
    Begin
	If n < 0 Then
	Begin
	    VA := n * -1;
	End
	Else
	Begin
	    VA := n;
	End;
    End;
    
    (* Funcion para preguntas del tipo (s/n) al usuario *)
 
    Procedure Decision (var SioNo : boolean);
    Var
	YN : char;
    n : integer;
    Begin
        Repeat
        Begin
            readln(YN);
            SioNo := true;
            n := 0;
        	Case YN of
        	    's','y' :
        		Begin
        		    SioNo := true;
                    n := 1;
        		End;
        	    'n'     :
        		Begin
        		    SioNo := false;
                    n := 1;
        		End;
            End;
        End
        Until ( n = 1 );
    End;  


    (* Funcion que calcula la distancia ente un usuario y una habitacion *)
    Function Distancia(jugador : user ; Habitacion : lugar): integer;
    Begin
	Distancia := VA(Habitacion.x - jugador.x) 
		     + VA(Habitacion.y - jugador.y);
    End;
    
    
    (* Procedimiento que permite mover a los jugadores *)   
    Procedure Mover (var jugador : user; // Usurio o Computadora.
			 n: integer;    // Lo que saco con el dado.
			 Habitacion : array of lugar);
    Var
	eleccion : Array[0..8] of integer; // Ayuda para Habts. Alcanzables.
	moverA : integer; // Eleccion del Usuario.
	co, i  : integer; // Contadores.
    Begin
	Case n Of // Case de los numeros del Dado (1..6)
	    1    :  
	    Begin
		Writeln('Debe permanecer en su posicion: ', jugador.donde);
		Exit;
	    End;
	    2..6 : 
	    Begin
		If jugador.usuario then // Caso Usuario
		Begin
		    co := 0;
		    writeln('Habitaciones Alcanzables');
		    For i := 0 To 8 Do
		    Begin
			If Distancia(jugador,Habitacion[i]) <= n Then
			Begin 
			    Habitacion[i].alcanzable := True;
			    writeln(co + 1,'.- ', Habitacion[i].nombre, ' es alcanzable.'); 
			    eleccion[co] := i;
			    co := co + 1;
			End;
		    End;
		    
		    write('Ingrese el numero correspondiente: ');
		    read(moverA);
		    (* Verificacion de la Entrada del Usuario *)
		    While (MoverA > co) Or (MoverA < 1) Do
		    Begin
			writeln('Numero Ingresado no valido');
			write('Intente de nuevo: ');
			read(MoverA);
		    End;
		    
		    jugador.x := Habitacion[eleccion[moverA - 1]].x;
		    jugador.y := Habitacion[eleccion[moverA - 1]].y;
		    jugador.donde := Habitacion[eleccion[moverA - 1]].nombre;
		    writeln('Ahora se encuentra en: ', jugador.donde);
		    
		End 
		Else
		Begin // Caso computadora
		    For i := 0 To 8 Do
		    Begin
			If Distancia(jugador,Habitacion[i]) <= n Then
			Begin 
			    writeln(Habitacion[i].nombre, ' es alcanzable');
			    Habitacion[i].alcanzable := True;
			End;
		    End;
		
		    i := Aleatorio(0,8);
		    While (Habitacion[i].nombre = jugador.donde) And Not habitacion[i].alcanzable Do
		    Begin
			i := Aleatorio(0,8);
		    End;
		    
		    jugador.donde := Habitacion[i].nombre;
		    jugador.x := Habitacion[i].x;
		    jugador.y := Habitacion[i].y;
		    writeln('Computadora se movio a: ', jugador.donde);
		    (* 
			* En la linea de Arriba podemos poner algo como
			* writeln(jugador.peon, '(Computadora ', jugador.posicion, ') ', ' Se movio a: ', jugador.donde);'
			*
		    *)
		End;
	    End; // Del caso 2..6
	End; // Del Case completo
    End; // Procedure

    
    
    (* Procedimiento que mueve a un sospechoso/acusado *)
    Procedure MoverSospechoso (sospeAcu : sbr; // Acusacion o Sospecha realizada
				ultimoJ : integer; // Numero de Computadoras
				jugador : user; // Jugador que Sopecho/Acuso 
				var jugadores : array of user);
    Var
	i : integer;
    Begin
	
	For i := 0 To ultimoJ Do
	Begin
	    If (jugadores[i].peon = sospeAcu.prj) 
		And jugadores[i].vida 
		And (i <> jugador.posicion) Then
	    Begin
		writeln('Posicion del que realiza la sospecha: ', jugador.donde);
		writeln('Posicion previa del sospechoso: ', jugadores[i].donde);
		jugadores[i].x := jugador.x;
		jugadores[i].y := jugador.y;
		jugadores[i].donde := jugador.donde;
		writeln('Movi al jugador(', i + 1, ') a la posicion del jugador(', jugador.posicion + 1,'): ', jugadores[i].donde);
	    End;
	
	    If (jugadores[i].peon = sospeAcu.prj) 
		And (i = jugador.posicion) Then
	    Begin
		writeln('Jugador(', jugador.posicion + 1, ') se acusa a si mismo! :0');
	    End;
	End;
    End;

    
    
    
    
    
    (* Procedimiento que elimina jugadores segun sus acusaciones *)
    Procedure Eliminar(var jugador : user;
			acusacion : sbr;
			sobre : sbr);
    Begin
	If (acusacion.prj <> sobre.prj) 
	    Or (acusacion.habt <> sobre.habt ) 
	    Or (acusacion.arma <> sobre.arma ) Then
	Begin
	    jugador.vida := False;
	End
    End;
    
    
    
    
    
    
    
    
    
    
    (* Procedimiento que chequea si el juego debe terminar *)
    Procedure Fin(jugadores : array of user;
		   acusacion, sobre : sbr;
		   var juegoActivo : boolean);
    Var
	i : integer;
    Begin
	
	(* Chequeo si alguna computadora sigue viva *)
	juegoActivo := False;
	i := 1;
	While (i < 6) And (juegoActivo = False) Do
	Begin
	    juegoActivo := jugadores[i].vida;
	    i := i + 1;
	End;
	
	(* Chequeo si el usuario realizo una sospecha *)
	If Not jugadores[0].vida Then
	Begin
	    juegoActivo := False;
	End;

	(* Chequeo si se realizo una acusacion correcta *)
	If (acusacion.prj = sobre.prj) 
	    And (acusacion.habt = sobre.habt) 
	    And (acusacion.arma = sobre.arma) Then
	Begin
	    juegoActivo := False;
	End;
	
    End;
    
Procedure sospecha_computadora ( var sospechaON : boolean; 
                                 var jugadorTurno : usuario; 
                                 var jugadores : array of usuario; 
                                 phaInicio : cartas; 
                                 var sospech : sbr; ultimoJ : integer;
                                 var sospecha.conta : integer;
                                 var sospecha_lista : Array of sbr);

Procedure Match_cartas ( Var carta : sbr ; jugadorTurno : user ;
                         jugadores : user ; var sospechaON : boolean ;
                         var k : integer ; var quien : integer
                         var humano : boolean );
Var
    i,j : integer; // Contadores
  
Begin

If  not ( jugadorTurno.usuario ) Then
Begin

    For i := ( jugadorTurno.posicion + 1 ) to ultimoj Do
    Begin
        If ( sospechaON ) Then
        Begin
            For j := 0 to jugadores[i].cnta.cartas Do
            Begin
                If ( jugadores[i].mano[j] = sospech.arma ) Then
                Begin
                    carta[j] := sospech.arma;
                    sospechaON := false;
                    k := k + 1;
                    quien := i;
                End
                Else 
                Begin    
                    If ( jugadores[i].mano[j] = sospech.prj ) Then
                    Begin
                        carta[j] := sospech.prj;
                        sospechaON := false;
                        k := k + 1;
                        quien := i;
                    End
                    Else
                    Begin
                        carta[j] := sospech.habt;
                        sospechaON := false;
                        k := k + 1;
                        quien := i;
                    End;
                End;
            End;
        End;
    End;      
            
    For i := 0 to ( jugadorTurno.posicion - 1 ) Do
    Begin
        If ( sospechaON ) Then
        Begin
            For j := 0 to jugadores[i].conta.cartas Do
            Begin
                If ( jugadores[i].mano[j] = sospech.arma ) Then
                Begin
                    carta[j] := sospech.arma;
                    sospechaON := false;
                    k := k + 1;
                    quien := i;
                End
                Else 
                Begin    
                    If ( jugadores[i].mano[j] = sospech.prj ) Then
                    Begin
                        carta[j] := sospech.prj;
                        sospechaON := false;
                        k := k + 1;
                        quien := i;
                    End
                    Else
                    Begin
                        carta[j] := sospech.habt;
                        sospechaON := false;
                        k := k + 1;
                        quien := i;
                    End;
                End;
                If ( sospechaON = false ) and ( jugadores[i].usuario ) Then
                Begin
                    humano := True
                End;
            End;
        End;
End
Else
Begin
    For i := ( jugadorTurno.posicion + 1 ) to ultimoj Do
    Begin
        If ( sospechaON ) Then
        Begin
            For j := 0 to jugadores[i].conta.cartas Do
            Begin
                If ( jugadores[i].mano[j] = sospech.arma ) Then
                Begin
                    carta[j] := sospech.arma;
                    sospechaON := false;
                    k := k + 1;
                    quien := i;
                End
                Else 
                Begin    
                    If ( jugadores[i].mano[j] = sospech.prj ) Then
                    Begin
                        carta[j] := sospech.prj;
                        sospechaON := false;
                        k := k + 1;
                        quien := i;
                    End
                    Else
                    Begin
                        carta[j] := sospech.habt;
                        sospechaON := false;
                        k := k + 1;
                        quien := i;
                    End;
                End;
            End;
        End;
    End;
End;
End;

Procedure Refuta_Usuario ( carta : Array of pha; jugadorTurno : usuario;
                           k : integer; m : integer; n : integer; h : integer);
Var
    i : integer; // Variable para iterar.
Begin
    Writeln('En tu mano hay ',k,
        ' cartas que se sospechan, cual quieres mostrar?');
    For i := 0 to 2 Do
    Begin
    Writeln(i + 1,'.- ',carta[i]);
    End;
    s := 'elige el numero de la carta a mostrar';
    Repeat
    Begin
        Writeln(s);
        Read(l);
        S := ' te equivocaste, elige otra vez';
    End
    Until ( n > 0 ) and ( n < 4 );

    If ( carta[l-1] = sospech.arma ) Then
    Begin
        Swap_descarte(jugadorTurno,5-jugadorTurno.conta.arma,m,0);
        jugadorTurno.conta.arma := jugadorTurno.conta.arma + 1;
    End;
    If ( carta[l-1] = sospech.prj ) Then
    Begin 
        Swap_descarte(jugadorTurno,5-jugadorTurno.conta.prj,n,1);
        jugadorTurno.conta.prj := jugadorTurno.conta.prj + 1;
    End;
    If ( carta[l-1] = sospech.habt ) Then
    Begin 
        Swap_descarte(jugadorTurno,8-jugadorTurno.conta.habt,h,2);
        jugadorTurno.conta.prj := jugadorTurno.conta.habt + 1;
    End;
End;

Procedure Refuta_computadora ( carta : Array of pha; var jugadorTurno : usuario;
                                k : integer; quien : integer; m : integer;
                                n : integer; h : integer);
Var
    muestro : integer; // Variable que determina que carta mostrar.
                               

Begin

    muestro := Aleatorio(0,k-1);

    If jugadorTurno.usuario Then
    Begin
        Writeln('Jugador',quien,' te muestra ',carta[muestro]);
    End
    Else
    Begin
        Writeln('Jugador',quien,' Muestra una carta a Jugador'
            ,jugadorTurno.posicion,' La carta es: ',carta[muestro]);
    End;
    If ( carta[muestro] = sospech.arma ) 
    and ( m-1 <= 5 - jugadorTurno.conta.arma) Then
    Begin
        Swap_descarte(jugadorTurno,5-jugadorTurno.conta.arma,m-1,0);
        jugadorTurno.conta.arma := jugadorTurno.conta.arma + 1;
    End;
    If ( carta[muestro] = sospech.prj ) 
    and ( n-1 <= 5 - jugadorTurno.conta.prj) Then
    Begin 
        Swap_descarte(jugadorTurno,5-jugadorTurno.conta.prj,n-1,1);
        jugadorTurno.conta.prj := jugadorTurno.conta.prj + 1;
    End;
    If ( carta[muestro] = sospech.habt ) 
    and ( h <= 8 - jugadorTurno.conta.habt ) Then
    Begin 
        Swap_descarte(jugadorTurno,8-jugadorTurno.conta.habt,h,2);
        jugadorTurno.conta.prj := jugadorTurno.conta.habt + 1;
    End;
End;

Procedure Descarte_sospecha ( var sospecha_lista : Array of sbr; 
                              var sospechaON : boolean; 
                              var sospech : sbr;
                              var sospecha.conta : integer );

Begin
    If not ( sospechaON ) Then
    Begin
        sospecha_lista[sospecha.conta].arma := sospech.arma;
        sospecha_lista[sospecha.conta].prj := sospech.prj;
        sospecha_lista[sospecha.conta].habt := sospech.habt;
        sospecha.conta := sospecha.conta + 1;    
    End;
End;



Var
    h,n,m,l : integer; // variables que permiten programacion robusta
    s : string; // Variable que muestra mensaje al usuario
    k : integer; // determina cuantas cartas son sospechadas por mano
    carta : Array[0..2] of pha; // Arreglo que guarda las cartas sospechadas
    i,j,co : integer; // Contadores 
    humano : boolean; // determina si el usuario ha mostrado una carta
    Begin
    
    
    sospechaON := True;
    humano := false;
    quien := 0;

    sospech.habt := jugadorTurno.donde;
    For i := 0 to 8 Do
    Begin
        If (sospech.habt = jugadorTurno.lista.habt[i] ) Then
        Begin
            h := i;
        End;
    End;
    (* Computadora elegira arma a sospechar *)

    n := Aleatorio(0,5-jugadorTurno.conta.arma);
    sospech.arma := jugadorTurno.lista.arma[n];
    Writeln('La computadora',jugadorTurno.posicion,
        ' sospecha que el arma usada en el asesinato fue: ',sospech.arma);
    (* Computadora elegira personaje a sospechar *)
    m := Aleatorio(0,5-jugadorTurno.conta.prj);
    sospech.prj := jugadorTurno.lista.arma[m];   
    Writeln('La computadora',jugadorTurno.posicion,
        'sospecha quien mato a Mr.Black fue: ',sospech.prj);
    (* Mover el personaje al lugar de la sospecha *)

    For i := 1 to 5 Do
    Begin
        If ( sospech.prj = jugadores[i].peon ) Then
        Begin
            jugadores[i].donde := sospech.habt;
        End;
    End;

    (* Match de las cartas *)

    k := 0;
    Match_cartas(carta,jugadorTurno,jugadores,sospechaON,k,quien,humano);

    (* Refutacion *)

        If ( humano ) and (sospechaON = false ) Then
        Begin
            Refuta_Usuario(carta,jugadorTurno,k,m,n,h);
        End
        Else
        Begin    
            If ( sospechaON = false ) and ( humano = false ) Then
            Begin
                Refuta_computadora(carta,jugadorTurno,k,quien,m,n,h);
            End;
        End;
    End;
    
    (* Descarte de la sospecha *)

    Descarte_sospecha(sospecha_lista,sospechaON,sospech,sospecha.conta);

End;
  


    
VAR
    (* 
     * Personajes: 0 al 5
     * Habitaciones: del 6 al 14
     * Armas: 15 20 
    *)
    phaInicio : cartas = (SenoraBlanco, SenorVerde, SenoraCeleste,
			ProfesorCiruela, SenoritaEscarlata, 
			CoronelMostaza, Biblioteca, Cocina, 
			Comedor, Estudio, Vestibulo, Salon, 
			Invernadero, SalaDeBaile, SalaDeBillar,
			Candelabro, Cuchillo, Cuerda, 
			LlaveInglesa, Revolver, Tubo);

    habitacion : Array[0..8] of lugar;
    sobre   : sbr; // Variable que contiene los hechos reales
    
    
    jugadores : Array[0..5] of user; // Arreglo de jugadores Jugador[0]:Usuario
    
    i,j,co  : integer; // Variables para Iteracion y contadores.
    n,x,y,z : integer; // Variables de usos multiples: swap, etc.
    Turn   : integer; // Contador de los Turnos.
    
    sospecha  : sbr; // variable para realizar sospechas
    acusacion : sbr; // variable para realizar acusaciones
    ultimoJ : integer;
    sospecha_lista : Array[0..323] of sbr;
    sospecha.conta : integer;
   
    SioNo : boolean;
    juegoActivo : boolean;
BEGIN
    writeln;
    Randomize();
    
    (* Ingresa el Numero de Computadoras *)
    NComputadoras(ultimoJ);
    
    Inicializa(phaInicio, ultimoJ, habitacion, jugadores, Turn, SioNo, juegoActivo);
    
    (* 
     * Con este Procedimiento el usuario selecciona el personaje 
     * que usara en el juego y se aginan los demas a las computadoras
     *)
    
    SeleccionPersonaje(phaInicio, jugadores,ultimoJ);
    writeln;
    
    (* Se Asignan las cartas al sobre y se reparten las demas a los jugadores *)
    AsignarCartas(phaInicio, jugadores, sobre,  ultimoJ);
    writeln;
    
    (*
     * Ejemplo de como llamar a Mover sospechoso 
     *)
    // MoverSospechoso(sospecha,ultimoJ,jugadores[i],jugadores);
    
    
    
    
    
    
    (*
     * Ejemplo de la estructura de los turnos
     *
     *)
//     While juegoActivo Do
//     Begin
// 	For i := 0 to 5
// 	Begin
	    
	    (*
	     * Los procedimientos Mover, Sospecha y Acusacion van dentro 
	     * de Turno, por lo que el programa seria una sola llamada a 
	     * Turno para cada jugador
	     *)
	    	    
	    (*
	    Turno(p[i]);
		
		n := Aleatorio(1,6);
		Mover(jugadores[i], n, habitacion);
		Sospecha(sospechaON,p[i],jugadores,phaInicio);
		Acusacion(p[i],sobre);
	    *)
// 	End;
// 	Turno := Turno + 1;
//     End;
//      
//     writeln;

END.
