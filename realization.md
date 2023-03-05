# Витрина RFM

## 1.1. Выясните требования к целевой витрине.

Постановка задачи выглядит достаточно абстрактно - постройте витрину. Первым делом вам необходимо выяснить у заказчика детали. Запросите недостающую информацию у заказчика в чате.

Зафиксируйте выясненные требования. Составьте документацию готовящейся витрины на основе заданных вами вопросов, добавив все необходимые детали.

-----------
<font size = 5, color=MediumAquamarine> Ответ студента</font> 
<font color= Ivory>
### **Что сделать:**

Построить витрину с данными для RFM-классификации пользователей приложения на основании данных о завершенных заказах (статус - "closed").


Витрину назвать `dm_rfm_segments` и разместить в схеме `analysis` базы данных `DE`


### **Назначение:**
Подготовить данные для компании разрабатывающей приложение для доставки еды. Необходима сегментация клиентов на основе данных их заказов для анализа лояльности клиентов. 

### **За какой период:**
Использовать данные с начала `2022 года по текущий момент` 

### **Обновление данных:**
Не требуется

### **Источник данных:**
В базе две схемы: `production` и `analysis`. В схеме `production` содержатся оперативные таблицы.

### **Права доступа:**
Не определено. Права доступа всем, на чтение.

### **Необходимая структура:**

- `user_id` - Идентификатор клиента
- `recency` - «давность» — фактор оценки прошедшего времени с момента последнего заказа. Значение шкалы в диапазоне [1..5], где 1 - наибольшее время с последнего заказа, 5 -наименьшее время с последнего заказа 
- `frequency` - «частота» — фактор оценки количества заказов за рассматриваемый период. Значение шкалы в диапазоне [1..5], где 1 - наименьшее кол-во заказов, 5 - наибольшее кол-во заказов.
- `monetary_value` - «денежная ценность» — фактор оценки потраченной клиентом суммы за рассматриваемый период. Значение шкалы в диапазоне [1..5], где 1 - наименьшая сумма затрат, 5 - наибольшая сумма затрат.

Количество клиентов в каждом сегменте должно быть одинаково. То есть распределение клиентов по шкалам - равномерное.
</font> 


## 1.2. Изучите структуру исходных данных.

Полключитесь к базе данных и изучите структуру таблиц.

Если появились вопросы по устройству источника, задайте их в чате.

Зафиксируйте, какие поля вы будете использовать для расчета витрины.

-----------

<font size = 5, color=MediumAquamarine> Ответ студента</font> 
<font color= Ivory>

В схеме production 6 таблиц, из которых 2 пустые
- orderitems - 47 369 строк, 
- orders - 10_000 строк,
- orderstatuses - 5 строк,
- orderstatuslog - 29_982 строк,
- products - 21 строка,
- users - 1_000 строк

Схема `production` базы данных `DE`

![Схема базы данных](https://github.com/oxytwtr/de-project-sprint-1/raw/main/images/schema.png)

Для расчета витрины будут использованы поля:

- [orders.status, orders.order_ts, orders.user_id, users.id] >> recency (давность)
- [orders.status, orders.order_ts, orders.user_id, users.id] >> frequency (частота)
- [orders.status, orders.payment, orders.user_id, users.id] >> monetary_value (частота)

</font> 


## 1.3. Проанализируйте качество данных

Изучите качество входных данных. Опишите, насколько качественные данные хранятся в источнике. Так же укажите, какие инструменты обеспечения качества данных были использованы в таблицах в схеме production.

-----------

<font size = 5, color=MediumAquamarine> Ответ студента</font> 
<font color= Ivory>

## Оценка качественности данных хранящихся в источнике.
Для оценки качества данных применялся анализ сформированных DBeaver DDL запросов, создающих таблицы, и гистограммы распределения значений в таблице с основными данными: production.orders

В требуемой для расчета витрины таблице `production.orders`
- пропуски остутствуют (для всех полей ограничение - NOT NULL)
- дубли в поле order_id отсутствуют, это первичный ключ, 10_000 уникальных номеров заказов
- для поля `cost` ограничение cost = payment + bonus_payment

![Гистограммы значений полей таблицы ORDERS](https://github.com/oxytwtr/de-project-sprint-1/raw/main/images/orders_hist.png)

## Инструменты, обеспечивающие качество данных в источнике.

Таблица с анализом инструментов представлена в файле [data_quality.md](https://raw.githubusercontent.com/oxytwtr/de-project-sprint-1/main/data_quality.md)

</font> 

## 1.4. Подготовьте витрину данных

Теперь, когда требования понятны, а исходные данные изучены, можно приступить к реализации.

### 1.4.1. Сделайте VIEW для таблиц из базы production.**

Вас просят при расчете витрины обращаться только к объектам из схемы analysis. Чтобы не дублировать данные (данные находятся в этой же базе), вы решаете сделать view. Таким образом, View будут находиться в схеме analysis и вычитывать данные из схемы production. 

Напишите SQL-запросы для создания пяти VIEW (по одному на каждую таблицу) и выполните их. Для проверки предоставьте код создания VIEW.

```SQL
CREATE OR REPLACE VIEW analysis.view_orderitems AS
        SELECT *
        FROM production.orderitems; 

CREATE OR REPLACE VIEW analysis.view_orders AS
        SELECT *
        FROM production.orders; 

CREATE OR REPLACE VIEW analysis.view_orderstatuses AS
        SELECT *
        FROM production.orderstatuses; 

CREATE OR REPLACE VIEW analysis.view_orderstatuslog AS
        SELECT *
        FROM production.orderstatuslog; 

CREATE OR REPLACE VIEW analysis.view_products AS
        SELECT *
        FROM production.products; 
```

### 1.4.2. Напишите DDL-запрос для создания витрины.**

Далее вам необходимо создать витрину. Напишите CREATE TABLE запрос и выполните его на предоставленной базе данных в схеме analysis.

```SQL
CREATE TABLE IF NOT EXISTS analysis.dm_rfm_segments (
	user_id int4 NOT NULL,
	recency smallint NOT NULL,	
	frequency smallint NOT NULL,
	monetary_value smallint NOT null,
	CONSTRAINT recency_check CHECK (((recency >= 1) AND (recency <= 5))),
	CONSTRAINT frequency_check CHECK (((frequency >= 1) AND (frequency <= 5))),
	CONSTRAINT monetary_value_check CHECK (((monetary_value >= 1) AND (monetary_value <= 5))),
	CONSTRAINT dm_rfm_segments_pkey PRIMARY KEY (user_id)
);
```

### 1.4.3. Напишите SQL запрос для заполнения витрины

Наконец, реализуйте расчет витрины на языке SQL и заполните таблицу, созданную в предыдущем пункте.

Для решения предоставьте код запроса.

```SQL
insert into analysis.dm_rfm_segments (user_id, recency, frequency, monetary_value)
select trr.user_id,
	trr.recency,
	trf.frequency,
	trmv.monetary_value 
from analysis.tmp_rfm_recency trr 
inner join analysis.tmp_rfm_frequency trf on trr.user_id = trf.user_id 
inner join analysis.tmp_rfm_monetary_value trmv on trr.user_id = trmv.user_id;
/*
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
-- Проверка количества строк
select count(*) from analysis.dm_rfm_segments;
-- output: 1000
-- Проверка количества уникальных записей user_id
select count(distinct(user_id)) from analysis.dm_rfm_segments;
-- output: 1000
```




