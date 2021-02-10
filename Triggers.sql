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



go
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
Crear otro disparador para - (envió o paquete)-nacional
Que al ingresar un nuevo envió, ingrese en otra tabla el id del envió 
y la ciudad de destino y además muestre cuantos envíos se han hecho a dicha ciudad
destino(en otras palabras que guarde en un campo en número de envíos )
Se deberá mostrar el correcto funcionamiento de los disparadores.
*/

go
create trigger T_EnviosNacionales
on Nacional 
for insert
as
	begin
	declare @tCodigo varchar(7) = (select Codigo from inserted)
	declare @tCiudadDestino varchar(50) = (select CiudadDestino from inserted)
	declare @tEnviosTotales int = (select count(*) from inserted group by CiudadDestino)
	
	insert into  EnviosNacionales( IdEnvio, CiudadDestino, EnviosTotalesCiudad)
		values (@tCodigo , @tciudadDestino, @tEnviosTotales )

	print('Se registro el Envio Nacional')
	end




--Probando el trigger
--Paquete 6 --Para corroborar el funcionamiento del trigger
insert into Paquete(Codigo, Direccion, Peso, Destinatario)
values('TR_1234','Direccion3',1.8,'Pedro Sosa')

insert into Nacional(Codigo,CiudadDestino,RFC)
values('TR_1234','Monterrey','MELM8305281H0')

insert into Rutas_nacional(Codigo, Ruta)
values('TR_1234', 'Ruta 1')

insert into Conductor_Camion(RFC,Placa,Fecha)
values('MELM8305281H0','YBU-80-66','2020-12-10')

insert into Rutas_conductor(RFC, Ruta)
values('MELM8305281H0', 'Ruta 1')

--Viendo resultados
SELECT * FROM EnviosNacionales
 
 