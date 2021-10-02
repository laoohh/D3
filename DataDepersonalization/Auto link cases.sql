Declare @Case_CaseNumber  nvarchar(128),
	    @Case_CaseNumber2 nvarchar(128),
		@IR_CaseNumber nvarchar(128);

DECLARE @CaseCursor CURSOR;
DECLARE @IRCursor CURSOR;

DECLARE @Counter INT

SET NOCOUNT ON
DECLARE @Counter2 INT
SET @Counter2=1
WHILE ( @Counter2 <=1000 )
BEGIN
	SET @Counter=1

	BEGIN
		SET @CaseCursor = CURSOR FOR
		select top 10 CaseNumber from Cases4link order by caseID desc

		OPEN @CaseCursor 
		FETCH NEXT FROM @CaseCursor 
		INTO @Case_CaseNumber
		delete from Cases4link where Cases4link.CaseNumber = @Case_CaseNumber;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			  FETCH NEXT FROM @CaseCursor 
			  INTO @Case_CaseNumber2 

			  /*
				 YOUR ALGORITHM GOES HERE   
			  */
			  exec spDT_Link 1, @Case_CaseNumber, @Case_CaseNumber2;

			  delete from Cases4link where Cases4link.CaseNumber = @Case_CaseNumber2;

			  set @Case_CaseNumber = @Case_CaseNumber2

			  PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
			  SET @Counter  = @Counter  + 1


		END; 

		CLOSE @CaseCursor ;
		DEALLOCATE @CaseCursor;
	END;




    PRINT 'The counter2 value is = ' + CONVERT(VARCHAR,@Counter2)
    SET @Counter2  = @Counter2  + 1
END




