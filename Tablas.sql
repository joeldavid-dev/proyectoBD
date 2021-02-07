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