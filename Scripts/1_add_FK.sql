﻿
ALTER TABLE dbo.Client
ADD CONSTRAINT FK_CLIENT_REFERENCE_1_BRANCH FOREIGN KEY (BranchId) REFERENCES dbo.Branch (BranchId)
GO;

ALTER TABLE dbo.[Order]
ADD CONSTRAINT FK_ORDER_REFERENCE_2_SOURCE FOREIGN KEY (SourceId) REFERENCES dbo.Source (SourceId)
GO;

ALTER TABLE dbo.OrderData
ADD CONSTRAINT FK_ORDER_DATA_REFERENCE_3_DATATYPE FOREIGN KEY (DataTypeId) REFERENCES dbo.DataType (DataTypeId)
GO;

ALTER TABLE dbo.OrderHeader
ADD CONSTRAINT FK_ORDER_HEADER_REFERENCE_4_CLIENT FOREIGN KEY (ClientId) REFERENCES dbo.Client (ClientId)
GO;

ALTER TABLE dbo.OrderLine
ADD CONSTRAINT FK_ORDER_LINE_REFERENCE_5_PRODUCT FOREIGN KEY (ProductId) REFERENCES dbo.Product (ProductId)
GO;

ALTER TABLE dbo.OrderLine
ADD CONSTRAINT FK_ORDER_LINE_REFERENCE_6_UNIT FOREIGN KEY (UnitId) REFERENCES dbo.Unit (UnitId)
GO;

ALTER TABLE dbo.OrderLine
ADD CONSTRAINT FK_ORDER_LINE_REFERENCE_7_ORDER FOREIGN KEY (OrderId) REFERENCES dbo.[Order] (OrderId)
GO;

