Var
  nomArch: String;
  tipo: String;
  f: text;
begin

  Write('Ingrese el nombre del archivo: ');
  ReadLn(nomArch);

  Assign(f,nomArch);
  Rewrite(f); { TODO: check mode }
  WriteLn('Archivo abierto correctamente.');

  repeat
    Write('Ingresar tipo de dinosaurio (zzz para finalizar): ');
    ReadLn(tipo);
    if tipo <> 'zzz' then WriteLn(f,tipo);
  until tipo = 'zzz';

  Close(f); { importante recordar cerrar el archivo }
End.
