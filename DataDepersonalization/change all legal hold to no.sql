
Declare @Case_CaseNumber nvarchar(128),
		@DayMovedAhead int = 14;

DECLARE @MyCursor CURSOR;

BEGIN
    SET @MyCursor = CURSOR FOR
    select CaseNumber from LegalHoleCases where CaseNumber>'210800071922' order by CaseID desc

    OPEN @MyCursor 
    FETCH NEXT FROM @MyCursor 
    INTO @Case_CaseNumber

    WHILE @@FETCH_STATUS = 0
    BEGIN
      /*
         YOUR ALGORITHM GOES HERE   
      */
	  exec spdt_updatetestcase @Case_CaseNumber, '2018-04-24 20:39:17.280', 'No'
	  update h set h.HistoryUTC=dateadd(day, -@DayMovedAhead, h.HistoryUTC)
      from Ncase a
	  join NCaseHistory h on a.CaseID=h.CaseID
	  where a.CaseNumber=@Case_CaseNumber


      FETCH NEXT FROM @MyCursor 
      INTO @Case_CaseNumber 
    END; 

    CLOSE @MyCursor ;
    DEALLOCATE @MyCursor;
END;





