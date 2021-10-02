SET NOCOUNT ON
DECLARE @Counter INT
SET @Counter=1
WHILE ( @Counter <=2000 )
BEGIN

	--1-- to create cases
	exec spDT_CreateTestCase2 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
	exec spDT_CreateTestCase2 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
	exec spDT_CreateTestCase2 'hun_amazon', 'hun_amazon', 'Close', '2018-07-24 22:06:17.280','No', 'Partially Substantiated'
	exec spDT_CreateTestCase2 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
	exec spDT_CreateTestCase2 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
	exec spDT_CreateTestCase2 'hun_amazon', 'hun_amazon', 'Close', '2018-07-24 22:06:17.280','No', 'Partially Substantiated'


	--2-- to create IRs
	--exec spDT_CreateTestIR2 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'


	--3-- to create E-Alert
	--For example, 
	--exec spDT_CreateTestEIR2 'hun_amazon', 'laxsubl', '2007-06-24 17:31:17.280'   --archived E-Alert
	--exec spDT_CreateTestEIR2 'hun_amazon', 'laxsubl', '2007-06-24 17:31:17.280'   --archived E-Alert

	--WAITFOR DELAY '00:00:01'
    PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
    SET @Counter  = @Counter  + 1
END









