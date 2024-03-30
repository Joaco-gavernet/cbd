program uno;
uses sysutils;

const
valoralto = 999;
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
	write('Ingresar datos (codigo, altura promedio, nombre): ');
	readln(x.cod, x.altProm, x.nombre); 
end;

procedure insertar(var f: arch; var x: especie);
begin
	seek(f,filesize(f));
	write(f,x);
end;

procedure eliminar(var f: arch; var x: especie);
var act, last: especie;
begin
	writeln('Size: ', filesize(f));

	{ Copiar ultimo registro }
	if (filesize(f) > 0) then seek(f,filesize(f) -1)
	else seek(f,0);
	read(f,last);

	seek(f,0);
	if (not EOF(f)) then read(f,act);
	while (not EOF(f)) and (x.cod <> act.cod) do read(f,act);
	if (act.cod = x.cod) then begin
		seek(f,filepos(f) -1);
		write(f,last);

		if (filesize(f) > 0) then seek(f,filesize(f) -1)
		else seek(f,0);
		truncate(f);
	end;

	writeln('Size: ', filesize(f));
end;

procedure listar(var f: arch);
var act: especie;
begin
	seek(f,0);
	act.cod := -1;
	if (not EOF(f)) then read(f,act);
	while (not EOF(f)) do begin 
		writeln(act.cod, ' ', act.altProm, ' ', act.nombre);
		read(f,act);
	end;
	if (act.cod <> -1) then writeln(act.cod, ' ', act.altProm, ' ', act.nombre);
end;

var
f: arch;
reg: especie;
op: integer;

begin
	{ Solucion con baja logica y compactacion final. } 
	assign(f,'uno-plantas');
	if fileexists('uno-plantas') then reset(f)  
	else rewrite(f);

	writeln('Opciones: ');
	writeln('0) Finalizar programa. ');
	writeln('1) Ingresar nueva especie. ');
	writeln('2) Eliminar especie. (baja fisica) ');
	writeln('3) Listar especies. ');

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
			write('Ingresar codigo de especie a eliminar: ');
			read(op);
			reg.cod := op;
			eliminar(f,reg);
			writeln('Especie eliminada correctamente. ');
		end;

		3: begin
			writeln('Listando ', filesize(f), ' especies...');
			listar(f);
		end;
	end;
	writeln('');
	read(op);
	end;

	close(f);
end.
