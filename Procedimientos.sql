/*  Se deber� crear un procedimiento almacenado
el cual tendr� como entrada el c�digo de alg�n paquete-envi�.
Este procedimiento deber� mostrar lo siguiente ;

1.el Id

2.Tipo de envi�(Nacional o internacional)
 
 a.	Si es nacional
	i.	Direcci�n
	ii. Peso
	iii.El conductor al que le fue asignado el paquete
	iv. la ruta 
	v.	las placas del cami�n
	vi. fecha(es la fecha entre conductor y cami�n)
 
 b. Si es internacional
	i.  Direcci�n
	ii. L�nea a�rea
	iii.Y el c�digo de la compa��a local.      */

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



  