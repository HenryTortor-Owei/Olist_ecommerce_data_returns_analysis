ALTER TABLE sellers
ADD COLUMN seller_name VARCHAR(20);

SET @row_num = 0;

UPDATE sellers
SET seller_name = CONCAT('Seller_', LPAD((@row_num := @row_num + 1), 3, '0'))
ORDER BY seller_id;

SELECT seller_id, seller_name
FROM sellers
where seller_name = 'Seller_001';



