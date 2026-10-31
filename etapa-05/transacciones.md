Manejo de transacciones

Descripción y objetivo.

Una transacción es un conjunto de operaciones que se ejecutan como una única unidad lógica. Si todas finalizan correctamente, se confirma mediante COMMIT; si ocurre un error, se deshacen mediante ROLLBACK. Esto ayuda a mantener la integridad de la base de datos y aplica las propiedades ACID: atomicidad, consistencia, aislamiento y durabilidad.

En el sistema veterinario, registrar una compra implica insertar la cabecera en Compra, insertar sus productos en Detalle_Compra y descontar las unidades vendidas del stock en Producto. Las tres operaciones deben completarse juntas. No sería correcto guardar una compra sin su detalle o descontar stock si la compra no pudo registrarse.

El código utiliza TRY...CATCH para capturar errores, XACT_STATE() para comprobar el estado de la transacción y ROLLBACK para deshacer los cambios ante un fallo. Los bloqueos UPDLOCK y HOLDLOCK ayudan a proteger los datos consultados durante la operación. SET XACT_ABORT ON hace que muchos errores de ejecución cancelen la transacción; el bloque CATCH se encarga de revertirla cuando corresponda.


Ventajas y aplicaciones.

El manejo de transacciones garantiza las propiedades ACID (Atomicidad, Consistencia, Aislamiento y Durabilidad), asegurando la integridad de la base de datos al tratar un conjunto de operaciones como una única unidad indivisible de trabajo. Su ventaja principal es que evita estados inconsistentes o información incompleta, ya que ante cualquier fallo se ejecuta un revertido automático (ROLLBACK) de todos los cambios. Esto resulta fundamental en operaciones complejas que involucran múltiples tablas dependientes, como el registro de una venta con actualización de stock, donde ante condiciones desfavorables o errores se cancela todo el proceso sin alterar los registros existentes.


Resultados Obtenidos.

Transacción: Registrar una compra correctamente.

<img width="418" height="50" alt="MT Registrar una compra correctamente" src="https://github.com/user-attachments/assets/70980a60-72ac-41f7-b046-976da23a754f" />

Muestra que la transacción se completó de forma exitosa (Compra registrada correctamente), asignando el código correspondiente y calculando el monto total, lo que valida el flujo normal de inserción y actualización de stock.

Prueba de error intencional después del primer INSERT.

<img width="551" height="136" alt="MT prueba error despues del primer INSERT" src="https://github.com/user-attachments/assets/45431778-64ce-4af0-ba7e-55d5c59f1394" />

Demuestra de manera impecable el funcionamiento de la atomicidad. Aunque se ejecutó un INSERT previo al error intencional (50102), el bloque CATCH ejecutó el ROLLBACK con éxito; esto se comprueba con la validación automática donde compras_antes y compras_despues coinciden (13), confirmando que no quedó ningún registro parcial y arrojando la leyenda "PRUEBA CORRECTA: no quedó el INSERT".

Transacción fallida: Stock insuficiente.

<img width="567" height="100" alt="MT Transaccion fallida stock insuf" src="https://github.com/user-attachments/assets/60cae9a0-2b7f-4aa1-806e-a6e2c3e74f6c" />

Refleja que ante una regla de negocio incumplida (stock insuficiente), el sistema capturó el error, ejecutó el ROLLBACK ("compra temporal revertida") y dejó la última consulta de comprobación completamente vacía, demostrando que la integridad de los datos se mantiene intacta.

Conclusiones de las pruebas de transacciones.

En la prueba correcta, la cabecera, el detalle y la actualización del stock se confirman como una única operación. En la prueba con error intencional, el INSERT que se había ejecutado dentro de la transacción se revierte, de modo que no queda una compra incompleta. En el caso de stock insuficiente, también se cancela la operación y no debe quedar una compra temporal ni modificarse el stock.

Estas pruebas demuestran la atomicidad de las transacciones y la utilidad de TRY...CATCH, COMMIT y ROLLBACK para conservar la consistencia de la base de datos. Los resultados reales deben comprobarse ejecutando los scripts en SQL Server y guardando las salidas obtenidas.
