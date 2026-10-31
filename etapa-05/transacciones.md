Manejo de transacciones

Descripción y objetivo.

Una transacción es un conjunto de operaciones que se ejecutan como una única unidad lógica. Si todas finalizan correctamente, se confirma mediante COMMIT; si ocurre un error, se deshacen mediante ROLLBACK. Esto ayuda a mantener la integridad de la base de datos y aplica las propiedades ACID: atomicidad, consistencia, aislamiento y durabilidad.

En el sistema veterinario, registrar una compra implica insertar la cabecera en Compra, insertar sus productos en Detalle_Compra y descontar las unidades vendidas del stock en Producto. Las tres operaciones deben completarse juntas. No sería correcto guardar una compra sin su detalle o descontar stock si la compra no pudo registrarse.

El código utiliza TRY...CATCH para capturar errores, XACT_STATE() para comprobar el estado de la transacción y ROLLBACK para deshacer los cambios ante un fallo. Los bloqueos UPDLOCK y HOLDLOCK ayudan a proteger los datos consultados durante la operación. SET XACT_ABORT ON hace que muchos errores de ejecución cancelen la transacción; el bloque CATCH se encarga de revertirla cuando corresponda.


Ventajas y aplicaciones.

El manejo de transacciones garantiza las propiedades ACID (Atomicidad, Consistencia, Aislamiento y Durabilidad), asegurando la integridad de la base de datos al tratar un conjunto de operaciones como una única unidad indivisible de trabajo. Su ventaja principal es que evita estados inconsistentes o información incompleta, ya que ante cualquier fallo se ejecuta un revertido automático (ROLLBACK) de todos los cambios. Esto resulta fundamental en operaciones complejas que involucran múltiples tablas dependientes, como el registro de una venta con actualización de stock, donde ante condiciones desfavorables o errores se cancela todo el proceso sin alterar los registros existentes.

Conclusiones de las pruebas de transacciones.

En la prueba correcta, la cabecera, el detalle y la actualización del stock se confirman como una única operación. En la prueba con error intencional, el INSERT que se había ejecutado dentro de la transacción se revierte, de modo que no queda una compra incompleta. En el caso de stock insuficiente, también se cancela la operación y no debe quedar una compra temporal ni modificarse el stock.

Estas pruebas demuestran la atomicidad de las transacciones y la utilidad de TRY...CATCH, COMMIT y ROLLBACK para conservar la consistencia de la base de datos. Los resultados reales deben comprobarse ejecutando los scripts en SQL Server y guardando las salidas obtenidas.
