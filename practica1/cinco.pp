Type
  tFlor = Record
    n, maxh: Integer;
    name: String;
  End;
  fich = file of tFlor;
Var
  f: fich;
  x: tFlor;
  nomArch: String;
  opc: Byte;

Procedure listarArchivo(var f: fich); 
Var x: tFlor;
begin
  Seek(f,0);
  Repeat
    Read(f, x);
    WriteLn(x.n, ' ', x.maxh, x.name);
  until EOF(f);
end;

Procedure leerTipo(var x: tFlor);
begin
  Write('Ingresar parametros en orden (numero de especie, altura maxima, nombre): ');
  ReadLn(x.n, x.maxh, x.name);
end;

Procedure agregarAlArchivo(var f: fich; x: tFlor); 
begin
  Write(f, x);
end;

begin
  Write('Ingrese el nombre del archivo: ');
  ReadLn(nomArch);
  Assign(f, nomArch);
  Reset(f);

  WriteLn('Menu de opciones: ');
  WriteLn('0) Finalizar programa. ');
  WriteLn('1) Listar contenido del archivo. ');
  WriteLn('2) Agregar contenido al archivo. ');

  Repeat
    Write('Ingrese nro. de opcion: ');
    ReadLn(opc);

    Case opc of 
      1: listarArchivo(f);
      2: begin
        leerTipo(x);
        agregarAlArchivo(f,x);
      end
    end;
  until opc = 0;

  close(f);
End.
