Program adicional;
Uses sysutils;
Const
valoralto = 600;
tot = 5;

Type
regD = record
	codProv, codLoc: Integer;
	totVotos, validos, anulados, blanco: Integer;
End;

regMaestro = record
	codProv: Integer;
	totVotos, validos, anulados, blanco: Integer;
	nomProv: String; 
End;

regResultado = record
	procesados, validos, anulados, blanco: Integer;
End;

Detalle = file of regD;
Maestro = file of regMaestro;
Resultado = file of regResultado;

Procedure leer(var det: Detalle; var reg_det: regD);
Begin
	if (not EOF(det)) then read(det,reg_det)
	else reg_det.codProv := valoralto;
End;

Procedure determinarMinimo(var reg_dets: Array of regD; var min: Integer);
Var i: Integer;
Begin
	for i := 1 to tot do Begin
		if (reg_dets[i].codProv < reg_dets[min].codProv) then Begin
			if (reg_dets[i].codLoc < reg_dets[min].codLoc) then
				min := i;
		End;
	End;
End;

Procedure minimo(var dets: Array of Detalle; var min: regD; var reg_dets: Array of regD);
Var indice_min: Integer;
Begin
	determinarMinimo(reg_dets,indice_min);
	min := reg_dets[indice_min];
	leer(dets[indice_min],reg_dets[indice_min]);
End;

Var
min: regD;
regm: regMaestro;
regr: regResultado;
m: Maestro;
r: Resultado;
dets: array[1..tot] of Detalle;
reg_dets: array[1..tot] of regD;
ant_prov, i: Integer;

Begin
	{ Inicializacion de archivos } 
	for i:= 1 to tot do Begin
		assign(dets[i],concat('detail-adicional',IntToStr(i)));
		reset(dets[i]);
		leer(dets[i],reg_dets[i]);
	End;
	Assign(m,'master-adicional');
	Rewrite(m);
	Assign(r,'cantidad_votos-adicional');
	Rewrite(r);

	{ Actualizar maestro con corte de control por provincia }
	minimo(dets,min,reg_dets);
	while (min.codProv <> valoralto) do Begin
		ant_prov := min.codProv;
		regm.codProv := min.codProv;
		regm.totVotos := 0;
		regm.validos := 0;
		regm.anulados := 0;
		regm.blanco := 0;

		while (min.codProv = ant_prov) do Begin
			regm.totVotos := regm.totVotos + min.totVotos;
			regm.validos := regm.validos + min.validos;
			regm.anulados := regm.anulados + min.anulados;
			regm.blanco := regm.blanco + min.blanco;
			minimo(dets,min,reg_dets);
		End;
		Write(m,regm);

		{ Actualizacion de archivo resultado }
		regr.procesados := regr.procesados +1;
		regr.validos := regr.validos + regm.validos;
		regr.anulados := regr.anulados + regm.anulados;
		regr.blanco := regr.blanco + regm.blanco;
		Write(r,regr);
	End;


	{ Finalizacion del progrma }
	for i := 1 to tot do Close(dets[i]); 
	Close(m);
	Close(r);
End.
