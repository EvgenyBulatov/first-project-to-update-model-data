-- Запрос для создания представления из схемы 'production' в схему 'analysis' для таблицы 'orderstatuslog'

CREATE VIEW analysis.orderstatuslog AS
SELECT * FROM production.orderstatuslog;

-- Запрос для получения статуса заказа 

select ft.order_id, st.status_id 
from (select order_id, max(dttm) as last_order from analysis.orderstatuslog
group by order_id) as ft inner join analysis.orderstatuslog as st
on ft.order_id = st.order_id and ft.last_order = st.dttm;

-- Ранее мы уже создавали представление для 'Orders' в схеме 'analysis'. Однако теперь для восстановления работоспособности необходимо заново добавить колонку со статусом заказа в представление, поскольку все последующие запросы обращаются к этому предтставлению. --> Запрос для дополнения предстваления:

CREATE VIEW analysis.Orders_test AS
SELECT * FROM production.Orders;

alter VIEW analysis.Orders AS
select ao.*, dt.status
from analysis.Orders_test as ao
inner join dop_tbl as dt 
on ao.order_id = dt.id



