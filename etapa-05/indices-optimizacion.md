Optimización de consultas mediante índices
1. Descripción y objetivo
Un índice es una estructura que ayuda a SQL Server a localizar registros sin tener que recorrer necesariamente toda la tabla. Resulta útil en búsquedas frecuentes, filtros por fecha y consultas por claves foráneas. Un índice puede reducir lecturas y tiempo de respuesta, aunque ocupa espacio y agrega trabajo a las operaciones de inserción, actualización y eliminación.

En este proyecto se evaluará una consulta por período sobre un millón de registros simulados. Se compararán tres escenarios: tabla sin índice creado sobre la fecha, índice agrupado (CLUSTERED) sobre la fecha e índice no agrupado con cobertura (NONCLUSTERED con INCLUDE).

2. Ventajas y aplicaciones.
La optimización a través de índices permite que SQL Server localice la información de forma más eficiente, funcionando de manera similar al índice de un libro para evitar tener que recorrer todas las páginas de una tabla. Sus principales ventajas son la mejora sustancial en el rendimiento de las consultas de búsqueda, la reducción de los tiempos de respuesta en tablas con grandes volúmenes de datos y la disminución de la cantidad de lecturas que realiza el motor de base de datos. Su aplicación resulta fundamental para optimizar filtros frecuentes —como fechas, códigos, clientes o productos— y facilitar la escalabilidad en sistemas con gran cantidad de información, teniendo en cuenta que, aunque consumen espacio adicional y pueden afectar levemente el rendimiento de las operaciones de modificación debido a su mantenimiento, potencian notablemente el acceso eficiente a los registros.

3. Crear la tabla auxiliar y cargar un millón de registros
La tabla CompraHistoricaPrueba se usa exclusivamente para medir el rendimiento y no modifica las compras reales. El script la elimina si ya existe y la vuelve a crear. Las fechas y los importes son datos simulados.


USE Veterinaria_Proyecto_Integrador_Grupo8;
GO

IF OBJECT_ID('dbo.CompraHistoricaPrueba', 'U') IS NOT NULL
    DROP TABLE dbo.CompraHistoricaPrueba;
GO

CREATE TABLE dbo.CompraHistoricaPrueba (
    id_compra BIGINT IDENTITY(1,1) NOT NULL,
    fecha DATE NOT NULL,
    monto_total DECIMAL(12,2) NOT NULL
);
GO

SET NOCOUNT ON;
GO

;WITH Numeros AS (
    SELECT TOP (1000000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects AS a
    CROSS JOIN sys.all_objects AS b
    CROSS JOIN sys.all_objects AS c
)
INSERT INTO dbo.CompraHistoricaPrueba (fecha, monto_total)
SELECT
    DATEADD(
        DAY,
        CONVERT(INT, CHECKSUM(NEWID()) & 2147483647) % 1825,
        CONVERT(DATE, '20200101')
    ),
    CONVERT(
        DECIMAL(12,2),
        (CONVERT(BIGINT, CHECKSUM(NEWID()) & 2147483647) % 1000000) / 100.0
    )
FROM Numeros;
GO

SELECT COUNT(*) AS cantidad_registros
FROM dbo.CompraHistoricaPrueba;
GO


La consulta de verificación debe devolver 1000000. La tabla no tiene un índice creado explícitamente sobre fecha. SQL Server puede usar un recorrido de tabla (Table Scan) cuando no existe un índice útil; el operador exacto depende de la estructura y del plan elegido por el optimizador.


4. Escenario 1: consulta sin índice sobre la fecha
En SQL Server Management Studio (SSMS), activar Incluir plan de ejecución real desde el menú Consulta o con Ctrl+M. Luego ejecutar:

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT fecha, monto_total
FROM dbo.CompraHistoricaPrueba
WHERE fecha BETWEEN '20230101' AND '20230331';
GO

5. Escenario 2: índice agrupado sobre la fecha
Crear el índice agrupado sobre la columna utilizada en el filtro y repetir la misma consulta:

CREATE CLUSTERED INDEX IX_CompraHistoricaPrueba_Fecha
ON dbo.CompraHistoricaPrueba(fecha);
GO

SELECT fecha, monto_total
FROM dbo.CompraHistoricaPrueba
WHERE fecha BETWEEN '20230101' AND '20230331';
GO


6. Eliminar el índice agrupado y crear un índice con cobertura
Eliminar el índice agrupado creado en el escenario anterior y crear un índice no agrupado cuya clave sea fecha y que incluya monto_total. Así, las dos columnas seleccionadas están disponibles en el propio índice y la consulta puede resolverse sin buscar las filas completas de la tabla.

DROP INDEX IX_CompraHistoricaPrueba_Fecha
ON dbo.CompraHistoricaPrueba;
GO

CREATE NONCLUSTERED INDEX IX_CompraHistoricaPrueba_Fecha_Cobertura
ON dbo.CompraHistoricaPrueba(fecha)
INCLUDE (monto_total);
GO

SELECT fecha, monto_total
FROM dbo.CompraHistoricaPrueba
WHERE fecha BETWEEN '20230101' AND '20230331';
GO

7. Registro de resultados

   Escenario	           Tiempo de CPU	    Tiempo Total	    Lecturas Lógicas	    Operación Principal
   Sin índice	              2,719ms	          2,995ms	          1,003,584		           Table Scan
Índice sobre fecha		      140ms		          305ms	              3,585		          Clustered Index Seek
Índice con cobertura		    32ms	            274ms	               165		             Index Seek


8. Índices adicionales para las tablas reales del proyecto
Además de la prueba masiva, se proponen índices no agrupados sobre columnas usadas para relacionar o filtrar registros. Estos índices son complementarios y no reemplazan los índices que ya crean las claves primarias y restricciones UNIQUE.

-- Buscar mascotas por cliente.
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Mascota_dni_cliente'
      AND object_id = OBJECT_ID('dbo.Mascota')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Mascota_dni_cliente
    ON dbo.Mascota(dni_cliente);
END;
GO

-- Buscar mascotas por atención.
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Mascota_id_atencion'
      AND object_id = OBJECT_ID('dbo.Mascota')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Mascota_id_atencion
    ON dbo.Mascota(id_atencion);
END;
GO

-- Buscar turnos por mascota.
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Turno_id_mascota'
      AND object_id = OBJECT_ID('dbo.Turno')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Turno_id_mascota
    ON dbo.Turno(id_mascota);
END;
GO

-- Consultar compras de un cliente por fecha.
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Compra_dni_cliente_fecha'
      AND object_id = OBJECT_ID('dbo.Compra')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Compra_dni_cliente_fecha
    ON dbo.Compra(dni_cliente, fecha)
    INCLUDE (monto_total, tipo_cliente);
END;
GO

-- Buscar detalles de compra por producto.
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Detalle_Compra_codigo_producto'
      AND object_id = OBJECT_ID('dbo.Detalle_Compra')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Detalle_Compra_codigo_producto
    ON dbo.Detalle_Compra(codigo_producto)
    INCLUDE (codigo_compra, cantidad, precio_unitario);
END;
GO

Se pueden comprobar con estas consultas:

-- Mascotas pertenecientes a un cliente.
SELECT *
FROM dbo.Mascota
WHERE dni_cliente = 30111222;

-- Turnos asociados a una mascota.
SELECT *
FROM dbo.Turno
WHERE id_mascota = 1;

-- Compras de un cliente ordenadas por fecha.
SELECT codigo_compra, fecha, monto_total, tipo_cliente
FROM dbo.Compra
WHERE dni_cliente = 30111222
ORDER BY fecha;

-- Detalles que contienen un producto.
SELECT codigo_compra, codigo_producto, cantidad, precio_unitario
FROM dbo.Detalle_Compra
WHERE codigo_producto = 1;
GO

En una base con pocos registros, como los diez ejemplos iniciales del proyecto, el optimizador puede preferir un recorrido de tabla porque su costo es bajo. La mejora de los índices se evalúa con más claridad cuando las tablas tienen un volumen de datos significativo y las consultas son representativas del uso real.


9. Conclusiones de las pruebas de índices
La prueba permite comparar el acceso a los datos sin un índice específico sobre la fecha, con un índice agrupado y con un índice no agrupado que cubre la consulta. En general, un índice adecuado puede reducir las lecturas lógicas y el trabajo necesario para localizar un rango de fechas. Un índice de cobertura puede evitar accesos adicionales a la tabla cuando contiene todas las columnas requeridas por la consulta.

La conclusión definitiva debe basarse en las mediciones obtenidas: tiempos de CPU y transcurrido, lecturas lógicas y operadores del plan real. Los índices no mejoran todas las consultas automáticamente; también ocupan almacenamiento y deben mantenerse ante cambios en los datos. Por eso conviene crearlos de acuerdo con las consultas frecuentes del sistema y verificar su impacto antes de conservarlos.
