Decisiones de diseño

Durante esta etapa fuimos realizando cambios en el modelo a medida que avanzamos desde el modelo de negocio al DER y luego al modelo conceptual.

Uno de los principales cambios fue en la relación entre los clientes y las compras. En el modelo anterior se podía interpretar que un cliente solamente podía realizar una compra, lo cual era una limitación. Se modificó el modelo para que un cliente pueda realizar varias compras y que cada compra quede asociada al cliente correspondiente.
También se definió que cada recibo puede contener varios productos. Para representar esto se agregó RegistroCompra, donde se puede guardar el producto comprado, la cantidad y el precio correspondiente. De esta forma, un mismo cliente puede tener varios recibos y cada recibo puede tener varios productos.

Cambios en el modelo conceptual

Al realizar el modelo conceptual se organizaron las entidades y relaciones que forman parte del sistema.
Se mantuvieron entidades como Cliente, Producto, Proveedor, Mascota, Turno y Persona. También se incorporó la generalización de Persona, de la cual se desprenden Cliente, Administrador y Profesional.
Se revisaron las relaciones y cardinalidades para representar mejor las reglas del negocio. Por ejemplo, un cliente puede tener varias mascotas y puede realizar varias compras. Una mascota puede tener varios turnos y los turnos se relacionan con un profesional.
En el caso de los productos, se definió la relación con los proveedores y se agregó RegistroCompra para representar los productos incluidos en cada recibo.

Por último, queda realizar la normalización hasta 3FN, donde vamos a revisar y organizar las tablas para evitar datos repetidos y que la información quede bien relacionada.
