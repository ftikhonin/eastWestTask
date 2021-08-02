DECLARE @on_date INT = 2020;
DECLARE @on_time TIME = '17:00'

DECLARE @branchName NVARCHAR(100) = 'МОСКВА';
DECLARE @sourceName NVARCHAR(100) = 'email'

--Параметры по п. II
DECLARE @excludeParam BIT = 0; --Исключать или нет те дни, в которых суммарное кол-во не превысило 100500 штук (0-нет, 1-да)
DECLARE @excludeNum INT = 100500; --параметр с количеством заказов

IF OBJECT_ID('tempdb..#orders') IS NOT NULL
  DROP TABLE #orders;
--все заказы
CREATE TABLE #orders(
  OrderId INT NOT NULL PRIMARY KEY
 ,ClientId INT NOT NULL
 ,DeliveryDate DATE NOT NULL
 ,PickupTime TIME  NOT NULL
 ,weekDayNum INT NOT NULL
);

IF OBJECT_ID('tempdb..#ordersMsk') IS NOT NULL
  DROP TABLE #ordersMsk;
--заказы по выбранному филиалу
CREATE TABLE #ordersMsk(
  OrderId INT NOT NULL PRIMARY KEY
 ,ClientId INT NOT NULL
 ,DeliveryDate DATE NOT NULL
 ,PickupTime TIME NOT NULL
 ,weekDayNum INT NOT NULL
);

--тдни недели, на которые приходится самая большая нагрузка
DECLARE @weekDays TABLE (
  weekDayNum INT NOT NULL PRIMARY KEY
);

--Дни, которые будем исключать
DECLARE @exclWeekDays TABLE (
  weekDayNum INT NOT NULL PRIMARY KEY
);

DECLARE @result TABLE (
  weekDayNum INT NOT NULL
 ,average NUMERIC(18, 2)
 ,averageEvening NUMERIC(18, 2)
 ,averageDay NUMERIC(18, 2)
 ,averageAll NUMERIC(18, 2)
);
--сперва возьмём все заказы за 2020 год
INSERT INTO #orders
  SELECT
    oh.OrderId
   ,oh.ClientId
   ,oh.DeliveryDate
   ,oh.PickupTime
   ,DATEPART(WEEKDAY, oh.DeliveryDate)
  FROM OrderHeader oh
  WHERE YEAR(oh.DeliveryDate) = @on_date;

--возьмём заказы только по филиалу МОСКВА
INSERT INTO #ordersMsk
  SELECT
    oh.OrderId
   ,oh.ClientId
   ,oh.DeliveryDate
   ,oh.PickupTime
   ,DATEPART(WEEKDAY, oh.DeliveryDate)
  FROM #orders oh
  JOIN dbo.Client c ON c.ClientId = oh.ClientId
  JOIN dbo.Branch b ON b.BranchId = c.BranchId
    AND b.Name = @branchName;

--дни недели, в которых суммарное кол-во заказов, пришедших по email за 2020 год не превысило 100500 штук.
IF @excludeParam = 1
BEGIN
  INSERT INTO @exclWeekDays
    SELECT
      DATEPART(WEEKDAY, oh.DeliveryDate)
    FROM #orders oh
    JOIN dbo.[Order] o ON o.OrderId = oh.OrderId
    JOIN dbo.Source s ON s.SourceId = o.SourceId
      AND s.Name = @sourceName
    GROUP BY DATEPART(WEEKDAY, oh.DeliveryDate)
    HAVING COUNT(o.OrderId) < @excludeNum;
END

--Выбрать 2 дня недели (ПН, ВТ, …  ), на которые приходится самая большая нагрузка на транспортный отдел по доставке в филиале МОСКВА в 2020 году
INSERT INTO @weekDays (weekDayNum)
  SELECT
    res.weekDayNum
  FROM (
        SELECT DISTINCT TOP 2
          rs.weekDayNum
         ,MAX(rs.cnt) maxCnt
        FROM (
              SELECT DISTINCT
                DATEPART(WEEKDAY, oh.DeliveryDate) weekDayNum
               ,COUNT(*) cnt
              FROM #ordersMsk oh
              GROUP BY DATEPART(WEEKDAY, oh.DeliveryDate)
                      ,oh.DeliveryDate
             ) rs
        GROUP BY rs.weekDayNum
        ORDER BY MAX(rs.cnt) DESC
  ) res
  --исключим дни недели по п. II
  LEFT JOIN @exclWeekDays ew ON ew.weekDayNum = res.weekDayNum
  WHERE ew.weekDayNum IS NULL;

INSERT INTO @result (weekDayNum, average, averageEvening, averageDay)
  SELECT
    cn.weekDayNum [День недели]
   ,AVG(CAST(cn.cnt AS NUMERIC(18, 2))) 
   ,AVG(CAST(eo.cnt AS NUMERIC(18, 2))) 
   ,AVG(CAST(ao.cnt AS NUMERIC(18, 2)))

  FROM (
        SELECT
          rs.weekDayNum
         ,o.DeliveryDate
         ,COUNT(*) cnt
        FROM @weekDays rs
        JOIN #ordersMsk o ON o.weekDayNum = rs.weekDayNum
        GROUP BY rs.weekDayNum
                ,o.DeliveryDate
  ) cn

  CROSS APPLY (
        SELECT
          o.DeliveryDate
         ,COUNT(*) cnt
        FROM #ordersMsk o
        WHERE o.weekDayNum = cn.weekDayNum
        AND o.PickupTime >= @on_time
        GROUP BY o.DeliveryDate
  ) eo

  CROSS APPLY (
        SELECT DISTINCT
          o.DeliveryDate
         ,COUNT(*) cnt
        FROM #orders o
        WHERE o.weekDayNum = cn.weekDayNum
        GROUP BY o.DeliveryDate
  ) ao
  GROUP BY cn.weekDayNum;

--неплохо бы ещё добавить индексы на таблицы, но пока просто вынес в отдельный апдейт в рамках оптимизации
UPDATE @result
SET averageAll = av.averageAll
FROM @result rs
CROSS APPLY (
      SELECT
        AVG(CAST(ao.cnt AS NUMERIC(18, 2))) averageAll
      FROM (
            SELECT DISTINCT
              o.DeliveryDate
             ,COUNT(*) cnt
            FROM #orders o
            GROUP BY o.DeliveryDate
      ) ao
) av;

SELECT DATENAME(WEEKDAY, weekDayNum - 1)
      ,average [Среднее кол-во заказов в ДН Филиал]
      ,averageEvening [Среднее кол-во вечерних заказов в ДН Филиал]
      ,averageDay [Среднее кол-во заказов в ДН Компания]
      ,averageAll [Среднее кол-во заказов]
  FROM @result

