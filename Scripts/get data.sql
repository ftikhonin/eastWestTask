DECLARE @on_date INT = 2020;
DECLARE @on_time TIME = '17:00'
DECLARE @orders TABLE(OrderId INT NOT NULL PRIMARY KEY, ClientId INT NOT NULL, DeliveryDate DATE, PickupTime TIME);
DECLARE @result TABLE([weekDay] NVARCHAR(30), average NUMERIC(18,2), averageEvening INT, averageDay INT, averageAll INT);
--сперва возьмём все заказы за 2020 год
INSERT INTO @orders (OrderId, ClientId, DeliveryDate, PickupTime)
SELECT oh.OrderId
      ,oh.ClientId
      ,oh.DeliveryDate
      ,oh.PickupTime 
FROM OrderHeader oh
WHERE YEAR(oh.DeliveryDate) = @on_date;

DECLARE @ordersMsk TABLE(OrderId INT NOT NULL PRIMARY KEY, ClientId INT NOT NULL, DeliveryDate DATE, PickupTime TIME);
--возьмём заказы только по филиалу МОСКВА
INSERT INTO @ordersMsk (OrderId, ClientId, DeliveryDate, PickupTime)
SELECT oh.OrderId
      ,oh.ClientId
      ,oh.DeliveryDate
      ,oh.PickupTime 
FROM @orders oh
JOIN dbo.Client c ON c.ClientId = oh.ClientId
JOIN dbo.Branch b ON b.BranchId = c.BranchId
                 AND b.Name = 'МОСКВА';


--Выбрать 2 дня недели (ПН, ВТ, …  ), на которые приходится самая большая нагрузка на транспортный отдел по доставке в филиале МОСКВА в 2020 году
INSERT INTO @result (weekDay)
SELECT rs.[День недели] 
FROM (
SELECT DISTINCT TOP 2
       cn.[День недели]
       ,cn.cnt
FROM ( SELECT DATENAME(WEEKDAY, oh.DeliveryDate) AS [День недели]
             ,oh.DeliveryDate
             ,COUNT(*) cnt      
         FROM @ordersMsk oh
        GROUP BY DATENAME(WEEKDAY, oh.DeliveryDate)
                ,oh.DeliveryDate
                ) cn
ORDER BY cn.cnt DESC
) rs;


--        GROUP BY cn.[День недели]
--      ,AVG(CAST(cn.cnt AS NUMERIC(18,2))) --Среднее кол-во заказов в ДН Филиал» (в 2020 году на этот день недели)
--ORDER BY AVG(CAST(cn.cnt AS NUMERIC(18,2))) DESC;



SELECT cn.weekDay [День недели]
      ,AVG(CAST(cn.cnt AS NUMERIC(18,2))) [Среднее кол-во заказов в ДН Филиал]
      ,AVG(CAST(eo.cnt AS NUMERIC(18,2))) [Среднее кол-во вечерних заказов в ДН Филиал]
      ,AVG(CAST(ao.cnt AS NUMERIC(18,2))) [Среднее кол-во заказов в ДН Компания]
      ,AVG(CAST(aa.cnt AS NUMERIC(18,2))) [Среднее кол-во заказов]
FROM (SELECT rs.weekDay
            ,o.DeliveryDate
            ,COUNT(*) cnt
      FROM @result rs
      JOIN @ordersMsk o ON DATENAME(WEEKDAY, o.DeliveryDate) = rs.weekDay
      GROUP BY rs.weekDay
              ,o.DeliveryDate
      ) cn

OUTER APPLY (SELECT DISTINCT
                    o.DeliveryDate
                   ,COUNT(*) cnt
               FROM @ordersMsk o 
              WHERE DATENAME(WEEKDAY, o.DeliveryDate) = cn.weekDay
                AND o.PickupTime >= @on_time
              GROUP BY o.DeliveryDate
             ) eo

OUTER APPLY (SELECT DISTINCT
                    o.DeliveryDate
                   ,COUNT(*) cnt
               FROM @orders o 
              WHERE DATENAME(WEEKDAY, o.DeliveryDate) = cn.weekDay
              GROUP BY o.DeliveryDate
             ) ao

OUTER APPLY (SELECT DISTINCT
                    o.DeliveryDate
                   ,COUNT(*) cnt
               FROM @orders o
              GROUP BY o.DeliveryDate
             ) aa

GROUP BY cn.weekDay
;

SELECT AVG(CAST(eo.cnt AS NUMERIC(18,2)))
FROM (
SELECT DISTINCT rs.weekDay
      ,o.DeliveryDate
      ,COUNT(*) cnt
FROM @result rs
JOIN @ordersMsk o ON DATENAME(WEEKDAY, o.DeliveryDate) = 'понедельник'
AND o.PickupTime >= @on_time
GROUP BY rs.weekDay
        ,o.DeliveryDate)eo
--SELECT rs.weekDay
--      ,rs.average     
----      ,AVG(eo.cnt)
--      ,eo.*
--FROM @result rs
--OUTER APPLY ( SELECT DATENAME(WEEKDAY, o.DeliveryDate) [День недели]
--                    ,o.DeliveryDate
--                    ,COUNT(*) cnt
--                FROM @orders o
--               WHERE DATENAME(WEEKDAY, o.DeliveryDate) = rs.weekDay
--                 AND o.PickupTime >= @on_time
--                 GROUP BY DATENAME(WEEKDAY, o.DeliveryDate)
--                          ,o.DeliveryDate
--            ) eo
--            GROUP BY rs.weekDay, rs.average

