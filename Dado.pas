(* 
	Funcion que simula el Dado. Random(n) 
    Genera numeros random del 0 hasta n-1
*)

Program Dado;

    (* 
	    Declaracion de la funcion, lo unico que se
	ve medio raro es que no le paso nada como
	parametro 
    *)
    Function Aleatorio(inicio : integer; tope : integer) : integer;
    var 
	amplitud : integer;
    Begin
	amplitud := tope - inicio + 1;
	Aleatorio := Random(amplitud) + inicio;
    End;
  
Var

    i,x,y : integer;
  
  
  
Begin
    Randomize(); // Esto es necesario para que los numeros cambien
    Writeln;
    
    write('Ingrese el inicio del random: ');
    read(x);
    write('Ingrese el tope del random: ');
    read(y);
   
    For i := 0 to 40 do
    Begin
    Writeln(Aleatorio(x,y)); // Esta seria un ejemplo de la llamada en nuestro codigo
    End;
    
    
    
    
    Writeln;
End.