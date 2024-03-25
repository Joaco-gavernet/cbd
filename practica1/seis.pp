Type
  tLibro = Record
    isbn, titulo, editorial, genero: String;
    edicion: Integer;
  End;
  fich = file of tLibro;
Var
  o: Text;
  d: fich;
  x: tLibro;
  origen, destino, id: String;
  opc: Byte;

Procedure listarArchivo(var f: fich); 
Var x: tLibro;
begin
  WriteLn();
  WriteLn('Contenido del archivo: ');
  Reset(f);
  Repeat
    Read(f, x);

    WriteLn(x.isbn);
    WriteLn(x.titulo);
    WriteLn(x.edicion, x.editorial);
    WriteLn(x.genero);
  until EOF(f);
  WriteLn();
end;

Procedure leerTipo(var x: tLibro);
begin
  Write('Ingrese el ISBN: '); 
  ReadLn(x.isbn);
  Write('Ingrese el titulo: ');
  ReadLn(x.titulo);
  Write('Ingrese anio de edicion y editorial: ');
  ReadLn(x.edicion, x.editorial);
  Write('Ingrese genero: ');
  ReadLn(x.genero);
end;

Procedure agregarAlArchivo(var f: fich; x: tLibro); 
begin
  Write(f,x);
end;

Procedure copiarTextoABinario(var o: Text; var d: fich);
Var x: tLibro;
begin
  Reset(o);
  while not EOF(o) do begin
    ReadLn(o, x.isbn);
    ReadLn(o, x.titulo);
    ReadLn(o, x.edicion, x.editorial);
    ReadLn(o, x.genero);

    AgregarAlArchivo(d,x);
  end;
end;

Procedure modificar(var f: fich; x: tLibro; id: String);
Var act: tLibro;
begin
  Reset(f);
  while not EOF(f) do begin
    Read(f,act);
    if (act.isbn = id) then begin
      Seek(f, FilePos(f) -1);
      Write(f,x);
    end;
  end;
end;

begin
  Write('Ingrese el nombre del archivo origen (Text): ');
  ReadLn(origen);
  Assign(o, origen);
  Reset(o);

  Write('Ingrese el nombre del archivo destino (binario): ');
  ReadLn(destino);
  Assign(d, destino);
  Rewrite(d);

  WriteLn('Copiando archivo binario desde el archivo de texto (.txt).');
  copiarTextoABinario(o,d);

  WriteLn('Menu de opciones: ');
  WriteLn('0) Finalizar programa. ');
  WriteLn('1) Listar contenido del archivo binario. ');
  WriteLn('2) Agregar un libro. ');
  WriteLn('3) Modificar un libro existente. ');

  Repeat
    Write('Ingrese nro. de opcion: ');
    ReadLn(opc);

    if opc = 1 then listarArchivo(d);
    if opc = 2 then begin
      leerTipo(x);
      agregarAlArchivo(d,x);
    end;
    if opc = 3 then begin
      Write('Ingrese ISBN del libro a modificar: ');
      Read(id);
      WriteLn('Actualizando datos. ');
      leerTipo(x);
      modificar(d, x, id);
    end;
  until opc = 0;

  close(o); close(d);
End.
