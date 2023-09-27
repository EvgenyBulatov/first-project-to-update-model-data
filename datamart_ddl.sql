-- Создание итоговой таблицы для заполнения данных из промежуточных таблиц

CREATE TABLE analysis.tmp_rfm_segments (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5),
 frequency INT NOT NULL CHECK(recency >= 1 AND recency <= 5),
 monetary_value INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);

-- Запрос для объединения данных из таблиц analysis.tmp_rfm_recency, analysis.tmp_rfm_frequency и analysis.tmp_rfm_monetary_value

select af.user_id, ar.recency, af.frequency, mv.monetary_value
from analysis.tmp_rfm_frequency as af
inner join analysis.tmp_rfm_recency as ar on af.user_id = ar.user_id
inner join analysis.tmp_rfm_monetary_value as mv on ar.user_id = mv.user_id

--Запрос, кооторый вставит данные id пользователей и соответствующие им значения RFM в итоговую таблицу

INSERT INTO analysis.tmp_rfm_segments ( user_id, recency, frequency, monetary_value)
select af.user_id, ar.recency, af.frequency, mv.monetary_value
from analysis.tmp_rfm_frequency as af
inner join analysis.tmp_rfm_recency as ar on af.user_id = ar.user_id
inner join analysis.tmp_rfm_monetary_value as mv on ar.user_id = mv.user_id

-- Ниже представлены первые 10 строк полученной таблицы, отсортированные по 'user_id'.

user_id / recency / frequency / monetary_value
0	1	3	4
1	4	3	3
2	2	3	5
3	2	3	3
4	4	3	3
5	5	5	5
6	1	3	5
7	4	3	2
8	1	1	3
9	1	2	2


