--Cruz Zamora Joel David
--Mejia Alba Israel Hipolito
--Hernandez Najera Sandra Xochiquetzalli


--Base de datos del proyecto
Create database ProyectoBD
USE ProyectoBD


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
values('YBU-80-66',1200,'CDMX')
insert into Camion(Placa,CargaMaxima,CiudadResguardo)
values('AXA-80-66',860,'Guadalajara')
insert into Camion(Placa,CargaMaxima,CiudadResguardo)
values('YAU-80-66',1000,'Tijuana')

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