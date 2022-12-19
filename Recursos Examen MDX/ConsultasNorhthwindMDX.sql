
--1. Total de ventas por cliente, año y categoría de producto.
 SELECT [Measures].[Sales Amount] ON COLUMNS,
NON EMPTY [Customer].[Customer Key].[Customer Key].MEMBERS * [Order Date].[Year].MEMBERS * [Product].[Category Name].[Category Name] ON ROWS
FROM [Northwind DW] 

--2. Total de ventas anuales por país cliente y país proveedor.
 SELECT [Measures].[Sales Amount] ON COLUMNS,
NON EMPTY  [Order Date].[Year].MEMBERS * [Customer].[Geography].[Country] *[Supplier].[Geography].[Country] ON ROWS
FROM [Northwind DW] 

-- 3. Tres productos con mayores ventas
WITH SET Top3Products AS
TOPCOUNT([Product].[Category Name].[Category Name].MEMBERS, 3, [Measures].[Sales Amount])
SELECT [Measures].[Sales Amount] ON COLUMNS,
Top3Products ON ROWS
FROM [Northwind DW]


-- 4. El proveedor de productos que mayores ventas ha aportado a la empresa por producto y año. 

WITH MEMBER Proveedor AS  {TOPCOUNT ([Supplier].[Geography].[Supplier],1,[Measures].[Sales Amount])}.ITEM(0).NAME
SELECT Proveedor ON COLUMNS,
[Product].[Categories].[Product].MEMBERS * [Order Date].[Year].CHILDREN ON ROWS
FROM [Northwind DW]

-- 5. Cantidad total de ventas y cantidad total de los descuentos por producto y mes. 
WITH MEMBER TotalDescuentos AS  ([Measures].[Quantity] * [Measures].[Unit Price] *[Measures].[Discount])
SELECT{ [Measures].[Sales Amount], TotalDescuentos} ON COLUMNS,
[Product].[Categories].[Product].MEMBERS * [Order Date].[Full Month].CHILDREN ON ROWS
FROM [Northwind DW]

-- 6. Total de ventas y media mensual de ventas por categoría de producto y año. 
WITH MEMBER MediaMensual AS  ([Measures].[Sales Amount] / 12)
SELECT{ [Measures].[Sales Amount], MediaMensual} ON COLUMNS,
[Product].[Categories].[Category].MEMBERS * [Order Date].[Year].CHILDREN ON ROWS
FROM [Northwind DW]

-- 7. Crecimiento acumulado de las ventas mensuales para cada año y categoría
WITH MEMBER CrecimientoAcumulado AS  (([Measures].[Sales Amount] - ([Measures].[Sales Amount], [Order Date].[Calendar].PREVMEMBER)) / ([Measures].[Sales Amount]) * 100)
SELECT CrecimientoAcumulado ON COLUMNS,
[Product].[Categories].[Category].MEMBERS * [Order Date].[Calendar].[Month].MEMBERS ON ROWS
FROM [Northwind DW]

