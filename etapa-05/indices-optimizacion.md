Optimización de consultas mediante índices

Descripción y objetivo

Un índice es una estructura que ayuda a SQL Server a localizar registros sin tener que recorrer necesariamente toda la tabla. Resulta útil en búsquedas frecuentes, filtros por fecha y consultas por claves foráneas. Un índice puede reducir lecturas y tiempo de respuesta, aunque ocupa espacio y agrega trabajo a las operaciones de inserción, actualización y eliminación.

En este proyecto se evaluará una consulta por período sobre un millón de registros simulados. Se compararán tres escenarios: tabla sin índice creado sobre la fecha, índice agrupado (CLUSTERED) sobre la fecha e índice no agrupado con cobertura (NONCLUSTERED con INCLUDE).



Ventajas y aplicaciones.

La optimización a través de índices permite que SQL Server localice la información de forma más eficiente, funcionando de manera similar al índice de un libro para evitar tener que recorrer todas las páginas de una tabla. Sus principales ventajas son la mejora sustancial en el rendimiento de las consultas de búsqueda, la reducción de los tiempos de respuesta en tablas con grandes volúmenes de datos y la disminución de la cantidad de lecturas que realiza el motor de base de datos. Su aplicación resulta fundamental para optimizar filtros frecuentes —como fechas, códigos, clientes o productos— y facilitar la escalabilidad en sistemas con gran cantidad de información, teniendo en cuenta que, aunque consumen espacio adicional y pueden afectar levemente el rendimiento de las operaciones de modificación debido a su mantenimiento, potencian notablemente el acceso eficiente a los registros.



Resultados Obtenidos.

Insertar un millón de registros simulados.

<img width="160" height="42" alt="OI Insertar 1 millon de registros simulados" src="https://github.com/user-attachments/assets/ea0746d7-a154-4998-b081-949dfcd9d154" />

Muestra el resultado de la ejecución del script automatizado que pobló la tabla con 1.000.000 de registros, cumpliendo exactamente con el volumen requerido para la prueba de rendimiento.

Primera prueba: Consulta sin índice.

<img width="201" height="437" alt="OI Consulta sin indice 49605 filas" src="https://github.com/user-attachments/assets/bb8cfd81-7d4f-4a9c-b8b5-e6bbad0c0cc4" />

Muestra los registros obtenidos al realizar la búsqueda por período en la tabla sin indexar, base para registrar el alto costo en lecturas y el operador de Table Scan.

Segunda prueba: Índice agrupado.

<img width="200" height="400" alt="OI Indice agrupado 49605 filas" src="https://github.com/user-attachments/assets/ba0bc5f9-e470-4987-8131-d95c56600960" />

Refleja la ejecución de la misma consulta tras crear el índice agrupado sobre la fecha, permitiendo al motor cambiar la estrategia de acceso hacia un Clustered Index Seek.

Tercera prueba: Índice no agrupado con cobertura.

<img width="197" height="468" alt="OI Indice no agrupado con cobertura 49605 filas" src="https://github.com/user-attachments/assets/967e1396-cd9d-4793-ba64-da4582909281" />

Demuestra la resolución de la consulta mediante el índice con la cláusula INCLUDE, permitiendo que el motor recupere los datos de forma directa y eficiente sin consultar la tabla completa.

Registro de resultados

  <img width="1887" height="218" alt="Captura de pantalla 2026-10-31 010032" src="https://github.com/user-attachments/assets/5d3cda75-ac6d-4cee-ac66-54684f74f02e" />



Conclusiones de las pruebas de índices

La prueba permite comparar el acceso a los datos sin un índice específico sobre la fecha, con un índice agrupado y con un índice no agrupado que cubre la consulta. En general, un índice adecuado puede reducir las lecturas lógicas y el trabajo necesario para localizar un rango de fechas. Un índice de cobertura puede evitar accesos adicionales a la tabla cuando contiene todas las columnas requeridas por la consulta.

La conclusión definitiva debe basarse en las mediciones obtenidas: tiempos de CPU y transcurrido, lecturas lógicas y operadores del plan real. Los índices no mejoran todas las consultas automáticamente; también ocupan almacenamiento y deben mantenerse ante cambios en los datos. Por eso conviene crearlos de acuerdo con las consultas frecuentes del sistema y verificar su impacto antes de conservarlos.
