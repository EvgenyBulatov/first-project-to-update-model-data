# Итоговый проект 1-го спринта

###1.1. Выясните требования к целевой витрине

Итоговая витрина имеет название dm_rfm_segments и располагается в базе данных «localhost» в схеме analysis. Периодическое обновление данных в витрине не предусмотрено.
Витрина состоит из следующих полей:

    * user_id
    * recency (число от 1 до 5)
    * frequency (число от 1 до 5)
    * monetary_value (число от 1 до 5)

Каждого клиента оценивали по трём факторам:
    * Recency (пер. «давность») — сколько времени прошло с момента последнего заказа.
    * Frequency (пер. «частота») — количество заказов.
    * Monetary Value (пер. «денежная ценность») — сумма затрат клиента.
      
      Фактор Recency измеряется по последнему заказу. Распределите клиентов по шкале от одного до пяти, где значение 1 получат те, кто либо вообще не делал заказов, либо делал их очень давно, а 5 — те, кто заказывал относительно недавно.
      Фактор Frequency оценивается по количеству заказов. Распределите клиентов по шкале от одного до пяти, где значение 1 получат клиенты с наименьшим количеством заказов, а 5 — с наибольшим.
      Фактор Monetary Value оценивается по потраченной сумме. Распределите клиентов по шкале от одного до пяти, где значение 1 получат клиенты с наименьшей суммой, а 5 — с наибольшей.
      
###1.2. Изучите структуру исходных данных

В базе данных в схеме «production» хранятся таблицы: orderitems, orders, orderstatuses, orderstatuslog, products, users.

Отношение orderitems содержит следующие атрибуты:
    * id (int4)
    * product_id (int4)
    * order_id (int4)
    * name (varchar(2048))
    * price (numeric(19,5))
    * discount (numeric(19,5))
    * quantity (int4)
Отношение orders содержит следующие атрибуты:
    * order_id (int4)
    * order_ts (timestamp)
    * user_id (int4)
    * bonus_payment (numeric(19,5))
    * payment (numeric(19,5))
    * cost (numeric(19,5))
    * bonus_grant (numeric(19,5))
    * status (int4)
Отношение  orderstatuses содержит следующие атрибуты:
    * id (int4)
    * key (varchar(255))
Отноiение orderstatuslog содержит следующие атрибуты:
    * id (int4)
    * order_id (int4)
    * status_id (int4) 
    * dttm (timestamp)
Отношение products содержит следующие атрибуты:
    * id (int4)
    * name (varchar(2048))
    * price (numeric(19,5))
Отношение users содержит следующие атрибуты:
    * id (int4)
    * name (varchar(2048))
    * login (varchar(2048))
    
###1.3. Проанализируйте качество данных:

Информация о качестве данных представлена в файле data_quality.md. 

###1.4. Подготовьте виторину данных:

Подготовка витрины данных предствалена в запросе из файла 'datamart_ddl.sql'

```
CREATE TABLE analysis.tmp_rfm_segments (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5),
 frequency INT NOT NULL CHECK(recency >= 1 AND recency <= 5),
 monetary_value INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);
```

###1.4.1. Сделайте VIEW для таблиц из базы production.

Со скриптом по созданию представлений можно ознаокмиться в файле 'views.sql'

```
CREATE VIEW analysis.Users AS
SELECT * FROM production.Users;

CREATE VIEW analysis.OrderItems AS
SELECT * FROM production.OrderItems;

CREATE VIEW analysis.OrderStatuses AS
SELECT * FROM production.OrderStatuses;

CREATE VIEW analysis.Products AS
SELECT * FROM production.Products;

CREATE VIEW analysis.Orders AS
SELECT * FROM production.Orders;
```

###1.4.2. Напишите DDL-запрос для создания витрины.

DDL-запросы для создания итоговой витрины и промежуточных витрин располагаются в файлах 'datamart_ddl.sql',
'tmp_rfm_frequency.sql', 'tmp_rfm_monetary_value.sql', 'tmp_rfm_recency.sql'

###1.4.3. Напишите SQL запрос для заполнения витрины.

Запрос представлен в файле 'datamart_ddl.sql'

```
INSERT INTO analysis.tmp_rfm_segments ( user_id, recency, frequency, monetary_value)
select af.user_id, ar.recency, af.frequency, mv.monetary_value
from analysis.tmp_rfm_frequency as af
inner join analysis.tmp_rfm_recency as ar on af.user_id = ar.user_id
inner join analysis.tmp_rfm_monetary_value as mv on ar.user_id = mv.user_id
```

