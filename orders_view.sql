CREATE OR REPLACE VIEW analysis.view_orders
AS 
with
status_last as(
select order_id, status_id 
from (select *,
	row_number() over(partition by order_id order by dttm DESC) as row_number
from production.OrderStatusLog
) as query
where row_number = 1
)
select o.order_id,
	o.order_ts,
	o.user_id,
	o.bonus_payment,
	o.payment,
	o."cost",
	o.bonus_grant,
	status_last.status_id as status
from production.orders o 
left join status_last on o.order_id = status_last.order_id;