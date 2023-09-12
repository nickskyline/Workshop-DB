-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.

SELECT id, ciudad FROM oficina;

-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de Indonesia.

SELECT ciudad, telefono FROM oficina WHERE pais = 'Indonesia';

-- 3. Devuelve un listado con el nombre, apellidos e email de los empleados cuyo
-- jefe tiene un código de jefe igual a 7.
 
SELECT nombre, apellido1, apellido2, email FROM empleado WHERE id_jefe = 7;

-- 4. Devuelve un listado con el código de cliente de aquellos clientes que
-- realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar
-- aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
-- • Utilizando la función YEAR de MySQL.
-- • Utilizando la función DATE_FORMAT de MySQL

SELECT DISTINCT cliente_codigo FROM pagos WHERE YEAR(fecha_pago) = 2008;
SELECT cliente_codigo, DATE_FORMAT(p.fecha_pago, '%Y') AS año FROM pagos p 
 WHERE YEAR(fecha_pago) = 2008;
 
-- 5. ¿Cuántos empleados hay en la compañía?

SELECT COUNT(*) as cantidad_empleados FROM empleado;

-- 6. ¿Cuántos clientes tiene cada país?

SELECT pais, COUNT(*) AS cantidad_de_clientes
FROM cliente
GROUP BY pais;

-- 7. ¿Cuál fue el pago medio en 2007?

SELECT ROUND(AVG(total_pago)) as pago_medio_2007 FROM pagos 
WHERE YEAR(fecha_pago) = 2007;

-- 8. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma
-- descendente por el número de pedidos.

SELECT estado, COUNT(*) AS cantidad_de_pedidos
FROM pedidos
GROUP BY estado
ORDER BY cantidad_de_pedidos DESC;

-- 9. Calcula el precio de venta del producto más caro y barato en una misma
-- consulta.

SELECT MAX(precio_venta) as precio_maximo, MIN(precio_venta) as precio_minimo
FROM producto;

-- 10. Devuelve el nombre del cliente con mayor límite de crédito

SELECT nombre_cliente, nombre_contacto
FROM cliente
WHERE limite_credito = (SELECT MAX(limite_credito) FROM cliente);

-- 11. Devuelve el nombre del producto que tenga el precio de venta más caro.

SELECT nombre_producto FROM producto
WHERE precio_venta = (SELECT MAX(precio_venta) FROM producto);

-- 12. Devuelve el nombre del producto del que se han vendido más unidades.
-- (Tenga en cuenta que tendrá que calcular cuál es el número total de
-- unidades que se han vendido de cada producto a partir de los datos de la
-- tabla detalle_pedido)

SELECT p.nombre_producto
FROM producto p
JOIN informacion_pedido ip ON ip.id_producto = p.id
GROUP BY p.nombre_producto
ORDER BY SUM(ip.cantidad) DESC
LIMIT 1;

-- 13. Los clientes cuyo límite de crédito sea mayor que los pagos que haya
-- realizado. (Sin utilizar INNER JOIN).

SELECT nombre_cliente
FROM cliente
WHERE limite_credito > 
(SELECT SUM(total_pago) FROM pagos WHERE pagos.cliente_codigo = cliente.id);

-- 14. Devuelve el listado de clientes indicando el nombre del cliente y cuantos
-- pedidos ha realizado. Tenga en cuenta que pueden existir clientes que no
-- han realizado ningún pedido.'

SELECT c.nombre_cliente, COUNT(p.id) AS cantidad_de_pedidos
FROM cliente c
JOIN pedidos p ON c.id = p.id_Cliente
GROUP BY c.nombre_cliente;

-- 15. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos
-- empleados que no sean representante de ventas de ningún cliente.

SELECT e.nombre, e.apellido1, e.apellido2, e.puesto, o.telefono
FROM empleado e
JOIN oficina o ON e.id_oficina = o.id
WHERE e.id NOT IN (SELECT id_empleado FROM cliente WHERE id_empleado IS NOT NULL);

-- 16. Devuelve las oficinas donde no trabajan ninguno de los empleados que
-- hayan sido los representantes de ventas de algún cliente que haya realizado
-- la compra de algún producto de la gama Ornamentales.]

SELECT *
FROM oficina o
WHERE o.id NOT IN (
    SELECT DISTINCT e.id_oficina
    FROM empleado e
    JOIN cliente c ON e.id = c.id_empleado
    JOIN informacion_pedido ip ON c.id = ip.codigo_cliente
    JOIN producto p ON ip.id_producto = p.id
    WHERE p.gama_producto != 'Ornamentales'
);


-- 17. Devuelve el listado de clientes indicando el nombre del cliente y cuantos
-- pedidos ha realizado. Tenga en cuenta que pueden existir clientes que no
-- han realizado ningún pedido.

SELECT c.nombre_cliente, COUNT(p.id) AS cantidad_de_pedidos
FROM cliente c
JOIN pedidos p ON c.id = p.id_cliente
GROUP BY c.nombre_cliente;

-- 18. Devuelve un listado con los nombres de los clientes y el total pagado por
-- cada uno de ellos. Tenga en cuenta que pueden existir clientes que no han
-- realizado ningún pago.

SELECT c.nombre_cliente, SUM(p.total_pago) AS total_pagado
FROM cliente c
JOIN pagos p ON c.id = p.cliente_codigo
GROUP BY c.nombre_cliente;