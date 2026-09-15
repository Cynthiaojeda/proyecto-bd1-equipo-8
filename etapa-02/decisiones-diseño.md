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

(14/092026)

Modificaciones realizadas al diagrama lógico

A partir del análisis del desarrollo del tema de la veterinaria, se realizaron diferentes modificaciones al diagrama lógico inicial con el objetivo de representar correctamente la información que debe manejar el sistema. En primer lugar, se revisó el modelo teniendo en cuenta las reglas de negocio establecidas, donde se decidió mantener el DNI como identificador único del cliente, ya que permite identificarlo de manera clara y evitar agregar otro identificador que no necesitamos para el modelo, además se modificó la entidad MASCOTA, ya que inicialmente solamente contenía el identificador de la mascota, su nombre y su raza. De acuerdo con el desarrollo del tema, de cada mascota se debe conocer también la especie, el sexo y la edad, por lo que se incorporaron estos atributos. Además, se eliminó el atributo Mascota que se encontraba dentro de CLIENTE, debido a que un cliente puede tener varias mascotas y, por lo tanto, no corresponde almacenar una mascota como un atributo del cliente. En su lugar, se estableció la relación entre CLIENTE y MASCOTA, incorporando el atributo DNI como clave foránea en MASCOTA para identificar al cliente al que pertenece.

También se modificó la parte correspondiente a las atenciones veterinarias. En el diagrama inicial, la información relacionada con los turnos y las atenciones no estaba representada de manera completa. Por este motivo, se incorporó la entidad ATENCION, donde se almacenan el identificador de la atención, la mascota a la que corresponde, la fecha de ingreso, la fecha de salida, el tipo de atención, la intervención y las observaciones. De esta manera, una mascota puede no haber recibido ninguna atención o puede tener varias a lo largo del tiempo, mientras que cada atención corresponde a una única mascota. La entidad TURNO se mantuvo separada de ATENCION, ya que solicitar un turno no significa necesariamente que se haya realizado una atención médica. En TURNO se registran el identificador del turno, la fecha, la hora y la mascota correspondiente.

En relación con los profesionales, se mantuvo la entidad PERSONA como entidad general, de la cual se puede identificar a un PROFESIONAL mediante su DNI. En PROFESIONAL se conserva el atributo especialidad. Además, los turnos se relacionan con el profesional que realizará la atención. De esta manera, se puede conocer qué profesional está asociado a cada turno sin repetir sus datos personales en la tabla TURNO.

En la parte correspondiente a los productos y las compras también se realizaron modificaciones. La entidad PRODUCTO se mantiene para representar los productos que la veterinaria tiene disponibles para la venta, conservando atributos como código de producto, nombre, descripción, stock y precio. Como el desarrollo indica específicamente que se deben registrar los alimentos, incluyendo su marca y la cantidad disponible en kilogramos, se incorporó la entidad ALIMENTO, relacionada con PRODUCTO, donde se almacenan la marca y la cantidad en kilogramos. Esto permite diferenciar los alimentos de otros productos, como los accesorios, sin tener que colocar atributos que solamente corresponden a los alimentos dentro de todos los productos.

Para representar las compras, se reorganizó la estructura inicial y se incorporó la entidad COMPRA, que contiene el código de compra, la fecha, el tipo de cliente y el monto total, además del DNI del cliente que realizó la compra. Como una compra puede contener uno o varios productos y un mismo producto puede formar parte de diferentes compras, se utiliza la entidad intermedia DETALLE_COMPRA. Esta contiene el código de compra, el código del producto, la cantidad y el precio correspondiente al producto dentro de esa compra. De esta forma se puede conocer exactamente qué productos fueron incluidos en cada compra y en qué cantidad.

Por último, se revisaron algunas entidades que se encontraban en el diagrama inicial. La entidad ADMINISTRADOR no se mantuvo debido a que no es mencionada dentro del desarrollo del tema ni resulta necesaria para representar las operaciones solicitadas. De la misma manera, se quitó la estructura relacionada con RECIBO, ya que la consigna solicita registrar las compras y sus datos principales, pero no establece la necesidad de manejar un recibo como entidad independiente. En caso de que posteriormente se requiera registrar información específica de los recibos, podría incorporarse nuevamente

