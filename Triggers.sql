/*
(garantizar que un paquete o envió solo pueda ser de un solo tipo Nacional o Internacional
pero no ambos).
*/ 
GO
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
GO



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


--Prueba para intentar meter un envio en nacional, pero su codigo ya esta en internacional
insert into Nacional(Codigo,CiudadDestino,RFC)
values('ZA_1234','CDMX','AKGM8305281H0')
--Prueba para intentar meter un envio en internacional, pero su codigo ya esta en nacional
insert into Internacional(Codigo,CodigoC_Local,FEntrega,LineaAerea)
values('DF_1226','CODIGOLOCAL2','2020-03-22','American Airlines')

select * from Nacional
select *from EnviosNacionales
/*


Crear otro Disparador para la tabla(entidad)
- Camión
Que no permita dar de alta camiones con cargas menores a 250 kg o mayores a 1250 kg
Deberá mandar un mensaje de la razón por la cual no se pudo ingresar camiones que no
cumplan con lo establecido 
*/
GO
CREATE TRIGGER CheckCamiones
ON Camion
FOR INSERT
AS
   DECLARE @CargaCamion int
   SET @CargaCamion = (SELECT CargaMaxima FROM inserted)

   IF (@CargaCamion BETWEEN 250 AND 1250)
        PRINT('El camión fue dado de alta en la base de datos')
   ELSE
   BEGIN
     PRINT('El camión no puede ser dado de alta porque su carga no esta entre 250[KG] Y 1250[KG]')
	 ROLLBACK TRANSACTION
END

--Tratando insertar un camion con carga maxima menor a 250
insert into Camion(Placa, CargaMaxima, CiudadResguardo)
values ('YBA-80-66', 249, 'Guadalajara')
--Tratando insertar un camion con carga maxima mayor a 1250
insert into Camion(Placa, CargaMaxima, CiudadResguardo)
values ('YBA-80-67', 1100, 'Guadalajara')


Select * from Nacional
Select * from EnviosNacionales


/*
Crear otro disparador para - (envió o paquete)-nacional
Que al ingresar un nuevo envió, ingrese en otra tabla el id del envió 
y la ciudad de destino y además muestre cuantos envíos se han hecho a dicha ciudad
destino(en otras palabras que guarde en un campo en número de envíos )
Se deberá mostrar el correcto funcionamiento de los disparadores.
*/
 
go
create  trigger T_EnviosNacionales
on Nacional 
for insert
as
	begin
	declare @tCodigo varchar(7) = (select Codigo from inserted)								-- Se toma el codigo del paquete nacional que vamos a ocupar
	declare @tCiudadDestino varchar(50) = (select CiudadDestino from inserted)				--Se toma la ciudad del paquete insertado
	declare @tEnviosTotales int = (select count(*) from Nacional
									where CiudadDestino = @tCiudadDestino )			--Se cuentan cuantos envios se han registrado en esa ciudad y se lo asignamos a @tEnviosTotales
	
	--insertamos los valores obtenidos en el trigger a la tabla Envios nacionales
	insert into  EnviosNacionales( IdEnvio, CiudadDestino, EnviosTotalesCiudad)
		values (@tCodigo , @tciudadDestino, @tEnviosTotales )
		
	
	--Actualizamos los envios totales que hay en esa ciudad en todos los registros
	update  EnviosNacionales 
	set EnviosTotalesCiudad = @tEnviosTotales
	WHERE CiudadDestino =  @tCiudadDestino

	print('Se registro el Envio Nacional')
	end
<<<<<<< HEAD
	 

=======

select * from Nacional
select * from Paquete
>>>>>>> e9315e3f1797c87de9a27e360d65895a59feb96f

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

--Probando el trigger
--Paquete 7 --Para corroborar el funcionamiento del trigger
insert into Paquete(Codigo, Direccion, Peso, Destinatario)
values('TR_2234','Direccion3',1.8,'Pedro Sosa')

insert into Nacional(Codigo,CiudadDestino,RFC)
values('TR_2234','Monterrey','MELM8305281H0')

insert into Rutas_nacional(Codigo, Ruta)
values('TR_2234', 'Ruta 1')

insert into Conductor_Camion(RFC,Placa,Fecha)
values('MELM8305281H0','YBU-80-66','2020-12-10')

insert into Rutas_conductor(RFC, Ruta)
values('MELM8305281H0', 'Ruta 1')

--Probando el trigger
--Paquete 8 --Para corroborar el funcionamiento del trigger
insert into Paquete(Codigo, Direccion, Peso, Destinatario)
values('TR_2238','Direccion3',1.8,'Pedro Sosa')

insert into Nacional(Codigo,CiudadDestino,RFC)
values('TR_2238','Monterrey','MELM8305281H0')

insert into Rutas_nacional(Codigo, Ruta)
values('TR_2238', 'Ruta 1')

insert into Conductor_Camion(RFC,Placa,Fecha)
values('MELM8305281H0','YBU-80-66','2020-12-10')

insert into Rutas_conductor(RFC, Ruta)
values('MELM8305281H0', 'Ruta 1')


--Viendo resultados 
SELECT * FROM EnviosNacionales
 
 