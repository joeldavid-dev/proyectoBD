--Cruz Zamora Joel David
--Mejía Alba Israel Hipólito
--Hernández Nájera Sandra Xochiquetzalli


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

--Tabla Rutas
CREATE TABLE Rutas (
	IdRuta integer primary key,
	Ruta varchar(100) not null,
)

----Tabla Conductor
CREATE TABLE Conductor (
	RFC varchar(13) primary key
	constraint formatoRFC check(RFC like
	'[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][0-9]'),
	
	Nombre varchar(20) not null,
	Direccion varchar(20) not null,
	IdRuta integer not null,

	FOREIGN KEY (IdRuta) REFERENCES Rutas(IdRuta)
	ON DELETE NO ACTION ON UPDATE CASCADE
)

--Tabla Nacional
CREATE TABLE Nacional (
	CiudadDestino varchar(50) not null,
	Codigo varchar(7) primary key,
	IdRuta int not null,
	RFC varchar(13) not null,

	FOREIGN KEY (Codigo) REFERENCES Paquete(Codigo)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (IdRuta) REFERENCES Rutas(IdRuta)
		ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (RFC) REFERENCES Conductor(RFC)
		ON DELETE CASCADE ON UPDATE NO ACTION, --Quedo sin accion porque marca error
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
	Fecha datetime,
	RFC varchar(13) not null,
	Placa varchar(20) not null,
	FOREIGN KEY (RFC) REFERENCES Conductor(RFC)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Placa) REFERENCES Camion(Placa)
		ON DELETE CASCADE ON UPDATE CASCADE
)



--Llenado de datos ----------------------------------------------

--Llenar las rutas. Deben ser 4
insert into Rutas values(1,'Ruta 1')
insert into Rutas values(2,'Ruta 2')
insert into Rutas values(3,'Ruta 3')
insert into Rutas values(4,'Ruta 4')

--Llenar los C_locales
insert into C_Local(CodigoC_Local,Nombre)
values ('CODIGOLOCAL1','Manuel Sanchez')
insert into C_Local(CodigoC_Local,Nombre)
values ('CODIGOLOCAL2','Jose Romero')
insert into C_Local(CodigoC_Local,Nombre)
values ('CODIGOLOCAL3','Francisco Rodriguez')
select * from Rutas

--Paquetes internacionales -------------------------------------

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

--Paquetes nacionales

--Paquete 3
insert into Paquete
values('KF_1234','Direccion3',1.8,'Pedro Sosa')
insert into Conductor(RFC,Nombre,Direccion,IdRuta)
values('MELM8305281H0','Juan Diaz', 'Direccion de Juan',1)
insert into Nacional(Codigo,CiudadDestino,IdRuta,RFC)
values('KF_1234','Monterrey',1,'MELM8305281H0')
insert into Camion(Placa,CargaMaxima,CiudadResguardo)
values('YBU-80-66',3800,'CDMX')
insert into Conductor_Camion(RFC,Placa,Fecha)
values('MELM8305281H0','YBU-80-66','2020-12-10')

--Paquete 4
insert into Paquete
values('KE_1334','Direccion4',0.9,'Adrian Perez')
insert into Conductor(RFC,Nombre,Direccion,IdRuta)
values('LUNM8305281H0','Adrian Perez', 'Direccion de Adrian',3)
insert into Nacional(Codigo,CiudadDestino,IdRuta,RFC)
values('KE_1334','Cordoba',3,'LUNM8305281H0')
insert into Camion(Placa,CargaMaxima,CiudadResguardo)
values('AXA-80-66',3800,'Guadalajara')
insert into Conductor_Camion(RFC,Placa,Fecha)
values('LUNM8305281H0','AXA-80-66','2020-12-15')

--Paquete 5
insert into Paquete
values('DF_1226','Direccion5',2,'Daniel Ramos')
insert into Conductor(RFC,Nombre,Direccion,IdRuta)
values('AKGM8305281H0','Daniel Ramos', 'Direccion de Daniel',2)
insert into Nacional(Codigo,CiudadDestino,IdRuta,RFC)
values('DF_1226','CDMX',2,'AKGM8305281H0')
insert into Camion(Placa,CargaMaxima,CiudadResguardo)
values('YAU-80-66',4000,'Tijuana')
insert into Conductor_Camion(RFC,Placa,Fecha)
values('AKGM8305281H0','YAU-80-66','2020-12-2') 
) 