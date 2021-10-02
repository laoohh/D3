
Declare @IR_CaseNumber nvarchar(128),
		@IR_CaseNumber2 nvarchar(128);

DECLARE @IRCursor CURSOR;

DECLARE @Counter INT


SET NOCOUNT ON
DECLARE @Counter2 INT
SET @Counter2=1
WHILE ( @Counter2 <=1000 and @@FETCH_STATUS = 0)
BEGIN
	SET @Counter=1

	BEGIN
		SET @IRCursor = CURSOR FOR
		select top 10 CASE_NUMBER from IR4link order by IR_ID desc

		OPEN @IRCursor 
		FETCH NEXT FROM @IRCursor 
		INTO @IR_CaseNumber
		delete from IR4link where IR4link.CASE_NUMBER = @IR_CaseNumber;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			  FETCH NEXT FROM @IRCursor 
			  INTO @IR_CaseNumber2 

			  /*
				 YOUR ALGORITHM GOES HERE   
			  */

			  exec spDT_Link 3, @IR_CaseNumber,    @IR_CaseNumber2;

			  delete from IR4link where IR4link.CASE_NUMBER = @IR_CaseNumber2;

			  set @IR_CaseNumber = @IR_CaseNumber2

			  PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
			  SET @Counter  = @Counter  + 1

		END; 

		CLOSE @IRCursor ;
		DEALLOCATE @IRCursor;
	END;


    PRINT 'The counter2 value is = ' + CONVERT(VARCHAR,@Counter2)
    SET @Counter2  = @Counter2  + 1
END




