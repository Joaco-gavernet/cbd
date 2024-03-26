
Type
Licencia = Record
	cod, dias: Integer;
	fecha: String;
End;

Database = Record
	cod, diasDisponibles: Integer;
	apellido: String;
End;

Falla = Record
	cod, diasDisponibles, diasSolicitados: Integer;
	apellido: String;
End;

Maestro = file of Database;
Detalle = file of Licencia;
Errores = file of Falla;

Var
m: Maestro;
d: Detalle;
e: Errores;

Procedure actualizarMaestro(var m: Maestro; var d: Detalle; var e: Errores);
Var
	regd: Licencia;
	regm: Database;
	rege: Falla;
Begin
	Seek(m,0);
	Seek(d,0);

	while (not EOF(d)) do Begin
		read(m,regm);
		read(d,regd);
		while (regm.cod <> regd.cod) do
			read(m,regm);
		if (regd.dias > regm.diasDisponibles) then Begin
			rege.apellido := regm.apellido;
			rege.cod := regd.cod;
			rege.diasDisponibles := regm.diasDisponibles;
			rege.diasSolicitados := regd.dias;
			Seek(e, fileSize(e) -1);
			Write(e,rege);
		End
		else Begin
			regm.diasDisponibles := regm.diasDisponibles - regd.dias;
			Seek(m, filePos(m) -1);
			Write(m,regm);
		End;
	End;
End;

Begin
	Assign(m, 'master');
	Assign(d, 'detail');
	Assign(e, 'error');
	Reset(m);
	Reset(d);
	Reset(e);

	actualizarMaestro(m,d,e);

	Close(m);
	Close(d);
	Close(e);
End.
