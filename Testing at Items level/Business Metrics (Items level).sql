/*
Use this table to 
compute order_binary for the 30 day window after the test_start_date
for the test named item_test_2
*/

SELECT test_assignment,
       COUNT(DISTINCT item_id) AS number_of_items,
       SUM(order_binary) AS items_ordered_30d
FROM
  (SELECT item_test_2.item_id,
          item_test_2.test_assignment,
          item_test_2.test_number,
          item_test_2.test_start_date,
          item_test_2.created_at,
          MAX(CASE
                  WHEN (created_at > test_start_date
                        AND DATE_PART('day', created_at - test_start_date) <= 30) THEN 1
                  ELSE 0
              END) AS order_binary
   FROM
     (SELECT final_assignments.*,
             DATE(orders.created_at) AS created_at
      FROM dsv1069.final_assignments AS final_assignments
      LEFT OUTER JOIN dsv1069.orders AS orders
        ON final_assignments.item_id = orders.item_id
        WHERE test_number = 'item_test_2') AS item_test_2   /* for item test 2 */
   GROUP BY item_test_2.item_id,
            item_test_2.test_assignment,
            item_test_2.test_number,
            item_test_2.test_start_date,
            item_test_2.created_at) AS order_binary
GROUP BY test_assignment;
