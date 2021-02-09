/*
(garantizar que un paquete o envió solo pueda ser de un solo tipo Nacional o Internacional
pero no ambos).
*/ 

create trigger verificarPaqueteNacional
on Nacional
for insert
as
	declare @nCodigo varchar(7) = (select Codigo from inserted)
	declare @coincidencias int = (select count(*) from Internacional where Codigo = @nCodigo)
	if @coincidencias > 0
	begin
		print('Ya existe un paquete internacional con el mismo codigo')
		rollback transaction
	end

create trigger verificarPaqueteInternacional
on Internacional
for insert
as
	declare @nCodigo varchar(7) = (select Codigo from inserted)
	declare @coincidencias int = (select count(*) from Nacional where Codigo = @nCodigo)
	if @coincidencias > 0
	begin
		print('Ya existe un paquete nacional con el mismo codigo')
		rollback transaction
	end


/*
Crear otro Disparador para la tabla(entidad)
- Camión
Que no permita dar de alta camiones con cargas menores a 250 kg o mayores a 1250 kg
Deberá mandar un mensaje de la razón por la cual no se pudo ingresar camiones que no
cumplan con lo establecido
*/

/*
Crear otro disparador para
- (envió o paquete)-nacional
Que al ingresar un nuevo envió, ingrese en otra tabla el id del envió y la ciudad de destino
y además muestre cuantos envíos se han hecho a dicha ciudad destino(en otras palabras
que guarde en un campo en número de envíos )
Se deberá mostrar el correcto funcionamiento de los disparadores.
*/