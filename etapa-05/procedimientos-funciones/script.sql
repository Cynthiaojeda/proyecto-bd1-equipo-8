
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-----------------------------------
--registra una nueva compra vacia--
-----------------------------------
CREATE PROCEDURE dbo.CrearCompra
	@IdCompra INT,
	@Fecha DATE,
	@DniCliente INT,
AS
/**/
BEGIN
	SET NOCOUNT ON
	--si no existe una compra con ese ID y
	--si el usuario existe
	IF @IdCompra NOT IN (SELECT id_compra FROM Compra) AND
		@DniCliente IN (SELECT DNI FROM Cliente)
		--creamos un nuevo registro vacio de venta
		INSERT INTO dbo.Compra
		VALUES
			(@IdCompra,
			@Fecha,
			'minorista',
			0,
			@DniCliente);
END
GO

---------------------------------------------------------------------
--agrega una compra unitaria (Detalle_Compra) a una compra (Compra)--
---------------------------------------------------------------------
CREATE PROCEDURE dbo.AgregarVentaUnitaria
	@IdCompra INT,
	@CodigoProducto INT,
	@Cantidad INT
AS
/**/
BEGIN
	SET NOCOUNT ON
	DECLARE @PrecioUnitario DECIMAL(10, 2) = (
		SELECT precio FROM Producto
		WHERE cod_producto = @CodigoProducto
	)
	DECLARE @Stock INT = (
		SELECT stock FROM Producto WHERE cod_producto = @CodigoProducto
	)

	--hay stock existente
	-- y el producto es valido
	IF (@Stock > 0 AND
		@CodigoProducto IN (SELECT cod_producto FROM Producto))
		--Primero registramos el nuevo detalle de compra
		INSERT INTO dbo.Detalle_Compra
		VALUES
			(@IdCompra, @CodigoProducto, @Cantidad, @PrecioUnitario);

		--Actualizamos la Compra asociada (monto)
		UPDATE Compra
		SET monto_total = monto_total + @PrecioUnitario
		WHERE id_compra = @IdCompra;

		--Modificamos stock
		UPDATE Producto
		SET stock = stock - 1
		WHERE cod_producto = @CodigoProducto;
END
GO


----------------------------------
------------- PRUEBAS-------------
----------------------------------

--devuelve una tabla vacia
SELECT * FROM Compra
WHERE id_compra = 90;

--creamos la compra
EXEC dbo.CrearCompra
	90,
	'2024-09-10',
	30333444,
	'Efectivo';

--ahora devuelve la tabla de compra
--con id 90
SELECT * FROM Compra
WHERE id_compra = 90;

--no existen detalles de compra con id 90 aun
SELECT * FROM Detalle_Compra
WHERE id_compra = 90;

--agregamos elementos a la compra
EXEC dbo.AgregarVentaUnitaria
	90,
	2,
	1

--ahora solo existe un detalle asociado a
--la compra con id 90
SELECT * FROM Detalle_Compra
WHERE id_compra = 90;

--AgregarVentaUnitaria modifico el monto de compra
SELECT monto_total FROM Compra
WHERE Compra = 90;

--limpiar datos de prueba

/*
DELETE FROM Factura_Compra
WHERE id_compra = 90;

DELETE FROM Detalle_Compra
WHERE id_compra = 90;

DELETE FROM Compra
WHERE id_compra = 90;
*/
