SET search_path TO imapp,public;

/*
CREATE VIEW item_display AS
    SELECT item.id, item.invoice_id, item.product_id, item.category_id, product.name, item.qty,
        item.unitprice, product.unitprice as unitprice_master,
        IF(item.unitprice is null, qty * product.unitprice, qty * item.unitprice) AS amount FROM item,
        product WHERE item.product_id=product.id;
*/

