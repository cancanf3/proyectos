(* Este es el Proyecto Serio *)
Program CLUE;

Type 
 
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
	descarte = Record // Variable contadora de descarte para las pc 
        arma : integer;
        habt : integer;
        prj  : integer;
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
        mano : array[0..2] of pha;
		donde : h;
		peon  : p;  // Ficha que usa para jugar
		lista : lista_cartas;  // Lista de cartas
        conta : descarte;
     posicion : integer;
        
            End;
  
   (* Funcion que hace swap para descartar de la lista *)
    Procedure Swap_descarte(var player1 : lista_cartas; 
                            var player2 : lista_cartas);
    Var
	tmp : lista_cartas;
    Begin
	tmp := player1;
	player1 := player2;
	player2 := tmp;
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
 
    Procedure decision (var SioNo : boolean);
    Var
	YN : string;
    n : integer;
    Begin
        Repeat
        Begin
            readln(YN);
            SioNo := true;
            n := 0;
        	Case YN of
        	    's','y','si','yes' :
        		Begin
        		    SioNo := true;
                    n := 1;
        		End;
        	    'n','no' :
        		Begin
        		    SioNo := false;
                    n := 1;
        		End;
            End;
        End
        Until ( n = 1 );
    End;  
    (* Funcion que determina las habitaciones alcanzables con el numero
	obtenido al lanzar el dado *)
    
    (*
    Procedure Alcanzable(n : integer);
    Var 
	i : integer;
    Begin
	Writeln('Habitaciones Alcanzables');
	If n = 1 Then
	Begin
	    Writeln('Debe permanecer en su posicion: ', usuario.donde.nombre);
	    Exit;
	End;
	
	For i := 0 To 8 Do
	Begin
	    If VA(Habitacion[i].x - usuario.donde.x) + VA(Habitacion[i].y - usuario.donde.y) <= n Then
	    Begin
		writeln(Habitacion[i].nombre, ' es alcanzable');
	    End;
	End;
    End;
    *)


Var
    (* 
     * Personajes: 0 al 5
     * Habitaciones: del 6 al 14
     * Armas: 15 20 
    *)
    phaInit : cartas = (SenoraBlanco, SenorVerde, SenoraCeleste,
			ProfesorCiruela, SenoritaEscarlata, 
			CoronelMostaza, Biblioteca, Cocina, 
			Comedor, Estudio, Vestibulo, Salon, 
			Invernadero, SalaDeBaile, SalaDeBillar,
			Candelabro, Cuchillo, Cuerda, 
			LlaveInglesa, Revolver, Tubo);

    repartirPrj: Array[0..5] of integer = (0,1,2,3,4,5);
    repartir   : Array[0..20] of integer = (0,1,2,3,4,5,6,7,8,9,10,11,12,
						13,14,15,16,17,18,19,20);

    habitacion : Array[0..8] of lugar;
    sobre   : sbr; // Variable que contiene los hechos reales
    
    
    pc : Array[0..5] of user; // Arreglo de Jugadores pc[0]:Usuario
    
    i,j,co  : integer; // Variables para Iteracion y contadores
    n,x,y,z : integer; // Variables de usos multiples: swap, etc.
       
    moverA : h;
    sospecha : sbr; // variable para realizar sospechas
    

    sospechaON : boolean;
    SioNo : boolean;

BEGIN
    writeln;
    Randomize();
    
    (* Inicializo las Habitaciones con sus ubicaciones *)
    co := 0;
    For i := 6 To 14 Do
    Begin
	habitacion[co].nombre := phaInit[i];
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
    (* Inicializacion de Variables *)
    SioNo := True; // Variable del procedimiento decision
    sospechaON := False;

    For i := 0 to 5 Do // Inicializo a todos los jugadores
    Begin
        pc[i].conta.arma := 0;
        pc[i].conta.habt := 0;
        pc[i].conta.prj  := 0;
    	pc[i].x := 2;
    	pc[i].y := 2;
    	pc[i].usuario := False;
    	pc[i].donde := Vestibulo;
        pc[i].posicion := i
    End;
    pc[0].usuario := True; // Determinar que el jugador pc[0] es el Usuario

    (* Con esta seccion de codigo el usuario selecciona el personaje 
	que usara en el juego *)
    writeln('Seleccione un personaje ingresando el numero correspondiente.');
    For i := 0 To 5 Do
    Begin
	    Writeln(i+1, '.- ', phaInit[i]);
    End;
    
    write('Usuario Selecciona: ');
    read(i);
    While (i > 6) Or (i < 1) Do
    Begin
	writeln('Numero ingresado no valido');
	write('Usuario Selecciona: ');
	read(i);
    End;
    pc[0].peon := phaInit[i-1];
    writeln('El personaje seleccionado fue: ', pc[0].peon);
    writeln;
    
    (*Codigo que asigna los personajes a las pc's*)
    Swap(repartirPrj[i-1], repartirPrj[5]);

    For i:= 0 To 5 Do
    Begin
	pc[i+1].peon := phaInit[repartirPrj[i]];
    End;
    writeln;
    
    (* Aqui se seleccionan los hechos reales y se reparten las cartas *)
    
    (* Seleccion del Asesino *)
    x := Aleatorio(0,5);
    sobre.prj := phaInit[x];
    
    (* Seleccion de la Habitacion donde se produjo el asesinato *)
    y := Aleatorio(6,14);
    sobre.habt := phaInit[y];
    
    (* Seleccion del arma con la que se cometio el asesinato *)
    z := Aleatorio(15,20);
    sobre.arma := phaInit[z];
    writeln;

    (* Swapeo las variables a las tres posiciones finales para 
	no repartir las cartas del sobre *)
    Swap(repartir[z], repartir[20]);
    writeln('El Arma es: ', sobre.arma);
    
    Swap(repartir[y], repartir[19]);
    writeln('La Habitacion es: ', sobre.habt);
    
    Swap(repartir[x], repartir[18]);
    writeln('El Asesino es: ', sobre.prj);
        
    
    (* Aqui hago Shuffle del arreglo de todas las cartas 
	excluyendo las del sobre *)
    For i := 17 Downto 1 Do
    Begin
	n := Aleatorio(0,i);
	Swap(repartir[i], repartir[n]);
    End;
    writeln;
        
    (* Aqui asigno las cartas *)
    co := 0;
    For i := 0 To 5 Do
    Begin
	For j := 0 To 2 Do
	Begin
	    pc[i].mano[j] := phaInit[repartir[co]];
	    co := co + 1;
	    // Esto para explicarle a Pena
	End;
    End;
    
    
    (*
     * Aqui comienza el juego
     * el primer turno es del usuario y luego 
     * cada una de las computadoras
     *)
   
    writeln;
    
    (* 
     *	Turno del Usuario 
     *)
    
    readln;
    writeln('Turno del Usuario');
    writeln;
    
    writeln('Presione <Enter> para lanzar el dado');
    readln;
    
    (* Emulacion de Dado *)
    n := Aleatorio(1,6);
    writeln('Al lanzar el dado obtuvo un ', n, '.');
    writeln;
    
    (* Calculo de Habitaciones Alcanzables *)
    Writeln('Habitaciones Alcanzables');
    writeln;
    
    Case n Of
	1    :  
	    Begin
		Writeln('Debe permanecer en su posicion: ', pc[0].donde);
	    End;
	2..6 :  
	    Begin
		For i := 0 To 8 Do
		Begin
		    If VA(Habitacion[i].x - pc[0].x) + 
			    VA(Habitacion[i].y - pc[0].y) <= n Then
		    Begin 
			Writeln(Habitacion[i].nombre, ' es alcanzable');
			Habitacion[i].alcanzable := True;
		    End;
		End;

		write('A cual de las posibles habitaciones desea ir: ');
		
		readln(moverA);
		For i := 0 To 8 Do
		Begin
		    If (moverA = Habitacion[i].nombre) 
			And Habitacion[i].alcanzable Then
		    Begin
			pc[0].x := Habitacion[i].x;
			pc[0].y := Habitacion[i].y;
			pc[0].donde := Habitacion[i].nombre;
			writeln('Ahora se encuentra en: ', pc[0].donde);
		    End
		    Else If (moverA = Habitacion[i].nombre) 
			And Not Habitacion[i].alcanzable Then
		    Begin
			writeln('Habitacion no alzanzable se quedara en: ', 
				    pc[0].donde);
		    End;
		
		End;
		
	    End; // Del caso 2..6
    End; // Del Case completo
    
    End;
    
    
    

    
    
    
    
    
    
    
    
  
  
    writeln;
End.
