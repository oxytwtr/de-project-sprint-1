-- Вариант с ранжированием через NTILE()
with 
query as (
select user_id,
	count(order_ts) as frequency_src
from analysis.view_orders
where status = (select id from analysis.view_orderstatuses where key='Closed') and 
extract(year from order_ts) >= 2022
group by user_id
)
insert into analysis.tmp_rfm_frequency (user_id, frequency)
select u.id as user_id,
	ntile(5) over(
		order by coalesce (frequency_src, 0) asc
		) as frequency
from query
full outer join production.users u on query.user_id = u.id;
/* Вариант с case для истории
with 
query as (
select user_id,
	count(order_ts) as frequency_src
from analysis.view_orders
where status = (select id from analysis.view_orderstatuses where key='Closed') and
extract(year from order_ts) >= 2022
group by user_id
)
insert into analysis.tmp_rfm_frequency (user_id, frequency)
select u.id as user_id,
	case
		when ROW_NUMBER() OVER (order by coalesce (frequency_src, 0) ASC) <= 200 then 1
		when ROW_NUMBER() OVER (order by coalesce (frequency_src, 0) ASC) <= 400 then 2
		when ROW_NUMBER() OVER (order by coalesce (frequency_src, 0) ASC) <= 600 then 3
		when ROW_NUMBER() OVER (order by coalesce (frequency_src, 0) ASC) <= 800 then 4
		else 5 
	end as frequency
from query
full outer join production.users u on query.user_id = u.id;
*/