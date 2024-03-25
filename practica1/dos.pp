Uses 
  math;
Type 
  fich = text;
Var
  nomArch: String;
  x, minv, maxv: Integer;
  f: fich;
begin
  minv := 32767;
  maxv := 0;

  Write('Ingrese el nombre del archivo: ');
  ReadLn(nomArch);

  Assign(f,nomArch);
  Reset(f); { TODO: check mode }
  WriteLn('Archivo abierto correctamente.');

  while not EOF(f) do begin
    ReadLn(f, x);
    Write(x,' ');
    minv := min(minv,x);
    maxv := max(maxv,x);
  end;

  WriteLn();
  WriteLn('Minima cantidad de votos: ', minv);
  WriteLn('Maxima cantidad de votos: ', maxv);

  Close(f); { importante recordar cerrar el archivo }
End.
