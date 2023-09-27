-- Создание таблицы для расчета фактора Recency для пользователей

CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);


-- Ниже предствален подзапрос, который отбирает из общего количества клиентов только тех, кто имеет в истории компании хотя бы один выполненый до конца заказ. Запрос также ранжирует их при помощи оконной функции пок ритерии относительной недавности заказа. Наибольший ранг имеет те клиенты, которые делали заказ недавно.

with tbl_with_rank as (select ao.user_id as user_id , max(ao.order_ts), row_number() over (order by max(ao.order_ts)) as range, ao.status as stat
from analysis.Orders as ao
right join analysis.Users as au on ao.user_id = au.id
left join analysis.OrderStatuses as os on os.id = ao.status 
where os.key = 'Closed'
group by ao.user_id, ao.status)

-- Далее необходимо проранжировать оставшихся клиентов, что мы делаем в ручную, так как они не выполнили ни одного заказа. При помощи оператора 'union' собираем всех клиентов с рангами в единую таблицу.

select user_id, range from tbl_with_rank
union 
select id, '1' as range
from analysis.Users
where id not in (select user_id from tbl_with_rank)
order by range desc;

-- Запрос для ранжирования данных на 5 групп сиходя из последней активности (выполненного заказа)

select user_id, ntile(5) over (order by rank) as range
from (select user_id, rank from tbl_with_rank
union 
select id, '1' as rank
from analysis.Users
where id not in (select user_id from tbl_with_rank)
order by rank desc) as t

-- Запрос для заполнения таблица

INSERT INTO analysis.tmp_rfm_recency (user_id, recency)
select user_id, ntile(5) over (order by rank) as range
from (select user_id, rank from tbl_with_rank
union 
select id, '1' as rank
from analysis.Users
where id not in (select user_id from tbl_with_rank)
order by rank desc) as t
