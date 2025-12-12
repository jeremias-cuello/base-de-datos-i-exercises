# BASE DE DATOS I - Ejercicos

---

## Modelo Relacional

CLIENTES (Nrocli,     NyApe,       Domicilio, Localidad, Saldocli)

FACTURAS (Nrofactura, Cliente,     Fecha)

DETALLES (Nrofactura, Renglón,     Articulo,  Cantidad,  Preciouni)

ARTICULOS(Nroartic,   Descripción, Rubro,     Stock,     Pto_reposicion, precio)

RUBROS   (Cod_rubro,  Descripción)

## Ejercicios

1. Hallar los clientes deudores ordenado en forma alfabetica

2. Hallar los articulos que se deberán reponer

3. Averiguar los clientes que viven en Capital

4. Averiguar los clientes que vivan en Capital o en Carapachay y no sean deudores

5. Averiguar la cantidad de cada uno de los articulos vendidos durante marzo del 2010, ordenado segun la cantidad vendida.
   **Respuesta**: 13 filas

6. Hallar los importes totales día a día durante abril del 2010, ordenados en forma decreciente.
   **Respuesta**: 5 filas

7. Obtener las fechas en las que se hayan vendido más de $200
   **Respuesta**: filas 9

8. Obtener las fechas en las que mas se facturo (2010-03-17 - $429)

9. Averiguar los rubros con movimientos del 15 al 30 de Abril del 2010
    **Respuesta**: 3 filas

10. Listar Numero y nombre de los cliente. Además, listar la cantidad de facturas que tuvo durante Marzo y Abril del 2010 considerando SOLO las facturas en las que compro articulos del rubro 3, ordenado por numero de cliente.
    **Respuesta**: 7 filas

11. Listar Numero y nombre de los cliente y la cantidad de facturas que tuvo durante Marzo y Abril del 2010 con articulos del rubro 3 y CON MAS DE 2 FACTURAS, ordenado por numero de cliente.
    **Respuesta**: 1 fila

12. Calcular la cantidad de unidades del artículo 4040 vendidas en marzo del 2010.
    **Respuesta**: 8 articulos

13. Calcular la cantidad de facturas en las que vendieron artículos del rubro 3
    **Respuesta**: 26 facturas

14. Obtener el promedio del importe diario de las ventas del mes de mayo del 2010.

15.
    1. Listar el numero, nombre, apellido y el total facturado de los clientes que hayan gastado más de $150 durante el mes de mayo de 2010.
    2. Listar el numero, nombre, apellido y el total facturado de los clientes que hayan gastado en mayo de 2010 mas que en abril de 2010.

16. Listar los articulos que tengan un stock menor al stock minimo y NO se hayan vendido en Junio del 2010
    **Respuesta**: 1 fila

17. Listar los artículos que tengan un precio mayor a la mitad del precio promedio de los artículos y un stock mínimo mayor a 200 unidades.
    **Respuesta**: 6 filas

18. Listar los datos cabecera de las Facturas de mas de $200 y que la cantidad de artículos facturados en la misma sea mayor a 30
    **Respuesta**: 4 filas

19. Listar los datos cabecera de las Facturas de mas de $200 y que la cantidad de artículos facturados en la misma sea mayor al 5% del stock promedio de los rubros "Herramienta%"
    **Respuesta**: 5 FILAS
20.
    1. Listar los clientes compraron TODOS los articulos
       **Respuesta**: 1 fila, cliente 109
    2. Listar los clientes que en Junio compraron TODOS los articulos del rubro
       **Respuesta**: "Tornillos". (2 filas - clientes 160 - 304)

21. Aumentar un 10% el stock mínimo de los artículos del rubro 'Tornillos'

22. Agregar la columna color (alfabetico) a la tabla ARTICULOS

23. Dar permisos de lectura y actualizacion a los usuarios 'SIST' y 'ADMIN' sobre la tabla ARTICULOS

24. Generar una view con los articulos del rubro "Clavos"

25. Listar los clientes de 'Capital Federal' que NO compraron articulos del rubro 'Articulos de Electricidad' durante mayo de año 2010. Ordenar los datos en forma descendente por nombre y apellido.
    **Respuesta**: 10 filas

26. Listar los rubros (y la cantidad de articulos vendidos) de cada rubro que haya vendido mas de 30 articulos.

27. Generar una view, FACT-CAB (Nrofactura, Cliente, Fecha, TOTAL)

28. Agregar la columna TOTAL en la tabla FACTURAS. Actualizar la misma con el total segun corresponda.

29. Generar un unico Select con el o los articulos mas caros y con el o los mas baratos

30. Listar los datos de los clientes que no compraron ningun articulo
    **Respuesta**: 3 filas

31. Listar las localidades que vendieron mas de que lo que se le facturo al cliente 179

32. Listar numero, nombre y apellido de los clientes, el total facturado y el porcentaje que representa ese total facturado del total facturado por la empresa
    **Respuesta**

    | Nrocli | NyApe            | Facturado | Porc_del_total_facturado  |
    | ------ | ---------------- | --------- | ------------------------- |
    | 179    | "Natalia Lopez"  | "781.00"  | "15.81611988659376265700" |
    | 109    | "Pedro Garcia"   | "641.00"  | "12.98096395301741595800" |
    | 160    | "Silvana Zabala" | "545.00"  | "11.03685702713649250700" |

33. Crear una view de nombre FACTURA_TOTAL que tenga los datos de la tabla FACTURAS, una columna con el total de la factura y el nombre y apellido del cliente

34. Listar los clientes, el importe facturado en Agosto de 2010 y el importe facturado en Julio de 2010 si y solo si, se le facturo en Agosto 10% mas que en Julio

35. Listar todos los datos de los clientes, el total facturado y la cantidad de facturas del primer trimestre del año 2010 y el total facturado y la cantidad de facturas del segundo trimestre del año 2010
    **Respuesta**
    | Nro | nyape          | Domicilio                    | Localidad       | Saldo  | T_1Trim | Q_1Trim | T_2Trim | Q_2Trim |
    | --- | -------------- | ---------------------------- | --------------- | ------ | ------- | ------- | ------- | ------- |
    | 69  | Juan Martinez  | Maipu 123                    | Capital Federal | -28.00 | 42.00   | 1       | <null>  | 0       |
    | 109 | Pedro Garcia   | Rosales 346  Capital Federal | -121.00         | 389.00 | 3       | 252.00  | 2       |         |
    | 138 | Isela Perez    | Alsina 399   Carapachay      | -39.67          | 21.00  | 1       | 102.00  | 3       |         |
    | 160 | Silvana Zabala | Medrano 32   Capital Federal | -45.67          | 32.00  | 1       | 513.00  | 4       |         |
