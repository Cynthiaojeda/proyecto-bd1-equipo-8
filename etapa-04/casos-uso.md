Existen diferentes casos de uso para la base de datos.
Podemos leer los siguientes turnos para un profesional y ordenarlos por fecha.
SELECT fecha FROM Turno WHERE dni_veterinario = 30333444 ORDER BY fecha;

Podemos leer todas las mascotas que pertenecen a un dueño.
SELECT * FROM Mascota WHERE dni_cliente = 30111222;

Podemos leer unicamente las mascotas de una misma especie.
SELECT nombre, raza FROM Mascota WHERE especie = 'perro';

Podemos contar cuantas mascotas hay de cada especie
SELECT especie, COUNT(especie)AS 'Total' 
FROM Mascota GROUP BY especie;

Podemos leer si una mascota tuvo en el pasado turnos con un profesional en especifico.
SELECT * FROM Turno WHERE id_mascota = 1 AND dni_veterinario = 30111222;

Podemos calcular el acumulado y cantidad de compras sobre un tipo de pago especifico
SELECT COUNT(Compra.monto_total) AS 'Cantidad', SUM(Compra.monto_total) AS 'Total' 
FROM Compra WHERE id_pago = 1;

Podemos leer las compras realizadas por un cliente
SELECT nombre, dni FROM Persona
join Compra
	on Persona.dni = Compra.dni_cliente
WHERE Persona.dni = 30999000;
