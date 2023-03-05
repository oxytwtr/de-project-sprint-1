# 1.3. Качество данных

## Оценка качественности данных хранящихся в источнике.
Для оценки качества данных применялся анализ сформированных DBeaver DDL запросов, создающих таблицы, и гистограммы распределения значений в таблице с основными данными: production.orders

![Гистограммы значений полей таблицы ORDERS](https://github.com/oxytwtr/de-project-sprint-1/raw/main/images/orders_hist.png)

## Инструменты, обеспечивающие качество данных в источнике.
Описание полей таблиц:
- `Наименование таблицы` - наименование таблицы, объект которой рассматривается.
- `Объект` - Название объекта в таблице, на который применён инструмент, в виде записи из DDL 
- `Инструмент` - тип инструмента: первичный ключ, ограничение и.т.д.
- `Для чего используется` - Функция инструмента.

| Таблица                   | Объект                                                                                                   | Инструмент     | Для чего используется                                                                                                                    |
|:--------------------------|:---------------------------------------------------------------------------------------------------------|:---------------|:-----------------------------------------------------------------------------------------------------------------------------------------|
| production.products       | id int NOT NULL PRIMARY KEY                                                                              | Первичный ключ | Обеспечивает уникальность записей о пользователях<br>Ограничивает наличие пропусков в поле `id`                                          |
| production.products       | "name" varchar(2048) NOT NULL                                                                            | Ограничение    | Ограничивает наличие пропусков в поле `name`                                                                                             |
| production.products       | price numeric(19, 5) NOT NULL DEFAULT 0                                                                  | Ограничение    | Ограничивает наличие пропусков в поле `price`<br>Устанавливает значение по умолчанию = 0                                                 |
| production.products       | CONSTRAINT products_price_check CHECK ((price >= (0)::numeric))                                          | Ограничение    | Ограничивает значение поля `price` формулой `price >= 0`                                                                                 |
| ---                       | ---                                                                                                      | ---            | ---                                                                                                                                      |
| production.orderitems     | id int4 NOT NULL PRIMARY KEY                                                                             | Первичный ключ | Обеспечивает уникальность записей о позиции в заказе<br>Ограничивает наличие пропусков в поле `id`                                       |
| production.orderitems     | product_id int4 NOT NULL                                                                                 | Ограничение    | Ограничивает наличие пропусков в поле `product_id`                                                                                       |
| production.orderitems     | order_id int4 NOT NULL                                                                                   | Ограничение    | Ограничивает наличие пропусков в поле `order_id`                                                                                         |
| production.orderitems     | "name" varchar(2048) NOT NULL                                                                            | Ограничение    | Ограничивает наличие пропусков в поле `name`                                                                                             |
| production.orderitems     | price numeric(19, 5) NOT NULL DEFAULT 0                                                                  | Ограничение    | Ограничивает наличие пропусков в поле `price`<br>Устанавливает значение по умолчанию = 0                                                 |
| production.orderitems     | discount numeric(19, 5) NOT NULL DEFAULT 0                                                               | Ограничение    | Ограничивает наличие пропусков в поле `discount`<br>Устанавливает значение по умолчанию = 0                                              |
| production.orderitems     | quantity int4 NOT NULL                                                                                   | Ограничение    | Ограничивает наличие пропусков в поле `quantity`                                                                                         |
| production.orderitems     | CONSTRAINT orderitems_check CHECK (((discount >= (0)::numeric) AND (discount <= price)))                 | Ограничение    | Ограничивает значение поля `discount` формулой `price >= 0`<br>и формулой `discount <= price`                                            |
| production.orderitems     | CONSTRAINT orderitems_order_id_product_id_key UNIQUE (order_id, product_id)                              | Ограничение    | Обеспечивает уникальность комбинации пар значений `order_id - product_id`                                                                |
| production.orderitems     | CONSTRAINT orderitems_price_check CHECK ((price >= (0)::numeric))                                        | Ограничение    | Ограничивает значение поля `price` формулой `price >= 0`                                                                                 |
| production.orderitems     | CONSTRAINT orderitems_quantity_check CHECK ((quantity > 0))                                              | Ограничение    | Ограничивает значение поля `quantity` формулой `quantity > 0`                                                                            |
| production.orderitems     | CONSTRAINT orderitems_order_id_fkey FOREIGN KEY (order_id) REFERENCES production.orders(order_id)        | Внешний ключ   | Устанавливает возможность добавления значений в поле `order_id` <br>только из существующих значений в поле `order_id` таблицы `orders`   |
| production.orderitems     | CONSTRAINT orderitems_product_id_fkey FOREIGN KEY (product_id) REFERENCES production.products(id)        | Внешний ключ   | Устанавливает возможность добавления значений в поле `product_id` <br>только из существующих значений в поле `id` таблицы `products`     |
| ---                       | ---                                                                                                      | ---            | ---                                                                                                                                      |
| production.orders         | order_id int4 NOT NULL PRIMARY KEY                                                                       | Первичный ключ | Обеспечивает уникальность записей о заказе<br>Ограничивает наличие пропусков в поле `order_id`                                           |
| production.orders         | order_ts timestamp NOT NULL                                                                              | Ограничение    | Ограничивает наличие пропусков в поле `order_ts`                                                                                         |
| production.orders         | user_id int4 NOT NULL                                                                                    | Ограничение    | Ограничивает наличие пропусков в поле `user_id`                                                                                          |
| production.orders         | bonus_payment numeric(19, 5) NOT NULL DEFAULT 0                                                          | Ограничение    | Ограничивает наличие пропусков в поле `bonus_payment`<br>Устанавливает значение по умолчанию = 0                                         |
| production.orders         | payment numeric(19, 5) NOT NULL DEFAULT 0                                                                | Ограничение    | Ограничивает наличие пропусков в поле `payment`<br>Устанавливает значение по умолчанию = 0                                               |
| production.orders         | "cost" numeric(19, 5) NOT NULL DEFAULT 0                                                                 | Ограничение    | Ограничивает наличие пропусков в поле `cost`<br>Устанавливает значение по умолчанию = 0                                                  |
| production.orders         | bonus_grant numeric(19, 5) NOT NULL DEFAULT 0,                                                           | Ограничение    | Ограничивает наличие пропусков в поле `bonus_grant`<br>Устанавливает значение по умолчанию = 0                                           |
| production.orders         | status int4 NOT NULL                                                                                     | Ограничение    | Ограничивает наличие пропусков в поле `status`                                                                                           |
| production.orders         | CONSTRAINT orders_check CHECK ((cost = (payment + bonus_payment)))                                       | Ограничение    | Ограничивает значение поля `cost` формулой `cost = payment + bonus_payment`                                                              |
| ---                       | ---                                                                                                      | ---            | ---                                                                                                                                      |
| production.orderstatuses  | id int4 NOT NULL PRIMARY KEY                                                                             | Первичный ключ | Обеспечивает уникальность записей о типе статуса заказа<br>Ограничивает наличие пропусков в поле `id`                                    |
| production.orderstatuses  | "key" varchar(255) NOT NULL                                                                              | Ограничение    | Ограничивает наличие пропусков в поле `key`                                                                                              |
| ---                       | ---                                                                                                      | ---            | ---                                                                                                                                      |
| production.orderstatuslog | id int4 NOT NULL PRIMARY KEY                                                                             | Первичный ключ | Обеспечивает уникальность записей о идентификаторе установки статуса заказа<br>Ограничивает наличие пропусков в поле `id`                |
| production.orderstatuslog | order_id int4 NOT NULL                                                                                   | Ограничение    | Ограничивает наличие пропусков в поле `order_id`                                                                                         |
| production.orderstatuslog | status_id int4 NOT NULL                                                                                  | Ограничение    | Ограничивает наличие пропусков в поле `status_id`                                                                                        |
| production.orderstatuslog | dttm timestamp NOT NULL                                                                                  | Ограничение    | Ограничивает наличие пропусков в поле `dttm`                                                                                             |
| production.orderstatuslog | CONSTRAINT orderstatuslog_order_id_status_id_key UNIQUE (order_id, status_id)                            | Ограничение    | Обеспечивает уникальность комбинации пар значений `order_id - status_id`                                                                 |
| production.orderstatuslog | CONSTRAINT orderstatuslog_order_id_fkey FOREIGN KEY (order_id) REFERENCES production.orders(order_id)    | Внешний ключ   | Устанавливает возможность добавления значений в поле `order_id` <br>только из существующих значений в поле `order_id` таблицы `orders`   |
| production.orderstatuslog | CONSTRAINT orderstatuslog_status_id_fkey FOREIGN KEY (status_id) REFERENCES production.orderstatuses(id) | Внешний ключ   | Устанавливает возможность добавления значений в поле `status_id` <br>только из существующих значений в поле `id` таблицы `orderstatuses` |
| ---                       | ---                                                                                                      | ---            | ---                                                                                                                                      |
| production.users          | id int4 NOT NULL PRIMARY KEY                                                                             | Первичный ключ | Обеспечивает уникальность записей о идентификаторе пользователя<br>Ограничивает наличие пропусков в поле `id`                            |
| production.users          | login varchar(2048) NOT NULL                                                                             | Ограничение    | Ограничивает наличие пропусков в поле `login`                                                                                            |