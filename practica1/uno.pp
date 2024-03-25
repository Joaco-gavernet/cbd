
Var
  nomArch: String;
  material: String;
  f: Text;
begin

  material := ' '; { init var }
  Write('Ingrese el nombre del archivo: ');
  ReadLn(nomArch);

  Assign(f,nomArch);
  Rewrite(f);

  WriteLn('Archivo creado.');
  while material <> 'cemento' do begin
    Write('Ingrese nombre de material ("cemento" para finalizar): ');
    ReadLn(material);
    WriteLn(f,material);
  end;

  Close(f); { importante recordar cerrar el archivo }
End.
