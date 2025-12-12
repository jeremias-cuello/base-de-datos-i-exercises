--               BASE DE DATOS II - PRACTICA 10 (2025)
--               ------------------------------------
-- CLIENTES (Nrocli,     NyApe,       Domicilio, Localidad, Saldocli)
-- FACTURAS (Nrofactura, Cliente,     Fecha)
-- DETALLES (Nrofactura, Renglón,     Articulo,  Cantidad,  Preciouni)
-- ARTICULOS(Nroartic,   Descripción, Rubro,     Stock,     Pto_reposicion, precio)
-- RUBROS   (Cod_rubro,  Descripción)

-- A) Hallar los clientes deudores ordenado en forma alfabetica

select * from clientes where saldocli < 0;

-- B) Hallar los articulos que se deberian reponer

select * from articulos where stock < pto_reposicion;

-- C) Averiguar los clientes que viven en Capital

select * from clientes where localidad = 'Capital Federal';

-- D) Averiguar los clientes que vivan en Capital o en Carapachay y no sean deudores

select * from clientes
where (localidad ilike 'Capital Federal' or localidad ilike 'Carapachay') and saldocli >= 0;

-- E) Averiguar la cantidad de cada uno de los articulos vendidos durante
--    marzo del 2010, ordenado segun la cantidad vendida.
--    (Rsta: 13 FILAS)

select
  articulo,
  count(articulo)
from detalles
  inner join facturas on facturas.nrofactura = detalles.nrofactura
where extract(month from facturas.fecha) = '03' and extract(year from facturas.fecha) = '2010'
group by articulo
order by count(articulo) desc;

-- F) Hallar los importes totales día a día durante abril del 2010, ordenados en
-- forma decreciente. (Rsta: 5 filas)

select
  facturas.fecha,
  sum(cantidad * preciouni)
from detalles
  inner join facturas on detalles.nrofactura = facturas.nrofactura
where extract(month from facturas.fecha) = '03' and extract(year from facturas.fecha) = '2010'
group by facturas.fecha
order by facturas.fecha desc
;

-- G) Obtener las fechas en las que se hayan vendido más de $200.- (Rsta: filas 9)

select
  facturas.fecha,
  sum(cantidad * preciouni) as importeTotal
from detalles
  inner join facturas on detalles.nrofactura = facturas.nrofactura
group by facturas.fecha
having sum(cantidad * preciouni) > 200;

-- H) Obtener las fechas en las que mas se facturo (2010-03-17 - $429)

-- mi solucion
select
  facturas.fecha,
  sum(cantidad * preciouni) as importe
from detalles
  inner join facturas on detalles.nrofactura = facturas.nrofactura
  group by facturas.fecha
having sum(cantidad * preciouni) = (
  select
    max(importe)
  from (
    select
      f.fecha,
      sum(cantidad * preciouni) as importe
    from detalles
      inner join facturas f on detalles.nrofactura = f.nrofactura
    group by f.fecha
  )
)

-- solucion chatGPT
SELECT f.Fecha,
	SUM(d.Cantidad * d.Preciouni) AS Total_Facturado
FROM FACTURAS f
  INNER JOIN DETALLES d ON f.Nrofactura = d.Nrofactura
GROUP BY f.Fecha
HAVING SUM(d.Cantidad * d.Preciouni) = (
  SELECT MAX(Total_Por_Fecha)
  FROM (
    SELECT SUM(dd.Cantidad * dd.Preciouni) AS Total_Por_Fecha
    FROM FACTURAS ff
    JOIN DETALLES dd ON ff.Nrofactura = dd.Nrofactura
    GROUP BY ff.Fecha
  ) AS Totales
);

-- I A) Averiguar los rubros con movimientos del 15 al 30 de Abril del 2010 (Rsta: 3 filas)

select distinct rubros.descripcion
from detalles
  inner join facturas on detalles.nrofactura = facturas.nrofactura
  inner join articulos on detalles.articulo = articulos.nroartic
  inner join rubros on rubros.cod_rubro = articulos.rubro
where
  facturas.fecha BETWEEN '2010-04-15' AND '2010-04-30'

-- J) Listar Numero y nombre de los cliente. Además, listar la cantidad de facturas que
--    tuvo durante Marzo y Abril del 2010 considerando SOLO las facturas en las que compro
--    articulos del rubro 3, ordenado por numero de cliente. (Rsta: 7 filas)

select
  nrocli,
  nyape,
  count(facturas.nrofactura) as totalFacturas
from clientes
  inner join facturas on facturas.cliente = clientes.nrocli
  where (facturas.fecha between '2010-03-01' and '2010-04-30')
  and facturas.nrofactura in (
    -- Estas son las facturas que contienen al menos un articulo del rubro 03
    select detalles.nrofactura
    from detalles
      inner join articulos on detalles.articulo = articulos.nroartic
    where articulos.rubro = 3
    group by detalles.nrofactura
  )
group by clientes.nrocli
;

-- K) Listar Numero y nombre de los cliente y la cantidad de facturas que tuvo durante
--    Marzo y Abril del 2010 con articulos del rubro 3 y CON MAS DE 2 FACTURAS,
--    ordenado por numero de cliente. (Rsta: 1 fila)

select
  nrocli,
  nyape,
  count(facturas.nrofactura) as totalFacturas
from clientes
  inner join facturas on facturas.cliente = clientes.nrocli
  where (facturas.fecha between '2010-03-01' and '2010-04-30')
  and facturas.nrofactura in (
	-- Estas son las facturas que contienen al menos un articulo del rubro 03
	select detalles.nrofactura
	from detalles
	inner join articulos on detalles.articulo = articulos.nroartic
	where articulos.rubro = 3
	group by detalles.nrofactura
  )
group by clientes.nrocli
having count(facturas.nrofactura) > 2
order by clientes.nrocli asc
;

-- L) Calcular la cantidad de unidades del artículo 4040 vendidas en marzo del 2010.
--    (Rsta: 8 articulos)

select
  sum(detalles.cantidad) as total_units
from articulos
  inner join detalles on detalles.articulo = articulos.nroartic
  inner join facturas on facturas.nrofactura = detalles.nrofactura
where
  articulos.nroartic = 4040
  and facturas.fecha BETWEEN '2010-03-01' and '2010-03-31'

-- M) Calcular la cantidad de facturas en las que vendieron artículos del rubro 3
--    (Rsta: 26 facturas)

select
  count(*) as quantity_tickets
from (
  select 1
    from detalles
      inner join articulos on articulos.nroartic = detalles.articulo
    where articulos.rubro = 3
    group by detalles.nrofactura
)

-- N) Obtener el promedio del importe diario de las ventas del mes de mayo del 2010.

select
  facturas.fecha,
  avg(detalles.cantidad * detalles.preciouni) as average_amount
from detalles
  inner join facturas on facturas.nrofactura = detalles.nrofactura
where facturas.fecha BETWEEN '2010-03-01' and '2010-03-31'
group by facturas.fecha

-- O) a) Listar el numero, nombre, apellido y el total facturado de los clientes que
--       hayan gastado más de $150 durante el mes de mayo de 2010.

select
  clientes.nrocli,
  clientes.nyape,
  sum(detalles.cantidad * detalles.preciouni) as total_billed
from
  facturas
  inner join detalles on detalles.nrofactura = facturas.nrofactura
  inner join clientes on clientes.nrocli = facturas.cliente
where (extract(month from facturas.fecha) = '05' and extract(year from facturas.fecha) = '2010')
group by clientes.nrocli
having sum(detalles.cantidad * detalles.preciouni) > 150;

--    b) Listar el numero, nombre, apellido y el total facturado de los clientes que
--       hayan gastado en mayo de 2010 mas que en abril de 2010.

select
  clientes.nrocli,
  clientes.nyape,
  sum(detalles.cantidad * detalles.preciouni) as total_billed
from
  facturas
  inner join detalles on detalles.nrofactura = facturas.nrofactura
  inner join clientes on clientes.nrocli = facturas.cliente
where extract(month from facturas.fecha) = '04' and extract(year from facturas.fecha) = '2010'
group by clientes.nrocli
having sum(detalles.cantidad * detalles.preciouni) > (
  select sum(detalles.cantidad * detalles.preciouni)
  from detalles
    inner join facturas on detalles.nrofactura = facturas.nrofactura
  where extract(month from facturas.fecha) = '05' and extract(year from facturas.fecha) = '2010'
    and facturas.cliente = clientes.nrocli
)
;

-- P) Listar los articulos que tengan un stock menor al stock minimo y NO se hayan
--    vendido en Junio del 2010 (Resultado: 1 fila)

select
  articulos.*
from articulos
  inner join detalles on articulos.nroartic = detalles.articulo
  inner join facturas on facturas.nrofactura = detalles.nrofactura
where articulos.stock < articulos.pto_reposicion
  and articulos.nroartic not in (
    select articulos.nroartic
    from articulos
      inner join detalles on articulos.nroartic = detalles.articulo
      inner join facturas on facturas.nrofactura = detalles.nrofactura
    where extract(month from facturas.fecha) = '06' and extract(year from facturas.fecha) = '2010'
  )

-- Q) Listar los artículos que tengan un precio mayor a la mitad del precio
--    promedio de los artículos y un stock mínimo mayor a 200 unidades. (6 filas)

select
  articulos.*
from articulos
where articulos.precio > (
  select avg(precio) / 2
  from articulos
) and articulos.pto_reposicion > 200

-- R) Listar los datos cabecera de las Facturas de mas de $200 y que la cantidad
--    de artículos facturados en la misma sea mayor a 30 (Rsta: 4 filas)

select
  facturas.*,
  sum(detalles.cantidad * detalles.preciouni)
from facturas
  inner join detalles on detalles.nrofactura = facturas.nrofactura
group by facturas.nrofactura
having sum(detalles.cantidad * detalles.preciouni) > 200 and (
    select
        sum(detalles.cantidad)
    from facturas f
        inner join detalles on detalles.nrofactura = f.nrofactura
    where f.nrofactura = facturas.nrofactura
) > 30

-- S) Listar los datos cabecera de las Facturas de mas de $200 y que la cantidad
--    de artículos facturados en la misma sea mayor al 5% del stock promedio
--    de los rubros "Herramienta%" (Rsta: 5 FILAS)

select
  facturas.*,
  sum(detalles.cantidad * detalles.preciouni)
from facturas
  inner join detalles on detalles.nrofactura = facturas.nrofactura
group by facturas.nrofactura
having sum(detalles.cantidad * detalles.preciouni) > 200
  and (
    select
      sum(detalles.cantidad)
    from facturas f
      inner join detalles on detalles.nrofactura = f.nrofactura
    where f.nrofactura = facturas.nrofactura
  ) > (
    select avg(stock) * 0.05
    from articulos
      inner join rubros on rubros.cod_rubro = articulos.rubro
    where rubros.descripcion ilike 'Herramienta%'
  )

-- (T) a) Listar los clientes compraron TODOS los articulos (1 fila - cliente 109)

select clientes.*
from clientes
where (
  select count(articulo)
  from (
    select detalles.articulo
    from (
      -- Devuele las facturas de un cliente
      select facturas.nrofactura
      from facturas
      where facturas.cliente = clientes.nrocli
    ) as cli_facturas
    inner join detalles on cli_facturas.nrofactura = detalles.nrofactura
    group by detalles.articulo
  )
) = (select count(*) from articulos)

--    b) Listar los clientes que en Junio compraron TODOS los articulos del rubro
--       "Tornillos". (2 filas - clientes 160 - 304)

select clientes.*
from clientes
where (
  select count(articulo)
  from (
    select detalles.articulo
    from (
      -- Devuele las facturas de un cliente
      select facturas.nrofactura
      from facturas
      where facturas.cliente = clientes.nrocli
      and extract(month from facturas.fecha) = '06'
    ) as cli_facturas
    inner join detalles on cli_facturas.nrofactura = detalles.nrofactura
    inner join articulos on articulos.nroartic = detalles.articulo
    inner join rubros on articulos.rubro = rubros.cod_rubro
    where rubros.descripcion ilike 'Tornillos'
    group by detalles.articulo
  )
) = (
  select count(*)
  from articulos
    inner join rubros on articulos.rubro = rubros.cod_rubro
  where rubros.descripcion ilike 'Tornillos'
)

-- U) Aumentar un 10% el stock mínimo de los artículos del rubro 'Tornillos'
--
--------------------------------------------------------------------------------------
-- V) Agregar la columna color (alfabetico) a la tabla ARTICULOS
--
--------------------------------------------------------------------------------------
-- W) Dar permisos de lectura y actualizacion a los usuarios 'SIST' y 'ADMIN'
--    sobre la tabla ARTICULOS
--
--------------------------------------------------------------------------------------
-- X) Generar una view con los articulos del rubro "Clavos"
--
--------------------------------------------------------------------------------------
-- Y) Listar los clientes de 'Capital Federal' que NO compraron articulos del
--    rubro 'Articulos de Electricidad' durante mayo de año 2010.
--    Ordenar los datos en forma descendente por nombre y apellido. (Rsta: 10 filas)

select clientes.*
from clientes
where clientes.nrocli not in (
  select clientes.nrocli
  from clientes
    inner join facturas on facturas.cliente = clientes.nrocli
    inner join detalles on facturas.nrofactura = detalles.nrofactura
    inner join articulos on articulos.nroartic = detalles.articulo
    inner join rubros on articulos.rubro = rubros.cod_rubro
  where rubros.descripcion ilike '%Electricidad%'
    and extract(month from facturas.fecha) = '05' and extract(year from facturas.fecha) = '2010'
)
and clientes.localidad ilike '%Capital Federal%'
order by clientes.nyape desc

-- Z) Listar los rubros (y la cantidad de articulos vendidos) de cada rubro que haya vendido mas de 30 articulos.

select
  rubros.descripcion,
  count(rubros.cod_rubro)
from rubros
  inner join articulos on articulos.rubro = rubros.cod_rubro
  inner join detalles on detalles.articulo = articulos.nroartic
group by rubros.cod_rubro
having count(rubros.cod_rubro) > 30

-- 1) Generar una view, FACT-CAB (Nrofactura, Cliente, Fecha, TOTAL)
--
--------------------------------------------------------------------------------------
-- 2) Agregar la columna TOTAL en la tabla FACTURAS. Actualizar la misma con el total
--    segun corresponda.
--
--------------------------------------------------------------------------------------
-- 3) Generar un unico Select con el o los articulos mas caros y con el o los mas baratos

select
  articulos.nroartic,
  min(precio)
from articulos
group by articulos.nroartic
having min(precio) = (
  select min(precio) from articulos
)

-- 4) Listar los datos de los clientes que no compraron ningun articulo
--    (Rsta: 3 filas)

select clientes.*
from clientes
where clientes.nrocli not in (
  select facturas.cliente
  from facturas
  group by facturas.cliente
)

-- 5) Listar las localidades que vendieron mas de que lo que se le facturo al cliente 179

select localidad
from clientes
where clientes.nrocli in (
    select
      facturas.cliente
    from facturas
      inner join detalles on detalles.nrofactura = facturas.nrofactura
    group by facturas.cliente
    having sum(detalles.cantidad * detalles.preciouni) >= (
      select
        sum(detalles.cantidad * detalles.preciouni) as importe
      from facturas
        inner join detalles on detalles.nrofactura = facturas.nrofactura
      where facturas.cliente = 179
    )
)

-- 6) Listar numero, nombre y apellido de los clientes, el total facturado y el
--    porcentaje que representa ese total facturado del total facturado por la empresa
--
--    Rsta: Nrocli   NyApe           Facturado   Porc_del_total_facturado
--          ------   ---------------  -------    -------------------------
--          179	   "Natalia Lopéz"  "781.00"	"15.81611988659376265700"
--          109    "Pedro Garcia"   "641.00"	"12.98096395301741595800"
--          160	   "Silvana Zabala" "545.00"	"11.03685702713649250700"

select
  clientes.nrocli as Nrocli,
  clientes.nyape as NyApe,
  sum(detalles.cantidad * detalles.preciouni) as Facturado,
  ( sum(detalles.cantidad * detalles.preciouni) * 100 ) / (
    select
      sum(Facturado) as Porc_del_total_facturado
    from (
      select
        clientes.nrocli as Nrocli,
        clientes.nyape as NyApe,
        sum(detalles.cantidad * detalles.preciouni) as Facturado
      from clientes
        inner join facturas on facturas.cliente = clientes.nrocli
        inner join detalles on facturas.nrofactura = detalles.nrofactura
      group by clientes.nrocli
      order by Facturado desc
    )
  ) as Porc_del_total_facturado
from clientes
  inner join facturas on facturas.cliente = clientes.nrocli
  inner join detalles on facturas.nrofactura = detalles.nrofactura
group by clientes.nrocli
order by Facturado desc

-- 7) Crear una view de nombre FACTURA_TOTAL que tenga los datos de la tabla FACTURAS,
--    una columna con el total de la factura y el nombre y apellido del cliente
--
------------------------------------------------------------------------------------------
-- 8) Listar los clientes, el importe facturado en Agosto de 2010 y el importe facturado
--    en Julio de 2010 si y solo si, se le facturo en Agosto 10% mas que en Julio

select
  *
from (
  select
    clientes.nrocli,
    facturas.fecha,
    sum(detalles.cantidad * detalles.preciouni) as importe_facturado_agosto
  from clientes
    inner join facturas on facturas.cliente = clientes.nrocli
    inner join detalles on detalles.nrofactura = facturas.nrofactura
  where (extract(month from facturas.fecha) = '05' and extract(year from facturas.fecha) = '2010') --08 | Agosto
  group by clientes.nrocli, facturas.fecha
) as clienteAgosto
left outer join
(
  select
    clientes.*,
    facturas.fecha,
    sum(detalles.cantidad * detalles.preciouni) as importe_facturado_julio
  from clientes
    inner join facturas on facturas.cliente = clientes.nrocli
    inner join detalles on detalles.nrofactura = facturas.nrofactura
  where (extract(month from facturas.fecha) = '06' and extract(year from facturas.fecha) = '2010') --07 | Julio
  group by clientes.nrocli, facturas.fecha
) as clienteJulio
on true

-- 9) Listar todos los datos de los clientes, el total facturado y la cantidad de facturas
--    del primer trimestre del año 2010 y el total facturado y la cantidad de facturas
--    del segundo trimestre del año 2010
--
--  Nro nyape          Domicilio   Localidad        Saldo  T_1Trim  Q_1Trim T_2Trim  Q_2Trim
-- ---- -------------  ----------- --------------- -------  ------- ------- -------  --------
--   69 Juan Martinez  Maipu 123   Capital Federal  -28.00    42.00	1   <null>	0
--  109 Pedro Garcia   Rosales 346 Capital Federal -121.00   389.00	3   252.00	2
--  138 Isela Perez    Alsina 399  Carapachay	    -39.67    21.00	1   102.00	3
--  160 Silvana Zabala Medrano 32  Capital Federal  -45.67    32.00	1   513.00	4

--------------------------------------- Fin Practica10 -----------------------------------
