--Cruz Zamora Joel David
--Mejia Alba Israel Hipolito
--Hernandez Najera Sandra Xochiquetzalli


--Base de datos del proyecto
Create database ProyectoBD
USE ProyectoBD

--------------------------------------------CREACION DE TABLAS
--Tabla Paquete
CREATE TABLE Paquete (
	Codigo varchar(7) primary key
	constraint formatoCodigo check(Codigo like
	'[A-Z][A-Z][_][1-9][1-9][1-9][1-9]'),

	Direccion varchar(500) not null,

	Peso float not null
	constraint pesoValido check(Peso > 0 and Peso <= 2),

	Destinatario varchar(100) not null,
)

----Tabla Conductor
CREATE TABLE Conductor (
	RFC varchar(13) primary key
	constraint formatoRFC check(RFC like
	'[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][0-9]'),
	
	Nombre varchar(20) not null,
	Direccion varchar(20) not null,
)

--Tabla Rutas_conductor
CREATE TABLE Rutas_conductor (
	RFC varchar(13) not null,
	Ruta varchar(100) not null,

	FOREIGN KEY (RFC) REFERENCES Conductor(RFC)
		ON DELETE CASCADE ON UPDATE CASCADE,
)

--Tabla Nacional
CREATE TABLE Nacional (
	CiudadDestino varchar(50) not null,
	Codigo varchar(7) primary key,
	RFC varchar(13) not null,

	FOREIGN KEY (Codigo) REFERENCES Paquete(Codigo)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (RFC) REFERENCES Conductor(RFC)
		ON DELETE CASCADE ON UPDATE CASCADE,
)

--Tabla Rutas_nacional
CREATE TABLE Rutas_nacional (
	Codigo varchar(7) not null,
	Ruta varchar(100) not null,

	FOREIGN KEY (Codigo) REFERENCES Nacional(Codigo)
		ON DELETE CASCADE ON UPDATE CASCADE,
)

--Tabla necesaria para el Trigger "T_EnviosNacionales"
CREATE TABLE EnviosNacionales (
	IdEnvio varchar(7) primary key,
	CiudadDestino varchar(50),
	EnviosTotalesCiudad INT,

	FOREIGN KEY (IdEnvio) REFERENCES Nacional(Codigo)
		ON DELETE CASCADE ON UPDATE CASCADE,
)


----Tabla C_Local
CREATE TABLE C_Local ( 
	Nombre varchar(100) not null,
	CodigoC_Local varchar(20) primary key,
)

----Tabla Internacional
CREATE TABLE Internacional ( 
	Codigo varchar(7) primary key,

	LineaAerea varchar(50)
	constraint lineaDefault default ('Mexicana'),

	CodigoC_Local varchar(20) not null,
	FEntrega date not null,

	FOREIGN KEY (Codigo) REFERENCES Paquete(Codigo)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (CodigoC_Local) REFERENCES C_Local(CodigoC_Local)
		ON DELETE CASCADE ON UPDATE CASCADE,
)

----Tabla Camion
CREATE TABLE Camion (
	Placa varchar(20) primary key,
	CargaMaxima integer not null
	check(CargaMaxima <= 4000),
	CiudadResguardo varchar(50) check (
	CiudadResguardo in ('CDMX', 'Monterrey', 'Guadalajara', 'Merida', 'Tijuana')),
)

----Tabla Conductor_Camion
CREATE TABLE Conductor_Camion ( 
	Fecha date,
	RFC varchar(13) not null,
	Placa varchar(20) not null,
	CONSTRAINT CHK_fecha_camion CHECK (Fecha <= CAST('2020-12-10' AS date)),
	FOREIGN KEY (RFC) REFERENCES Conductor(RFC)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Placa) REFERENCES Camion(Placa)
		ON DELETE CASCADE ON UPDATE CASCADE
)





--Llenado de datos ============================================================

--Llenar los C_locales
insert into C_Local(CodigoC_Local,Nombre)
values ('CODIGOLOCAL1','Manuel Sanchez')
insert into C_Local(CodigoC_Local,Nombre)
values ('CODIGOLOCAL2','Jose Romero')
insert into C_Local(CodigoC_Local,Nombre)
values ('CODIGOLOCAL3','Francisco Rodriguez')

--Llenar tabla Conductor
insert into Conductor(RFC,Nombre,Direccion)
values('MELM8305281H0','Juan Diaz', 'Direccion de Juan')
insert into Conductor(RFC,Nombre,Direccion)
values('AKGM8305281H0','Daniel Ramos', 'Direccion de Daniel')
insert into Conductor(RFC,Nombre,Direccion)
values('LUNM8305281H0','Adrian Perez', 'Direccion de Adrian')

--Llena tabla Camion
insert into Camion(Placa,CargaMaxima,CiudadResguardo)
values('YBU-80-66',3800,'CDMX')
insert into Camion(Placa,CargaMaxima,CiudadResguardo)
values('AXA-80-66',3800,'Guadalajara')
insert into Camion(Placa,CargaMaxima,CiudadResguardo)
values('YAU-80-66',4000,'Tijuana')

--Paquetes internacionales ============================================================

--Paquete 1
insert into Paquete
values('XZ_1234','Direccion1',2,'Miguel Sanchez')
insert into Internacional(Codigo,CodigoC_Local,FEntrega)
values('XZ_1234','CODIGOLOCAL1','2020-02-22')

--Paquete 2
insert into Paquete
values('ZA_1234','Direccion2',1.3,'Jose Romero')
insert into Internacional(Codigo,CodigoC_Local,FEntrega,LineaAerea)
values('ZA_1234','CODIGOLOCAL2','2020-03-22','American Airlines')

/*--Paquete 2.3 --PRUEBA Para ver que si renstringe que un codigo no sea nacional e internacional
insert into Paquete
values('KF_1234','Direccion2',1.3,'Jose Romero')
insert into Internacional(Codigo,CodigoC_Local,FEntrega,LineaAerea)
values('KF_1234','CODIGOLOCAL2','2020-03-22','American Airlines') */

--Paquetes nacionales ================================================================

--Paquete 3
insert into Paquete(Codigo, Direccion, Peso, Destinatario)
values('KF_1234','Direccion3',1.8,'Pedro Sosa')

insert into Nacional(Codigo,CiudadDestino,RFC)
values('KF_1234','Monterrey','MELM8305281H0')

insert into Rutas_nacional(Codigo, Ruta)
values('KF_1234', 'Ruta 1')

insert into Conductor_Camion(RFC,Placa,Fecha)
values('MELM8305281H0','YBU-80-66','2020-12-10')

insert into Rutas_conductor(RFC, Ruta)
values('MELM8305281H0', 'Ruta 1')


--Paquete 4
insert into Paquete(Codigo, Direccion, Peso, Destinatario)
values('KE_1334','Direccion4',0.9,'Adrian Perez')

insert into Nacional(Codigo,CiudadDestino,RFC)
values('KE_1334','Cordoba','LUNM8305281H0')

insert into Rutas_nacional(Codigo, Ruta)
values('KE_1334', 'Ruta 2')

insert into Conductor_Camion(RFC,Placa,Fecha)
values('LUNM8305281H0','AXA-80-66','2020-12-1')

insert into Rutas_conductor(RFC, Ruta)
values('LUNM8305281H0', 'Ruta 2')


--Paquete 5
insert into Paquete(Codigo, Direccion, Peso, Destinatario)
values('DF_1226','Direccion5',2,'Daniel Ramos')

insert into Nacional(Codigo,CiudadDestino,RFC)
values('DF_1226','CDMX','AKGM8305281H0')

insert into Rutas_nacional(Codigo, Ruta)
values('DF_1226', 'Ruta 3')

insert into Conductor_Camion(RFC,Placa,Fecha)
values('AKGM8305281H0','YAU-80-66','2020-11-2') 

insert into Rutas_conductor(RFC, Ruta)
values('AKGM8305281H0', 'Ruta 3')




--------------------------------CREACION TRIGGERS
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
values('DF_1226','CDMX','AKGM8305281H0')
--Prueba para intentar meter un envio en internacional, pero su codigo ya esta en nacional
insert into Internacional(Codigo,CodigoC_Local,FEntrega,LineaAerea)
values('DF_1226','CODIGOLOCAL2','2020-03-22','American Airlines')


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
values ('YBA-80-67', 1300, 'Guadalajara')

--Tratando insertar un camion con carga maxima mayor a 1250
insert into Camion(Placa, CargaMaxima, CiudadResguardo)
values ('YBA-80-68', 1000, 'Guadalajara')






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
 
 






 ---------------------------CREACION DEL PROCEDIMIENTO ALMACENADO
 /*  Se deberá crear un procedimiento almacenado
el cual tendrá como entrada el código de algún paquete-envió.
Este procedimiento deberá mostrar lo siguiente ;

1.el Id

2.Tipo de envió(Nacional o internacional)
 
 a.	Si es nacional
	i.	Dirección
	ii. Peso
	iii.El conductor al que le fue asignado el paquete
	iv. la ruta 
	v.	las placas del camión
	vi. fecha(es la fecha entre conductor y camión)
 
 b. Si es internacional
	i.  Dirección
	ii. Línea aérea
	iii.Y el código de la compañía local.      */

go --	Creacion del procedimiento Almacenado

create procedure SP_Datos_Paquete_Envio @codigo varchar(7)
as
	if ( @codigo in (select  N.Codigo --Si es nacional
					FROM Paquete as P
					INNER JOIN Nacional AS N  
						ON ( P.Codigo = N.Codigo ) ) 
		)begin
			print'El envio es nacional';
			
			select C.Direccion, P.Peso, C.Nombre,
					R.Ruta, CC.Placa, CC.Fecha, P.Codigo s
			from Paquete as P
					inner join Nacional as N  
						on ( P.Codigo = N.Codigo )
					inner join Conductor as C --Trae los datos de su conductor
						on (C.RFC = N.RFC)
					inner join Rutas_conductor as R -- Para mostrar la ruta
						on ( R.RFC = C.RFC )
					inner join Conductor_Camion as CC
						on (C.RFC = CC.RFC)
			where N.Codigo = @codigo

		end

	
	else if ( @codigo in (select I.Codigo  --Si es Internacional
							from Paquete as P
							inner join Internacional AS I  
								ON ( P.Codigo = I.Codigo ) ) 
		)begin
			print'El envio es INTERnacional';
			select P.Direccion, I.LineaAerea, I.CodigoC_Local 
			from Paquete as P
				 inner join Internacional as I  
					on ( P.Codigo = I.Codigo )
			where I.Codigo = @codigo
		end

	else
		print'Codigo ' + @codigo + ' no es valido';


GO
--Probando el procedimiento
EXEC SP_Datos_Paquete_Envio 'ZA_1234'-- Internacional
EXEC SP_Datos_Paquete_Envio 'DF_1226' --Nacional
--'DF_1226' --Nacional  
--'KF_1234' --Nacional 
--'ZA_1234' --Internacional 
 

 
GO




--Para comparar que valores trae todos los paquetes sin importar que son nacionales o internacionales
SELECT * --Trae toda la info de los envios sean nacionales o internacionales
FROM Paquete as P
	 FULL JOIN Nacional AS N --Hacemos un full join para traer los que son nacionales y si no, esos datos los marque null
		ON ( P.Codigo = N.Codigo )
	 FULL JOIN Internacional as I
		on (I.Codigo = P.Codigo)--Hacemos un full join para traer los que son Internacionales y si no, esos datos los marque null

		
--where N.CiudadDestino is not null --Para revisar los envios que sean unicamente nacionales

where I.Codigo is not null --Para revisar los envios que sean unicamente Internacionales



  