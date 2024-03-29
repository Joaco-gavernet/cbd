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
	write('Ingresar datos (codigo, altura promedio, nombre): ');
	readln(x.cod, x.altProm, x.nombre); 
end;

procedure insertar(var f: arch; var x: especie);
begin
	if (filesize(f) > 0) then seek(f,filesize(f) -1);
	write(f,x);
end;

procedure eliminar(var f: arch; var x: especie);
var act: especie;
begin
	if (not EOF(f)) then read(f,act);
	while (not EOF(f)) and (x.cod <> act.cod) do read(f,act);
	if (act.cod = x.cod) then begin
		x.nombre := '#';
		seek(f,filepos(f) -1);
		write(f,x);
	end;
end;

procedure copiarArchivo(var source: arch; var dest: arch);
var aux: especie;
begin
	aux.cod := -1;
	if (not EOF(source)) then read(source,aux);
	while (not EOF(source)) do begin
		write(dest,aux);
		read(source,aux);
	end;
	if (aux.cod <> -1) then write(dest,aux);
end;

procedure compactarArchivo(var f: arch; var source: arch);
var aux: especie;
begin
	aux.cod := -1;
	if (not EOF(source)) then read(source,aux);
	while (not EOF(source)) do begin
		if (aux.nombre <> '#') then write(f,aux);
		read(source,aux);
	end;
	if (aux.cod <> -1) and (aux.nombre <> '#') then write(f,aux);
end;

procedure listar(var f: arch);
var act: especie;
begin
	act.cod := -1;
	if (not EOF(f)) then read(f,act);
	writeln('fin. ', act.nombre);
	while (not EOF(f)) do begin
		writeln(act.cod, ' ', act.altProm, ' ', act.nombre);
		read(f,act);
	end;
	if (act.cod <> -1) then writeln(act.cod, ' ', act.altProm, ' ', act.nombre);
end;

var
f, nf: arch;
reg: especie;
op: byte;

begin
	{ Solucion con baja logica y compactacion final. } 
	assign(f,'uno-plantas');
	if FileExists('uno-plantas') then reset(f)  
	else rewrite(f);
	assign(nf,'uno-plantas-aux'); { Archivo auxiliar para realizar compactacion en 'uno-plantas' }
	rewrite(f);

	writeln('Opciones: ');
	writeln('0) Finalizar programa y compactar archivo. ');
	writeln('1) Ingresar nueva especie. ');
	writeln('2) Eliminar especie. (baja logica) ');
	writeln('3) Listar especies. ');
	writeln('');

	read(op);
	while (op <> 0) do begin
	case op of 
		0: begin
			copiarArchivo(f,nf);
			truncate(f); { Vaciar archivo original, para realizar compactacion }
			compactarArchivo(f,nf);
			writeln('Archivo compactado correctamente. ');
		end;

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

		3: begin
			writeln('Listando especies...');
			listar(f);
		end;
	end;
	writeln('');
	read(op);
	end;

	close(f);
end.
