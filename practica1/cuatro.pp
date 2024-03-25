Type fich = file of Char;
Var
  archOrigen, archDestino: String;
  o: fich;
  d: text;

Procedure convert (var o: fich);
Var x: Char;
begin
  Write('Ingrese el nombre del archivo destino: ');
  ReadLn(archDestino);
  Assign(d,archDestino);
  Rewrite(d);

  WriteLn('Archivos abiertos correctamente.');
  WriteLn('Convirtiendo archivo a tipo texto...');

  while not EOF(o) do begin 
    Read(o,x);
    Write(x);
    Write(d,x);
  end;
end;

begin
  Write('Ingrese el nombre del archivo origen: ');
  ReadLn(archOrigen);
  Assign(o,archOrigen);
  Reset(o);
  convert(o);

  Close(o); 
  Close(d);
End.
