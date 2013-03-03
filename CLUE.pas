(* Este es el Proyecto Serio *)
Program CLUE;

    Function Aleatorio(inicio : integer; tope : integer) : integer;
    Var 
	amplitud : integer;
    Begin
	amplitud := (tope - inicio) + 1;
	Aleatorio := Random(amplitud) + inicio;
    End;

Type 
 
    pha = (SenoraBlanco, SenorVerde, SenoraCeleste, ProfesorCiruela,
	   SenoritaEscarlata, CoronelMostaza, Biblioteca, Cocina, Comedor,
	   Estudio, Vestibulo, Salon, Invernadero, SalaDeBaile, SalaDeBillar,
	   Candelabro, Cuchillo, Cuerda, LlaveInglesa, Revolver, Tubo);
    
    p = SenoraBlanco..CoronelMostaza;
    h = Biblioteca..SalaDeBillar;
    a = Candelabro..Tubo;
    
    cartas= Array[0..20] of pha;
    armas = Array[0..5] of a;
    habts = Array[6..14] of h;
    prjs  = Array[15..20] of p;
	   
    ubic =  Record 
		x : integer;
		y : integer;
	    End;
        
    lugar = Record
		cual  : h;
		where : ubic;
	    End;
    
    sbr  =  Record
		arma : a;
		habt : h;
		prj  : p;
	    End;
		

    user =  Record
		where : ubic; // Ubicacion x y del usuario
		peon  : p;  // Ficha que usa para jugar
		lista : cartas;  // Lista de cartas
	    End;


Var
    (* 
    Personajes: 0 al 5
    Habitaciones: del 6 al 14
    Armas: 15 20 
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
    sobre   : sbr;
    
    usuario : user;
    pc : Array[0..4] of user;
    
    i,j,co  : integer;
    n,x,y,z : integer;
    tmp     : integer;

Begin 
    writeln;
    Randomize();

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
    usuario.peon := phaInit[i-1];
    writeln('El personaje seleccionado fue: ', usuario.peon);
  
    writeln;
    
    (*Codigo que asigna los personajes a las pc's*)
    tmp := repartirPrj[i-1];
    repartirPrj[i-1] := repartirPrj[5];
    repartirPrj[5] := tmp;
    
    For i:= 0 To 4 Do
    Begin
	pc[i].peon := phaInit[repartirPrj[i]];
	writeln('pc', i, ' agarro a: ', pc[i].peon);
    End;
    writeln;
    
    (* Aqui se seleccionan los hechos reales y se reparten las cartas *)
    
    (* Seleccion del Asesino *)
    x := Aleatorio(0,5);
    writeln(x);
    sobre.prj := phaInit[x];
    
    (* Seleccion de la Habitacion donde se produjo el asesinato *)
    y := Aleatorio(6,14);
    writeln(y);
    sobre.habt := phaInit[y];
    
    (* Seleccion del arma con la que se cometio el asesinato *)
    z := Aleatorio(15,20);
    writeln(z);
    sobre.arma := phaInit[z];
    
    writeln;
      
    (* Swapeo las variables a las tres posiciones finales para 
	no repartir las cartas del sobre *)
    tmp := repartir[z];
    repartir[z] := repartir[20];
    repartir[20] := tmp;
    write('El Arma es: ', sobre.arma);
    writeln;
        
    tmp := repartir[y];
    repartir[y] := repartir[19];
    repartir[19] := tmp;
    write('La Habitacion es: ', sobre.habt);
    writeln;

    tmp := repartir[x];
    repartir[x] := repartir[18];
    repartir[18] := tmp;
    write('El Asesino es: ', sobre.prj);
    writeln;
    
    (* Aqui hago Shuffle del arreglo de todas las cartas 
	excluyendo las del sobre *)
    For i := 17 Downto 1 Do
    Begin
	n := Aleatorio(0,i);
	tmp := repartir[i];
	repartir[i] := repartir[n];
	repartir[n] := tmp;
    End;
    writeln;
    
    (* Loop para verificar Datos *)
    For i := 0 To 20 Do
    Begin
	writeln(phaInit[repartir[i]], ', ');
    End;
    
    
    
    co := 0;
    For i := 0 To 4 Do
    Begin
	For j := 0 To 2 Do
	Begin
	    pc[i].lista[j] := phaInit[repartir[co]];
	    co := co + 1;
	    writeln('pc', i, j, ' ', pc[i].lista[j]);
	End;
    End;
    
    
    
      
  
  
    writeln;
End.
