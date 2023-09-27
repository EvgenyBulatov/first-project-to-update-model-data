-- Создание таблицы для расчета фактора monetary_value для пользователей

CREATE TABLE analysis.tmp_rfm_monetary_value (
 user_id INT NOT NULL PRIMARY KEY,
 monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

-- Запрос для заполнения получившейся таблицы

INSERT INTO analysis.tmp_rfm_monetary_value (user_id, monetary_value)
SELECT user_id, range FROM (select user_id, ntile(5) over (order by sum(payment) asc) as range 
from analysis.Orders as o inner join analysis.OrderStatuses as os
on o.status = os.id
where os.key = 'Closed'
group by user_id) AS subquery1;

