declare @noOfEmp int
set @noOfEmp = (select count(*) from employee)
declare @noOfOrders int
set @noOfOrders = (select count(*) from cust_order)
declare @counter int
set @counter = 0
declare @bolen int
set @bolen = @noOfOrders / @noOfEmp + 1


WHILE(@counter < @bolen)
BEGIN
	WITH employee_rows AS(
		SELECT e.employee_id, ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
		FROM employee e),
	custorder_rows AS(
		SELECT co.order_id, ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
		FROM cust_order co
		WHERE co.employee_id is NULL
		)
	UPDATE co SET co.employee_id = er.employee_id
	FROM employee_rows er, custorder_rows cor, cust_order co
	WHERE er.rn = cor.rn AND co.order_id = cor.order_id

	set @counter = @counter + 1
END