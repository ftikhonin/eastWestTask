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