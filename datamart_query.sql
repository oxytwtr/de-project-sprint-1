insert into analysis.dm_rfm_segments (user_id, recency, frequency, monetary_value)
select trr.user_id,
	trr.recency,
	trf.frequency,
	trmv.monetary_value 
from analysis.tmp_rfm_recency trr 
inner join analysis.tmp_rfm_frequency trf on trr.user_id = trf.user_id 
inner join analysis.tmp_rfm_monetary_value trmv on trr.user_id = trmv.user_id;
/*
Первые 10 строк результирующей таблицы dm_rfm_segments, отсортированные по user_id ASC
0	1	3	4
1	4	3	3
2	2	3	5
3	2	3	3
4	4	3	3
5	5	5	5
6	1	3	5
7	4	2	2
8	1	1	3
9	1	3	2
*/