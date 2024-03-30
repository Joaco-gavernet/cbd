program dos;
uses sysutils;

const
valoralto = 999;
fin = 100000;

type 
vehiculo = record
	cod: integer; { Se utiliza el campo cod (en negativo) para la pila de libres. } 
	precio: real;
	patente: string[6]; 
end;

arch = file of vehiculo;

procedure leer(var x: vehiculo);
begin
	write('Ingresar datos (codigo, precio, patente de 6 digitos): ');
	readln(x.cod, x.precio, x.patente); 
end;

procedure insertar(var f: arch; var x: vehiculo);
var head: vehiculo;
begin
	seek(f,0);
	if (filesize(f) <> 0) then begin 
		read(f,head);
		if (head.cod <> 0) then 
			seek(f, -head.cod) 
		else 
			seek(f,filesize(f));
	end;

	write(f, x);

end;

procedure eliminar(var f: arch; var x: vehiculo);
var act, head: vehiculo;
begin
	seek(f,0); 
	read(f,head);

	while (not EOF(f)) and (x.cod <> act.cod) do read(f,act);
	if (act.cod = x.cod) then begin
		x.cod := head.cod;
		seek(f,filepos(f) -1);
		write(f,x);

		head.cod := -(filepos(f) -1);
		seek(f,0);
		write(f,head);
	end;
end;

procedure listar(var f: arch);
var act: vehiculo;
begin
	{ TODO: fix issue when printing string act.patente, missing last char. }
	 
	seek(f,0);
	act.cod := -1;
	if (not EOF(f)) then read(f,act);
	while (not EOF(f)) do begin 
		writeln(act.cod, ' ', act.precio, ' ', act.patente);
		read(f,act);
	end;
	writeln(act.cod, ' ', act.precio, ' ', act.patente);
end;

var
f: arch;
reg: vehiculo;
op: integer;

begin
	{ Solucion con baja logica y compactacion final. } 
	assign(f,'dos-vehiculos');
	if fileexists('dos-vehiculos') then reset(f)  
	else rewrite(f);

	reg.cod := 0;
	if (filesize(f) = 0) then insertar(f,reg); { Se incerta registro cabecera de pila. }

	writeln('Opciones: ');
	writeln('0) Finalizar programa. ');
	writeln('1) Ingresar nuevo vehiculo. ');
	writeln('2) Eliminar vehiculo. (baja logica) ');
	writeln('3) Listar vehiculo. ');
	writeln('4) Reescribir archivo. ');

	writeln('');
	read(op);
	while (op <> 0) do begin
	case op of 
		1: begin
			leer(reg);
			insertar(f,reg);
			writeln('Vehiculo insertado correctamente. ');
		end;

		2: begin
			write('Ingresar codigo de vehiculo a eliminar: ');
			read(op);
			reg.cod := op;
			eliminar(f,reg);
			writeln('Vehiculo eliminado correctamente. ');
		end;

		3: begin
			writeln('Listando ', filesize(f), ' vehiculos...');
			listar(f);
		end;

		4: begin
			rewrite(f);
		end;
	end;
	writeln('');
	read(op);
	end;

	close(f);
end.
