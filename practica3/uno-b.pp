program uno;
uses sysutils;

const
fin = 100000;

type 
especie = record
	cod: integer; { codigo de especie } 
	altProm: double;
	nombre: string[30]; { si el nombre es '#' se considera baja logica }
end;

arch = file of especie;

procedure leer(var x: especie);
begin
	writeln('Ingresar datos (codigo, altura promedio, nombre): ');
	readln(x.cod, x.altProm, x.nombre); { TODO: solve runtime error }
end;

procedure insertar(var f: arch; var x: especie);
begin
	seek(f,filesize(f) -1);
	write(f,x);
end;

procedure eliminar(var f: arch; var x: especie);
var aux, act: especie;
begin
	if (filesize(f) > 2) then begin
		seek(f,filesize(f) -2);
		read(f,aux);
	end;

	seek(f,0);
	act.cod := -1;
	if (not EOF(f)) then read(f,act);
	while (not EOF(f)) and (act.cod <> x.cod) do read(f,act);
	if (act.cod = x.cod) then begin
		seek(f,filepos(f) -1);
		write(f,aux);
		seek(f,filesize(f) -2);
		truncate(f);
	end;
end;

var
f: arch;
reg: especie;
op: byte;

begin
	{ Solucion con baja logica y compactacion final. } 
	assign(f,'uno-plantas');
	reset(f);  

	writeln('Opciones: ');
	writeln('0) Finalizar programa. ');
	writeln('1) Ingresar nueva especie. ');
	writeln('2) Eliminar especie. (baja fisica)');
	writeln('');
	
	read(op);
	while (op <> 0) do begin
	case op of 
		1: begin
			leer(reg);
			insertar(f,reg);
			writeln('Especie insertada correctamente. ');
		end;

		2: begin
			leer(reg);
			eliminar(f,reg);
			writeln('Especie eliminada correctamente. ');
		end;
	end;
	read(op);
	end;

	close(f);
end.
