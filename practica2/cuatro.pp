Program cuatro;
Uses sysutils;
Const
valoralto = 10000;
tot = 20;

Type
Pelicula = record
	cod, duracion, asistentes: Integer;
	nombre, genero, director: String[40];
	fecha: String[10]; { DD/MM/AAAA } 
End;

Merge = record
	cod, duracion, total: Integer;
	nombre, genero, director: String[40];
	fecha: String[10]; { DD/MM/AAAA } 
End;

Detalle = file of Pelicula;
Maestro = file of Merge;

regN = Array[1..tot] of Pelicula;
fileN = Array[1..tot] of Detalle;

Var
m: Merge;
am: Maestro;
min: Pelicula;
dets: regN;
adets: fileN;

ant_cod: Integer;
i: Integer;

Procedure leer(var archivo: Detalle; var dato: Pelicula);
Begin
	if not EOF(archivo) then read(archivo,dato)
	else dato.cod := valoralto;
End;

Procedure determinarMinimo(var dets: regN; var indice_min: Integer);
Var i: Integer;
Begin
	indice_min := 1;
	for i := 1 to tot do 
		if dets[i].cod < dets[indice_min].cod then 
			indice_min := i;
End;

Procedure minimo(var dets: regN; var min: Pelicula; var adets: fileN);
Var indice_min: Integer;
Begin
	determinarMinimo(dets, indice_min);
	min := dets[indice_min];
	leer(adets[indice_min], dets[indice_min]);
End;

Begin
	for i := 1 to tot do Begin
		Assign(adets[i], concat('det-cuatro',IntToStr(i)));
		Reset(adets[i]);
		leer(adets[i],dets[i]);
	End;

	Assign(am,'maestro-cuatro');
	Rewrite(am);

	minimo(dets,min,adets);
	while (min.cod <> valoralto) do Begin
		ant_cod := min.cod;
		m.cod := min.cod;
		m.total := 0;
		{ Copiar el resto de la informacion ... }

		while (ant_cod = min.cod) do Begin
			m.total := m.total + min.asistentes;
			minimo(dets,min,adets);
		End;
		Write(am,m);
	End;

	Close(am);

	Reset(am); { Bad practice maybe? (Closing and reopening a file) }
	while not EOF(am) do Begin
		Read(am,m);
		WriteLn(m.cod, ' ', m.total);
	End;
	Close(am);
End.
