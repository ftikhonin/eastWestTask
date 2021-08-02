/**
 * Процедура, рандомно создаёт клиентов, тестовые заказы в рандомные дни в выбранном году по выбранному дню недели
 *	
 * @param dayOfWeek IN INT - День недели, на который создавать заказ(1-пн, 2-вт и тд)
 * @param cnt IN INT - количество заказов
 * @param year IN INT - год, в котором создать заказы
 * @author Тихонин Ф.И. <f.tihonin@energos.perm.ru>
 */
ALTER PROCEDURE dbo.createTestOrders
(
  @dayOfWeek INT = 1
 ,@cnt       INT = 1
 ,@year      INT = 2001
)
AS
BEGIN

  DECLARE @localCnt INT = 0
  DECLARE @orderId INT;
  DECLARE @clientId INT;
  DECLARE @TimeRangeBegin TIME = '0:00'
         ,@TimeRangeEnd   TIME = '23:59'
  DECLARE @TimeSpanInSec INT = DATEDIFF(SECOND, @TimeRangeBegin, @TimeRangeEnd);
  DECLARE @DeliveryDate DATETIME;

  WHILE @localCnt < @cnt
  BEGIN
  SELECT
    @DeliveryDate = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365), DATEFROMPARTS(@year, 1, 1)); --возьмём рандомную дату в выбранном году

  IF DATEPART(WEEKDAY, @DeliveryDate) = @dayOfWeek
  BEGIN

    SELECT
      @orderId = NEXT VALUE FOR dbo.s_orderId;

    INSERT INTO dbo.[Order] (OrderId, SourceId)
      SELECT
        @orderId
       ,(
              SELECT TOP 1
                s.SourceId
              FROM dbo.Source s
              ORDER BY NEWID()
        );

    --Сгенерируем имя клиента 
    DECLARE @text   NVARCHAR(100)
    DECLARE @length INT
    DECLARE @i      INT;
    DECLARE @dataTypeId INT;
    SET @i = 0
    SET @text = ''
    SET @length = RAND() * 50 + 215
    WHILE (@i < @length)
    BEGIN
    SET @text = @text + CHAR(RAND() * 26 + 65)
    SET @i = @i + 1
    END

    --Заполним таблицу с клиентами, филиал выберем рандомно из существующих
    INSERT INTO dbo.Client (Name, BranchId)
      SELECT TOP 1
        @text
       ,b.BranchId
      FROM dbo.Branch b
      ORDER BY NEWID();

    SELECT
      @clientId = SCOPE_IDENTITY();

    SELECT TOP 1
      @dataTypeId = dt.DataTypeId
    FROM dbo.DataType dt
    ORDER BY NEWID();

    IF @dataTypeId = 2 --если XML, то вставим в XmlData. 
    --Тут неплохо бы ограничить хотя бы на уровне триггеров вставку XML с указанным другим типом(а вдруг кто-нибудь промахнётся :) )
      INSERT INTO dbo.OrderData (OrderId, DataTypeId, FilePath, XmlData)
        VALUES (@orderId, @dataTypeId, NULL, CAST(@text AS XML));
    ELSE
      INSERT INTO dbo.OrderData (OrderId, DataTypeId, FilePath, XmlData)
        VALUES (@orderId, @dataTypeId, @text, NULL);

    INSERT INTO dbo.OrderHeader (OrderId, ClientId, DeliveryDate, PickupTime)
      VALUES (@orderId, @clientId, @DeliveryDate, DATEADD(SECOND, RAND(CAST(NEWID() AS VARBINARY)) * @TimeSpanInSec, @TimeRangeBegin));

    INSERT INTO dbo.OrderLine (OrderId, ProductId, UnitId, Amount)
      SELECT TOP 1
        @orderId
       ,p.ProductId
       ,(
              SELECT TOP 1
                u.UnitId
              FROM dbo.Unit u
              ORDER BY NEWID()
        )
       ,RAND() * 100
      FROM dbo.Product p
      ORDER BY NEWID();

    SET @localCnt += 1;
  END
  END
END