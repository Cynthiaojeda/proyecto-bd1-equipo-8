# Procedimientos 

El uso de procedimientos se asocia con la reutilizacion de codigo y mayor seguridad a la hora de realizar cambios en la base de datos, ya que no es necesario interactuar directamente con esta gracias a que los procedimientos (siempre y cuando esten bien implementados) abstraen informacion del usuario.

# Caso de estudio
En nuestro caso utilizamos tres procedimientos

* CrearCompra: Crea una nueva fila de compras vacia
* AgregarVentaUnitaria: Crea un nuevo detalle de venta y realiza los cambios
necesarios en la tabla de compra

Estos procedimientos nos permiten abastrear estas operaciones y encadenarlas logicamente.
Ejemplo:

### argumentos: id_compra, fecha, dni_cliente, tipo_pago
dbo.CrearCompra(90, '2024-09-10', 44090120, 'Efectivo');
### argumentos: id_compra, id_producto, cantidad
dbo.AgregarVentaUnitaria(90, 5, 1);
dbo.AgregarVentaUnitaria(90, 4, 2);
dbo.AgregarVentaUnitaria(90, 1, 4);

Notese que valores invalidos No modifican la base de datos, sease para que AgregarVentaUnitaria funcione, debe exister id compra 90 y un id producto 5. Para crear la compra el DNI del usuario tambien debe existir.
