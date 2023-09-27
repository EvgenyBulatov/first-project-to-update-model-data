-- Создание таблицы для расчета фактора Frequency для пользователей

CREATE TABLE analysis.tmp_rfm_frequency (
 user_id INT NOT NULL PRIMARY KEY,
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);

-- Запрос для заполнения таблицы 

INSERT INTO analysis.tmp_rfm_frequency (user_id, frequency)
SELECT user_id, range FROM (SELECT user_id, count(*) AS cnt, ntile(5) OVER (ORDER BY count(*) ASC) AS range
FROM analysis.Orders as o inner join analysis.OrderStatuses as os
on o.status = os.id
where os.key = 'Closed'
GROUP BY user_id) AS subquery;
