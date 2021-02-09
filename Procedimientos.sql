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
--create
alter procedure SP_Datos_Paquete_Envio @codigo varchar(7)
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
					inner join Rutas as R -- Para mostrar la ruta
						on ( R.IdRuta = N.IdRuta )
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



--Probando el procedimiento
EXEC SP_Datos_Paquete_Envio 'ZA_1234'
--'DF_1226' --Nacional --Repetido
--'FF_1234' --Nacional 
--'ZA_1234' --Internacional

--where N.CiudadDestino is not null ) )
 
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



 /*6.Crear un SP que muestre todo sobre un producto que 
busque un cliente
Nota: el cliente puede ingresar parte del nombre del producto, 
en otras palabra mostrar todo lo que coincida con lo ingresado
por el cliente.
EXEC SP_ListarProducto(NombreProducto)*/
go
CREATE PROCEDURE SP_ListarProducto @NombreProducto VARCHAR(20)
AS
 SELECT * FROM Products P
 WHERE P.ProductName LIKE CONCAT('%',@NombreProducto,'%')


  

 EXEC SP_ListarProducto 'queso'
 
 SELECT * FROM Products


 delete  
 from Paquete 
 where Codigo ='DF_1226' --'KF_1234'