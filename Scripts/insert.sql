INSERT INTO dbo.Source (Name)
  VALUES (N'email');
INSERT INTO dbo.Source (Name)
  VALUES (N'FTP');
INSERT INTO dbo.Source (Name)
  VALUES (N'web API клиента компании');
INSERT INTO dbo.Source (Name)
  VALUES (N'Telegram');

INSERT INTO dbo.Branch (Name)
  VALUES ('МОСКВА');
INSERT INTO dbo.Branch (Name)
  VALUES ('САНКТ-ПЕТЕРБУРГ');
INSERT INTO dbo.Branch (Name)
  VALUES ('ЕКАТЕРИНБУРГ');
INSERT INTO dbo.Branch (Name)
  VALUES ('КРАСНОДАР');
INSERT INTO dbo.Branch (Name)
  VALUES ('НОВОСИБИРСК');
INSERT INTO dbo.Branch (Name)
  VALUES ('КАЗАНЬ');
INSERT INTO dbo.Branch (Name)
  VALUES ('КРАСНОЯРСК');
INSERT INTO dbo.Branch (Name)
  VALUES ('НИЖНИЙ НОВГОРОД');
INSERT INTO dbo.Branch (Name)
  VALUES ('ПЕРМЬ');
INSERT INTO dbo.Branch (Name)
  VALUES ('РОСТОВ-НА-ДОНУ');
INSERT INTO dbo.Branch (Name)
  VALUES ('СОЧИ');
INSERT INTO dbo.Branch (Name)
  VALUES ('ТЮМЕНЬ');
INSERT INTO dbo.Branch (Name)
  VALUES ('УФА');
INSERT INTO dbo.Branch (Name)
  VALUES ('ЧЕЛЯБИНСК');


INSERT INTO dbo.DataType (Name)
  VALUES (N'xlsx');
INSERT INTO dbo.DataType (Name)
  VALUES (N'xml');
INSERT INTO dbo.DataType (Name)
  VALUES (N'csv');
INSERT INTO dbo.DataType (Name)
  VALUES (N'json');

INSERT INTO dbo.Product(Name)
  VALUES (N'Курица');
INSERT INTO dbo.Product (Name)
  VALUES (N'Говядина');
INSERT INTO dbo.Product (Name)
  VALUES (N'Свинина');
INSERT INTO dbo.Product (Name)
  VALUES (N'Рыба');
INSERT INTO dbo.Product (Name)
  VALUES (N'Картофель');
INSERT INTO dbo.Product (Name)
  VALUES (N'Яйцо');
INSERT INTO dbo.Product (Name)
  VALUES (N'Молоко');
INSERT INTO dbo.Product (Name)
  VALUES (N'Сыр');

INSERT INTO dbo.Unit (ShortName, FullName)
  VALUES (N'кг.', N'Килограмм');
INSERT INTO dbo.Unit (ShortName, FullName)
  VALUES (N'шт.', N'Штука');
INSERT INTO dbo.Unit (ShortName, FullName)
  VALUES (N'л.', N'Литр');

DECLARE @cnt INT = 0
DECLARE @orderId INT;
DECLARE @clientId INT;
DECLARE @TimeRangeBegin time = '0:00', @TimeRangeEnd time = '23:59'
DECLARE @TimeSpanInSec int = datediff(second,@TimeRangeBegin, @TimeRangeEnd);
DECLARE @DeliveryDate DATETIME;

WHILE @cnt < 1000
BEGIN  
  SELECT @DeliveryDate = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 1095), '2019-01-01'); --возьмём рандомную дату
  IF DATENAME(WEEKDAY, @DeliveryDate) = 'пятница'
  BEGIN

  SELECT @orderId = NEXT VALUE FOR dbo.s_orderId;

	INSERT INTO dbo.[Order] (OrderId, SourceId)
  SELECT @orderId, (SELECT top 1 s.SourceId FROM dbo.Source s ORDER BY NEWID());
  
  --Сгенерируем имя клиента 
  DECLARE     @text NVARCHAR(100),
              @length INT,
              @i INT;
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
  SELECT TOP 1 @text, b.BranchId FROM dbo.Branch b ORDER BY NEWID();
  SELECT @clientId = SCOPE_IDENTITY();
  SELECT TOP 1 @dataTypeId = dt.DataTypeId
  FROM dbo.DataType dt
  ORDER BY NEWID();

  IF @dataTypeId = 2 --если XML, то вставим в XmlData
    INSERT INTO dbo.OrderData (OrderId, DataTypeId, FilePath, XmlData)
      VALUES (@orderId, @dataTypeId, NULL, CAST(@text AS XML));
  ELSE
    INSERT INTO dbo.OrderData (OrderId, DataTypeId, FilePath, XmlData)
      VALUES (@orderId, @dataTypeId, @text, NULL);

  INSERT INTO dbo.OrderHeader (OrderId, ClientId, DeliveryDate, PickupTime)
    VALUES (@orderId, @clientId, @DeliveryDate, DATEADD(SECOND, RAND(CAST(NEWID() AS VARBINARY)) * 
    @TimeSpanInSec,@TimeRangeBegin));
  
  INSERT INTO dbo.OrderLine (OrderId, ProductId, UnitId, Amount)
    SELECT TOP 1 @orderId, p.ProductId, (SELECT TOP 1 u.UnitId FROM dbo.Unit u ORDER BY NEWID()), RAND()*100
    FROM dbo.Product p
    ORDER BY NEWID();
  
  SET @cnt += 1;
  END
END

