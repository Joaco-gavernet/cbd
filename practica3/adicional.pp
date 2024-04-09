program dos;
uses sysutils;

const
valoralto = 999;
fin = 100000;

type 
profesional = record
	DNI: integer; { Se utiliza el campo cod (en negativo) para la pila de libres. } 
	nombre: string;
	sueldo: real;
end;

tArchivo = file of profesional;

procedure leer(var x: profesional);
begin
	write('Ingresar datos (DNI, sueldo, nombre): ');
	readln(x.DNI, x.sueldo, x.nombre);
end;

procedure agregar(var arch: tArchivo; p: profesional);
var head: profesional;
begin
	seek(arch,0);
	if (filesize(arch) <> 0) then begin 
		read(arch,head);
		if (head.DNI <> 0) then 
			seek(arch, -head.DNI) 
		else 
			seek(arch, filesize(arch));
	end;

	write(arch, p);

end;

procedure eliminar(var arch: tArchivo; DNI: integer; var bajas: TEXT);
var act, head: profesional;
begin
	seek(arch,0); 
	read(arch,head);

	while (not EOF(arch)) and (DNI <> act.DNI) do read(arch,act);
	if (act.DNI = DNI) then begin
		act.DNI := head.DNI;
		seek(arch,filepos(arch) -1);
		write(arch,act);

		head.DNI := -(filepos(arch) -1);
		seek(arch,0);
		write(arch,head);

		writeln(bajas, DNI);
	end;
end;

procedure listar(var f: tArchivo);
var act: profesional;
begin
	{ TODO: fix issue when printing string act.patente, missing last char. }
	 
	seek(f,0);
	act.DNI := -1;
	if (not EOF(f)) then read(f,act);
	while (not EOF(f)) do begin 
		writeln(act.DNI, ' ', act.nombre, ' ', act.sueldo);
		read(f,act);
	end;
	writeln(act.DNI, ' ', act.nombre, ' ', act.sueldo);
end;

var
f: tArchivo;
reg: profesional;
op: integer;
eliminados: text;

begin
	{ Solucion con baja logica y compactacion final. } 
	assign(f,'adicional-profesionales');
	if fileexists('adicional-profesionales') then reset(f)  
	else rewrite(f);

	assign(eliminados,'adicional-profesionales-eliminados');
	if fileexists('adicional-profesionales-eliminados') then reset(eliminados)  
	else rewrite(eliminados);

	reg.DNI := 0;
	if (filesize(f) = 0) then agregar(f,reg); { Se incerta registro cabecera de pila. }

	writeln('Opciones: ');
	writeln('0) Finalizar programa. ');
	writeln('1) Ingresar nuevo profesional. ');
	writeln('2) Eliminar profesional. (baja logica) ');
	writeln('3) Listar profesional. ');
	writeln('4) Reescribir archivo. ');

	writeln('');
	read(op);
	while (op <> 0) do begin
	case op of 
		1: begin
			leer(reg);
			agregar(f,reg);
			writeln('Profesional insertado correctamente. ');
		end;

		2: begin
			write('Ingresar DNI de profesional a eliminar: ');
			read(op);
			eliminar(f,op,eliminados);
			writeln('Profesional eliminado correctamente. ');
		end;

		3: begin
			writeln('Listando ', filesize(f), ' profesionales...');
			listar(f);
		end;

		4: begin
			rewrite(f);
			reg.DNI := 0;
			if (filesize(f) = 0) then agregar(f,reg); 
		end;
	end;
	writeln('');
	read(op);
	end;

	close(f);
end.
