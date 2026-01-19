CREATE VIEW cor_way_kindname AS
SELECT cor_way_kind.*,
       contact_kind.name as name_kind #
FROM cor_way_kind,
     contact_kind #
WHERE cor_way_kind.kind_id = contact_kind.id;

/* The following view used for an exercise in the training book */
CREATE VIEW item_display AS
SELECT item.id,
       item.invoice_id,
       item.product_id,
       item.category_id,
       product.name,
       item.qty,
       product.unitprice       as unitprice,
       qty * product.unitprice AS amount
FROM item,
     product
WHERE item.product_id = product.id;

# mysql> select * from item_display;
# +----+------------+------------+-------------+--------+------+-----------+------------------+--------+
# | id | invoice_id | product_id | category_id | name   | qty  | unitprice | unitprice_master | amount |
# +----+------------+------------+-------------+--------+------+-----------+------------------+--------+
# |  1 |          1 |          1 |        NULL | Apple  |   12 |      NULL |              340 |   4080 |
# |  2 |          1 |          2 |        NULL | Orange |   12 |      1340 |             1540 |  16080 |
# |  3 |          1 |          3 |        NULL | Melon  |   12 |      NULL |             3840 |  46080 |
# |  6 |          3 |          3 |        NULL | Melon  |   12 |      NULL |             3840 |  46080 |
# |  4 |          2 |          4 |        NULL | Tomato |   12 |      NULL |             2440 |  29280 |
# |  5 |          2 |          5 |        NULL | Onion  |   12 |      NULL |            21340 | 256080 |
# +----+------------+------------+-------------+--------+------+-----------+------------------+--------+
# 6 rows in set (0.00 sec)

CREATE VIEW saleslog_summary AS
SELECT SUBSTRING(customer, 1, 1) AS customer,
       SUBSTRING(item, 1, 1)     AS item,
       SUM(qty)                  AS qty,
       SUM(total)                AS total
FROM saleslog
GROUP BY SUBSTRING(customer, 1, 1), SUBSTRING(item, 1, 1);

