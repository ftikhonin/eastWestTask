--Заполним таблицы тестовыми данными
EXEC dbo.createTestOrders @dayOfWeek = 1 --День недели, на который создавать заказ(1-пн, 2-вт и тд)
                        , @cnt = 1000 --количество заказов
                        , @year = 2001 --год, в котором создать заказы
