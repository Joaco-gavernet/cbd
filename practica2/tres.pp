Program tres;
Uses sysutils;

Const
tot = 3;
valoralto = 10000;

Type
Detalle = record
	cod, num, vendidos: Integer;
End;

Maestro = record
	cod, num, stock, minStock: Integer;
End;

archDetalle = File of Detalle;
archMaestro = File of Maestro;

arr_detalle = Array[1..tot] of Detalle;
arr_archDetalle = Array[1..tot] of archDetalle;

Procedure leer(var adet: archDetalle; var det: Detalle );
Begin
	if (not EOF(adet)) then Read(adet,det)
	else det.cod:= valoralto;
End;

Procedure minimo(var dets: arr_detalle; var adets: arr_archDetalle; var min: Integer);
Var i: Integer;
Begin
	min := valoralto;
	for i := 1 to tot do Begin
		WriteLn(i, ' ', min, ' ', valoralto);
		if (min = valoralto) or (dets[i].cod < dets[min].cod) then min := i
		else Begin
			if (dets[i].cod = dets[min].cod) and (dets[i].num < dets[min].num) then min := i; 
		End;
	End;
End;

Var
op: Byte;
i, min: Integer;
ant_cod: Integer;
dets: arr_detalle;
adets: arr_archDetalle;
d: Detalle;
m: Maestro;
am: archMaestro;
as: Text;

Begin
	{ Se abren los archivos: maestro, detalles[tot] y archStock }
	Assign(am,'maestro-tres');
	Reset(am);
	for i := 1 to tot do Begin
		Assign(adets[i],concat('detalle-tres',IntToStr(i)));
		Reset(adets[i]);
	End;
	Assign(as,'stock-tres');
	Rewrite(as);

	WriteLn('Opciones: ');
	WriteLn('0) Finalizar programa. ');
	WriteLn('1) Cargar informacion en archivo detalle. ');
	WriteLn('2) Cargar informacion en archivo maestro. ');
	WriteLn('3) Actualizar archivo maestro. ');
	WriteLn('4) Listar detalles. ');
	WriteLn('5) Listar archivo maestro. ');
	WriteLn('6) Limpiar todos los archivos detalle. ');
	WriteLn('7) Limpiar archivo maestro. ');
	
	Write('Ingresar opcion: ');
	Read(op);
	while (op <> 0) do Begin

		Case (op) of 
			1: Begin
				Write('Elija en cual de los ', tot, ' detalles desea cargar informacion: ');
				Read(op); { Notar que se recicla la variable op para leer el archivo donde se cargara la informacion }
				Write('Ingresar datos en orden (codigo, numero de calzado, total vendidos): ');
				ReadLn(d.cod, d.num, d.vendidos);
				Seek(adets[op], fileSize(adets[op]));
				Write(adets[op],d);
				WriteLn('Detalle ', op, ' actualizado correctamente. ');
			End;

			2: Begin
				WriteLn('Al ingresar informacion en el archivo maestro recuerde que se debe respetar el orden creciente segun codigo de calzado y numero. ');
				Write('Ingresar datos en orden (codigo, numero de calzado, stock, minimo stock): ');
				ReadLn(m.cod, m.num, m.stock, m.minStock);
				Seek(am,fileSize(am));
				Write(am,m);
			End;

			3: Begin
				ant_cod := -1;

				Seek(am,0);
				Read(am,m);
				for i := 1 to tot do Begin
					Seek(adets[i],0);
					leer(adets[i],dets[i]);
				End;

				minimo(dets,adets,min);
				WriteLn('minimo antes del while ', min);
				WriteLn('codigo antes del while ', dets[min].cod);
				while dets[min].cod <> valoralto do Begin
					WriteLn('minimo actual: ', min);

					{ Se busca en el archivo maestro por el calzado a actualizar } 
					while (m.cod <> dets[min].cod) or (m.num <> dets[min].num) do Begin
						if (ant_cod <> m.cod) then WriteLn('Calzado ', ant_cod, ' sin ventas.');	
						ant_cod := m.cod;
						Read(am,m);
					End;

					{ Actualizacion de archivo maestro desde det[min] }
					m.stock := m.stock - dets[min].vendidos;
					Seek(am, filePos(am) -1);
					Write(am,m);

					{ Si se supera el stock minimo, se agrega al archivo de calsadossinstock.txt }
					if (m.stock < m.minStock) then WriteLn(as,m.cod);

					leer(adets[min], dets[min]);
					minimo(dets,adets,min);
				End;

				WriteLn('Archivo maestro actualizado correctamente. ');
			End;

			4: Begin
				for i:= 1 to tot do Begin
					Seek(adets[i],0);
					if (not EOF(adets[i])) then Begin
						WriteLn('Detalle nro ', i, ':');
						Read(adets[i],d);
						while (not EOF(adets[i])) do Begin
							WriteLn(d.cod, ' ', d.num, ' ', d.vendidos);
							Read(adets[i],d);
						End;
						WriteLn(d.cod, ' ', d.num, ' ', d.vendidos);
					End else WriteLn('Detalle ', i, ' vacio. ');
				End;
			End;

			5: Begin
				Seek(am,0);
				if (not EOF(am)) then Begin
					WriteLn('Listando archivo maestro...');
					Read(am,m);
					while (not EOF(am)) do Begin
						WriteLn(m.cod, ' ',  m.num, ' ', m.stock, ' ', m.minStock);
						Read(am,m);
					End;
					WriteLn(m.cod, ' ',  m.num, ' ', m.stock, ' ', m.minStock);
				End else WriteLn('El archivo maestro se encuentra vacio. ');
			End;

			6: Begin
				WriteLn('Limpiando detalles...');
				for i := 1 to tot do Begin
					Seek(adets[i],0);
					Truncate(adets[i]);
				End;
			End;

			7: Begin
				WriteLn('Limpiando archivo maestro...');
				Seek(am,0);
				Truncate(am);
			End;
		End;

		Write('Ingresar opcion: ');
		Read(op);
	End;

	Close(am);
	for i := 1 to tot do Close(adets[i]);
End.
