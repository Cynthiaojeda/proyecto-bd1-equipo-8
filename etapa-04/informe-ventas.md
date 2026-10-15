/* ==========================================
    REPORTE AGREGADO
     VENTAS POR CATEGORIA DE PRODUCTO
    (01/09/2026 AL 30/09/2026)
   ========================================== */
SELECT
    PR.tipo_producto AS Categoria,
    COUNT(DISTINCT C.nro_compra) AS Cantidad_Compras,
    SUM(DC.cantidad) AS Unidades_Vendidas,
    CAST(SUM(DC.cantidad * DC.precio_unitario) AS DECIMAL(12,2))
        AS Total_Vendido

FROM Compra C
INNER JOIN Detalle_Compra DC
    ON C.nro_compra = DC.nro_compra
INNER JOIN Producto PR
    ON DC.cod_producto = PR.cod_producto

WHERE C.fecha BETWEEN '2026-09-01' AND '2026-09-30'

GROUP BY PR.tipo_producto

ORDER BY Total_Vendido DESC;
GO


/* ==========================================
   PRUEBA: COMPARACION DE TOTALES
   ========================================== */
SELECT
    SUM(DC.cantidad * DC.precio_unitario) AS Total_Segun_Detalle
FROM Compra C
INNER JOIN Detalle_Compra DC
    ON C.nro_compra = DC.nro_compra
WHERE C.fecha BETWEEN '2026-09-01' AND '2026-09-30';

SELECT
    SUM(monto_total) AS Total_Segun_Compra
FROM Compra
WHERE fecha BETWEEN '2026-09-01' AND '2026-09-30';
GO
