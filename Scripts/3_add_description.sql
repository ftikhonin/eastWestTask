
EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Филиалы компании'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Branch'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Идентификатор филиала'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Branch'
                               ,'COLUMN'
                               ,N'BranchId'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Наименование филиала'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Branch'
                               ,'COLUMN'
                               ,N'Name'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Клиенты компании, закрепленные за определенным филиалом'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Client'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Идентификатор клиента'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Client'
                               ,'COLUMN'
                               ,N'ClientId'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Наименование клиента'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Client'
                               ,'COLUMN'
                               ,N'Name'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Идентификатор филиала'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Client'
                               ,'COLUMN'
                               ,N'BranchId'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Товары'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Product'
GO

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Идентификатор товара'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Product'
                               ,'COLUMN'
                               ,N'ProductId'
GO

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Наименование товара'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Product'
                               ,'COLUMN'
                               ,N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Источники поступлений заказов'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Source'
GO

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Идентификатор источника заказа'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Source'
                               ,'COLUMN'
                               ,N'SourceId'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Наименование источника заказа'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Source'
                               ,'COLUMN'
                               ,N'Name'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Единицы измерений'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Unit'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Идентификатор единицы измерений'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Unit'
                               ,'COLUMN'
                               ,N'UnitId'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Краткое наименование единицы измерения(кг, шт, л)'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Unit'
                               ,'COLUMN'
                               ,N'ShortName'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Полное наименование единицы измерения(Килограмм, Штук, Литр)'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Unit'
                               ,'COLUMN'
                               ,N'FullName'
GO;


EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Форматы данных'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'Unit'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Идентификатор формата данных'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'DataType'
                               ,'COLUMN'
                               ,N'DataTypeId'
GO;

EXEC sys.sp_addextendedproperty N'MS_Description'
                               ,'Наименование формата данных(xlsx,xml,csv,json)'
                               ,'SCHEMA'
                               ,N'dbo'
                               ,'TABLE'
                               ,N'DataType'
                               ,'COLUMN'
                               ,N'Name'
GO;
