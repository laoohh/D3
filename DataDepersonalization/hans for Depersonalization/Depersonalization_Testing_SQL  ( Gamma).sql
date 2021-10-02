--Test Starting Date 20210811  
--Test Environment local: Gamma

-- to test Data Depersonalization
-- there are 3 stored procedures to generate Case/IR/E-Alert with various type of attributes such as open/close, Legal hold, and Substantiated.
-- and there is 1 stored procedure to link case, IR or Ealert.

--Any user ID from a country that needs to be tested can be added. For this test purpose we set user laxsubl's Building to 'BRU10' (for testing), then
--PersonID	CAI	PersonTypeID Building country CountryISOCode	Country	Substantiated	Rules	Year	Month	Day
--10581852	LAXSUBL	2301	BRU10	Spain		ESP				Belgium	Yes				F+1		1		0		0
--10581852	LAXSUBL	2301	BRU10	Spain		ESP				Belgium	No				F+2M	0		2		0

-- Substantiated			Subedi,Laxmi	101597	BRU10	Belgium	F+1
-- Partially Substantiated	Subedi,Laxmi	101597	BRU10	Belgium	F+1
-- Unsubstantiated			Subedi,Laxmi	101597	BRU10	Belgium	F+2M

--1-- to create cases
--Run exec spDT_CreateTestCase ‘Creator’,'Owner','Open/Close','CloseDate',"LegalHold Yes/No',
--       'Substantiated/UnSubstantiated/Partially Substantiated' to generate a new Case. 
--For example, 
exec spDT_CreateTestCase 'hwanghan', 'laxsubl', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestCase 'hwanghan', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'hwanghan', 'hwanghan', 'Close', '2018-07-24 22:06:17.280','No', 'Partially Substantiated'

exec spDT_CreateTestCase 'hwanghan', 'hwanghan', 'Open',  '2011-06-24 17:31:17.280','No',  'Substantiated'
exec spDT_CreateTestCase 'hwanghan', 'hwanghan', 'Close', '2011-06-24 17:31:17.280','Yes', 'UnSubstantiated'


--2-- to create IRs
--Run exec spDT_CreateTestIR ‘Creator’, ‘Status’, ‘CloseDate’, ‘LegalHold Yes/No’ to generate a new IR. 
--For example, 
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'

exec spDT_CreateTestIR 'laxsubl', 'Open', '2011-06-24 17:31:17.280','No'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2011-06-24 17:31:17.280','Yes'


--3-- to create E-Alert
--Run exec spDT_CreateTestEIR ‘AssigneeUserName’, ‘ArchiveUserName’, ‘ArchiveDate’ to generate a new Archived E-Alert. 
--if ArchiveUserName and ArchiveDate are all NULL, will create an open E-Alert (not archived)
--For example, 
exec spDT_CreateTestEIR 'laxsubl', 'laxsubl', '2007-06-24 17:31:17.280'   --archived E-Alert

exec spDT_CreateTestEIR 'laxsubl',NULL, NULL  -- Open E-Alert


--run task scheduler Depersonalization here and verify the email
--should be 3 cases, 1 IR, and 1 E-Alert have been deleted and reported in the email 

--PASSED

--4-- to verify the retention period expiration
--case policy F+3 , 3 years (Substantiated)
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2020-08-12 22:15:17.280','No', 'Substantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2020-08-12 22:25:17.280','No', 'Substantiated'

--case policy F+3 , 3 years (Patially Substantiated)
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2020-08-12 22:15:17.280','No', 'Partially Substantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2020-08-12 22:25:17.280','No', 'Partially Substantiated'

--case policy F+3M , 3 months (UnSubstantiated)
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2021-06-12 22:15:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2021-06-12 22:25:17.280','No', 'UnSubstantiated'

--IR policy F+3 , 3 years (IR always use Substantiated policy)
exec spDT_CreateTestIR 'laxsubl', 'Close', '2020-08-12 22:15:17.280','No'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2020-08-12 22:25:17.280','No'

--Archived E-Alert policy F+3M , 3 months ( E-Alert always use UnSubstantiated policy)
exec spDT_CreateTestEIR 'laxsubl', 'hwanghan', '2021-06-12 22:15:17.280'   --archived E-Alert
exec spDT_CreateTestEIR 'laxsubl', 'hwanghan', '2021-06-12 22:25:17.280'   --archived E-Alert


--run task scheduler Depersonalization here and verify the email
--there should be 2 cases, 1 IR, 1 E-Alert deleted, and could verify the CaseNumbers

--PASSED

--5-- Link between Case/IR and Escalate from E-Alert to Case/IR
-- Run exec spDT_Link type1/2/3/4/5, 'Number1', 'Number2' to link Number1 to Number2
-- Type options: 1 CaseLinkCase; 2 CaseLinkIR; 3 IRLinkIR; 4 E-Alert Escalate to Case; 5 E-Alert Escalate to IR

-- For example, type 1 CaseLinkCase,

-- generate 2 closed cases first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestCase 'laxsubl', 'hun_amazon', 'Close', '2021-04-27 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 1, '20210812-1543', '20210812-1544'    -- type 1 - CaseLinkCase

-- generate 1 closed and 1 open cases first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hun_amazon', 'Close', '2018-07-24 22:06:17.280','No', 'Partially Substantiated'
exec spDT_CreateTestCase 'laxsubl', 'hun_amazon', 'Open',  '2011-06-24 17:31:17.280','No',  'Substantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 1, '20210812-1545', '20210812-1546'    -- type 1 - CaseLinkCase

-- generate 1 closed and 1 Legal Hold cases first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2021-04-26 23:00:00.280','Yes', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 1, '20210812-1547', '20210812-1548'    -- type 1 - CaseLinkCase


--run task scheduler Depersonalization here and verify the email
--should be 2 cases have been deleted and reported in the email, case numbers can be verified

--PASSED

--6--  type 2 CaseLinkIR
-- generate 1 closed case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '20210812-1549', '20210812-905'   --2 CaseLinkIR


-- generate 1 closed case and 1 open IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '20210812-1550', '20210812-906'   --2 CaseLinkIR

-- generate 1 closed case and 1 Legal Hold IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '20210812-1551', '20210812-907'   --2 CaseLinkIR

-- generate 1 open case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Open', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '20210812-1552', '20210812-908'   --2 CaseLinkIR

-- generate 1 Legal Hold case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','Yes', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '20210812-1553', '20210812-909'   --2 CaseLinkIR


--run task scheduler Depersonalization here and verify the email
--should be only the linked 1 closed cases and 1 closed IR have been deleted and reported in the email
--case number and IR number can be verified

--PASSED


--7--  type 3 IRLinkIR
-- generate 2 closed IRs first, then link them 
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 3, '20210812-910', '20210812-911'    --3 IRLinkIR

-- generate 1 closed IR and 1 open IR first, then link them 
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'laxsubl', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 3, '20210812-912', '20210812-913'    --3 IRLinkIR

-- generate 1 closed IR and 1 Legal Hold IR first, then link them 
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 3, '20210812-914', '20210812-915'    --3 IRLinkIR


--run task scheduler Depersonalization here and verify the email
--should be the linked 2 closed IR have been deleted and reported in the email
--IR numbers can be verified

--PASSED

--8-- type 4 E-Alert Escalate to Case
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '120821-353', '20210812-1554'    --4 E-Alert Escalate to Case

-- generate 1 open E-Alert and 1 open case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Open', '2018-04-24 20:39:17.280','No', 'Substantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '120821-354', '20210812-1555'    --4 E-Alert Escalate to Case


-- generate 1 open E-Alert and 1 Legal Hold case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','Yes', 'Substantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '120821-355', '20210812-1556'    --4 E-Alert Escalate to Case


--run task scheduler Depersonalization here and verify the email
--should be only 1 E-Alert and 1 closed case have been deleted and reported in the email
-- E-Alert and case numbers can be verified

--PASSED

--9-- type 5 E-Alert Escalate to IR
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '120821-356', '20210812-916'    --5 EAlertLinkIR


-- generate 1 open E-Alert and 1 open IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '120821-357', '20210812-917'    --5 EAlertLinkIR

-- generate 1 open E-Alert and 1 open IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '120821-358', '20210812-918'    --5 EAlertLinkIR


--run task scheduler Depersonalization here and verify the email
--should be only 1 E-Alert and 1 closed IR have been deleted and reported in the email
-- E-Alert and IR numbers can be verified

--PASSED


--10-- update close date and legal hold attribute

-- update case: exec spdt_updatetestcase 'Case Number', 'Close Date', 'Legal Hold Yes/No'
-- for exsample
--              exec spdt_updatetestcase '210727000012', '2001-11-09', 'No'

-- update IR:   exec spDT_UpdateTestIR 'IR Case Number', 'Close Date', 'Legal Hold Yes/No'
-- for exsample
--              exec spDT_UpdateTestIR '20210727-7', '2008-02-09', 'No'


-- Legal Hold in above tests------

exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2021-04-26 23:00:00.280','Yes', 'UnSubstantiated'
exec spDT_Link 1, '20210812-1547', '20210812-1548'    -- type 1 - CaseLinkCase
--set Legal Hold to No
exec spdt_updatetestcase '20210812-1548', '2018-04-24 20:39:17.280', 'No'

-- generate 1 closed case and 1 Legal Hold IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'
exec spDT_Link 2, '20210812-1551', '20210812-907'   --2 CaseLinkIR
--set Legal Hold to No
exec spDT_UpdateTestIR '20210812-907', '2018-04-24 20:39:17.280', 'No'


-- generate 1 Legal Hold case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','Yes', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_Link 2, '20210812-1553', '20210812-909'   --2 CaseLinkIR
--set Legal Hold to No
exec spdt_updatetestcase '20210812-1553', '2018-04-24 20:39:17.280', 'No'


-- generate 1 closed IR and 1 Legal Hold IR first, then link them 
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'
exec spDT_Link 3, '20210812-914', '20210812-915'    --3 IRLinkIR
--set Legal Hold to No
exec spDT_UpdateTestIR '20210812-915', '2018-04-24 20:39:17.280', 'No'

-- generate 1 open E-Alert and 1 Legal Hold case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','Yes', 'Substantiated'
exec spDT_Link 4, '120821-360', '20210813-1564'    --4 E-Alert Escalate to Case
--set Legal Hold to No
exec spdt_updatetestcase '20210813-1564', '2018-04-24 20:39:17.280', 'No'



-- generate 1 open E-Alert and 1 open IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'
exec spDT_Link 5, '120821-361', '20210813-919'    --5 EAlertLinkIR
--set Legal Hold to No
exec spDT_UpdateTestIR '20210813-919', '2018-04-24 20:39:17.280', 'No'

--run task scheduler Depersonalization here and verify the email
--should be only 1 E-Alert and 1 closed IR have been deleted and reported in the email
-- E-Alert and IR numbers can be verified

--PASSED


--11-- change legal hold history to 14 days before
-- Case
Declare @Case_CaseNumber nvarchar(128) ='20210813-1564', -- Case Case number
		@DayMovedAhead int = 14  -- Number of days to move history date time ahead

update h set h.HistoryUTC=dateadd(day, -@DayMovedAhead, h.HistoryUTC)
from Ncase a
join NCaseHistory h on a.CaseID=h.CaseID
where a.CaseNumber=@Case_CaseNumber

------------------
Declare @Case_CaseNumber nvarchar(128) ='20210812-1553', -- Case Case number
		@DayMovedAhead int = 14  -- Number of days to move history date time ahead

update h set h.HistoryUTC=dateadd(day, -@DayMovedAhead, h.HistoryUTC)
from Ncase a
join NCaseHistory h on a.CaseID=h.CaseID
where a.CaseNumber=@Case_CaseNumber

------------------
Declare @Case_CaseNumber nvarchar(128) ='20210812-1556', -- Case Case number
		@DayMovedAhead int = 14  -- Number of days to move history date time ahead

update h set h.HistoryUTC=dateadd(day, -@DayMovedAhead, h.HistoryUTC)
from Ncase a
join NCaseHistory h on a.CaseID=h.CaseID
where a.CaseNumber=@Case_CaseNumber



-- IR
Declare @IR_CaseNumber nvarchar(128) ='20210812-907', -- IR Case number
		@DayMovedAheadIR int = 14  -- Number of days to move history date time ahead

update b set b.DateModified=dateadd(day, -@DayMovedAheadIR, b.DateModified)
from IR_IR_BA b
where b.CASE_NUMBER=@IR_CaseNumber


------------------------
Declare @IR_CaseNumber nvarchar(128) ='20210813-919', -- IR Case number
		@DayMovedAheadIR int = 14  -- Number of days to move history date time ahead

update b set b.DateModified=dateadd(day, -@DayMovedAheadIR, b.DateModified)
from IR_IR_BA b
where b.CASE_NUMBER=@IR_CaseNumber


-------------------------
Declare @IR_CaseNumber nvarchar(128) ='20210812-918', -- IR Case number
		@DayMovedAheadIR int = 14  -- Number of days to move history date time ahead

update b set b.DateModified=dateadd(day, -@DayMovedAheadIR, b.DateModified)
from IR_IR_BA b
where b.CASE_NUMBER=@IR_CaseNumber


--run task scheduler Depersonalization here and verify the email
--all the above Legal Hold linked cases/IR/E-alert should be deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified

--PASSED


--12-- 5 linear link
--E-Alert  - Case  - Case  - IR  - E-alert

--test for linked open case

--E-Alert Escalate to Case
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'laxsubl', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '120821-360', '20210813-1565'    --4 E-Alert Escalate to Case


--E-Alert Escalate to IR
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '120821-361', '20210813-920'    --5 EAlertLinkIR

--create a open case
exec spDT_CreateTestCase 'laxsubl', 'hun_amazon', 'Open',  '2011-06-24 17:31:17.280','No',  'Substantiated'
-- link this case to above Case
exec spDT_Link 1, '20210813-1566', '20210813-1565'    -- type 1 - CaseLinkCase
-- again, link this case to above IR
exec spDT_Link 2, '20210813-1566', '20210813-920'   --2 CaseLinkIR


--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be NOT deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified


--PASSED

--close the open case
exec spdt_updatetestcase '20210813-1566', '2011-06-24 17:31:17.280', 'No'



--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified

--PASSED


--===================================================================================


--test for linked open IR

--E-Alert Escalate to Case
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'laxsubl', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '130821-372', '20210813-1580'    --4 E-Alert Escalate to Case


--E-Alert Escalate to IR
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '130821-373', '20210813-924'    --5 EAlertLinkIR

--create a open case
exec spDT_CreateTestCase 'laxsubl', 'hun_amazon', 'Close',  '2011-06-24 17:31:17.280','No',  'Substantiated'
-- link this case to above Case
exec spDT_Link 1, '20210813-1581', '20210813-1580'    -- type 1 - CaseLinkCase
-- again, link this case to above IR
exec spDT_Link 2, '20210813-1581', '20210813-924'   --2 CaseLinkIR


--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be NOT deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified

--PASSED

--close the open IR  
exec spDT_UpdateTestIR '20210813-924', '2018-07-24 20:12:17.280', 'No'


--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified

--PASSED



--===================================================================================


--test for linked Legal Hold case

--E-Alert Escalate to Case
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'laxsubl', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '130821-372', '20210813-1582'    --4 E-Alert Escalate to Case


--E-Alert Escalate to IR
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '130821-373', '20210813-925'    --5 EAlertLinkIR

--create a Legal Hold case
exec spDT_CreateTestCase 'laxsubl', 'hun_amazon', 'Close',  '2011-06-24 17:31:17.280','Yes',  'Substantiated'
-- link this case to above Case
exec spDT_Link 1, '20210813-1583', '20210813-1582'    -- type 1 - CaseLinkCase
-- again, link this case to above IR
exec spDT_Link 2, '20210813-1583', '20210813-925'   --2 CaseLinkIR


--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be NOT deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified


--PASSED

--lift the  case to legal hold=No
exec spdt_updatetestcase '20210813-1583', '2011-06-24 17:31:17.280', 'No'



--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should not be deleted because of the 14 days retention
-- Case, E-Alert and IR numbers can be verified

--PASSED


--change legal hold history to 14 days earlier
Declare @Case_CaseNumber nvarchar(128) ='20210813-1583', -- Case Case number
		@DayMovedAhead int = 14  -- Number of days to move history date time ahead

update h set h.HistoryUTC=dateadd(day, -@DayMovedAhead, h.HistoryUTC)
from Ncase a
join NCaseHistory h on a.CaseID=h.CaseID
where a.CaseNumber=@Case_CaseNumber


--PASSED

--===================================================================================




--test for linked Legal Hold IR

--E-Alert Escalate to Case
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'laxsubl', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '130821-372', '20210813-1584'    --4 E-Alert Escalate to Case


--E-Alert Escalate to IR with Legal hold
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '130821-373', '20210813-926'    --5 EAlertLinkIR

--create a open case
exec spDT_CreateTestCase 'laxsubl', 'laxsubl', 'Close',  '2011-06-24 17:31:17.280','No',  'Substantiated'
-- link this case to above Case
exec spDT_Link 1, '20210813-1585', '20210813-1584'    -- type 1 - CaseLinkCase
-- again, link this case to above IR
exec spDT_Link 2, '20210813-1585', '20210813-926'   --2 CaseLinkIR


--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be NOT deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified


--PASSED

--lift the  case to legal hold=No
exec spDT_UpdateTestIR '20210813-926', '2018-07-24 20:12:17.280', 'No'



--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should not be deleted because of the 14 days retention
-- Case, E-Alert and IR numbers can be verified

--PASSED


--change legal hold history to 14 days earlier
Declare @IR_CaseNumber nvarchar(128) ='20210813-926', -- IR Case number
		@DayMovedAheadIR int = 14  -- Number of days to move history date time ahead

update b set b.DateModified=dateadd(day, -@DayMovedAheadIR, b.DateModified)
from IR_IR_BA b
where b.CASE_NUMBER=@IR_CaseNumber


--PASSED




--13--  9 level round link



--E-Alert AAA Escalate to Case_111
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'laxsubl', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '130821-373', '20210813-1597'    --4 E-Alert AAA Escalate to Case_111

--create a IR_222
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
--link this IR_222  to above escalated case_111
exec spDT_Link 2, '20210813-1597', '20210813-938'   --2 CaseLinkIR

--E-Alert BBB Escalate to IR_111
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '130821-374', '20210813-939'    --5 EAlertLinkIR to IR_111

-- create a case_222
exec spDT_CreateTestCase 'laxsubl', 'laxsubl', 'Close', '2018-07-23 20:39:17.280','No', 'Partially Substantiated'
-- link this case_222 to above escalated IR_111
exec spDT_Link 2, '20210813-1598', '20210813-939'   --2 CaseLinkIR

-- create a Open case_333
exec spDT_CreateTestCase 'laxsubl', 'laxsubl', 'Open', '2018-07-23 20:39:17.280','No', 'Substantiated'
-- link this case_333 to above Case_222
exec spDT_Link 1, '20210813-1599', '20210813-1598'    -- type 1 - CaseLinkCase
-- again, link this case_333 to above IR_222
exec spDT_Link 2, '20210813-1599', '20210813-938'   --2 CaseLinkIR


-- create a IR_444
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
--line IR_444 to case_333
exec spDT_Link 2, '20210813-1599', '20210813-940'   --2 CaseLinkIR

-- create a IR_555
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
--link IR_555 to IR_444
exec spDT_Link 3, '20210813-941', '20210813-940'    --3 IRLinkIR



-- create a case_666
exec spDT_CreateTestCase 'laxsubl', 'laxsubl', 'Close', '2018-07-23 20:39:17.280','No', 'Partially Substantiated'
-- link this case_666 to above IR_555
exec spDT_Link 2, '20210813-1600', '20210813-941'   --2 CaseLinkIR

-- create a case_666_2
exec spDT_CreateTestCase 'laxsubl', 'laxsubl', 'Close', '2018-07-23 20:39:17.280','No', 'UnSubstantiated'
-- link this case_666_2 to above Case_333
exec spDT_Link 1, '20210813-1601', '20210813-1599'    -- type 1 - CaseLinkCase


--E-Alert CCC Escalate to IR_777
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '130821-375', '20210813-942'    --5 EAlertLinkIR to IR_777

 
--link IR_777 to case_666 and case_666_2
--link this IR_777 to above case_666
exec spDT_Link 2, '20210813-1600', '20210813-942'   --2 CaseLinkIR
--link this IR_777 to above case_666_2
exec spDT_Link 2, '20210813-1601', '20210813-942'   --2 CaseLinkIR

--===============================================
-- open case_333, so run depersonalization, should be no item deleted.

--IR_777 20210813-931 and E-Alert CCC 130821-374 are deleted

--PASSED

-- close case_333
exec spdt_updatetestcase '20210813-1599', '2018-07-23 20:39:17.280', 'No'

-- reopen IR_555  20210813-930,  use VSOC

-- run task scheduler Depersonalization here and verify the email
-- all the above items should not be deleted because there is an open IR
-- Case, E-Alert and IR numbers can be verified


--PASSED


---=======================================================================================
-- put the legal hold to case_222
exec spdt_updatetestcase '20210813-1598', '2018-07-23 20:39:17.280', 'Yes'

--close IR_555 
exec spDT_UpdateTestIR '20210813-941', '2018-07-24 20:12:17.280', 'No'


--run task scheduler Depersonalization here and verify the email
-- all the above items should NOT  be deleted
-- Case, E-Alert and IR numbers can be verified


--PASSED

-- lifted legal hold,  put the case_222 legal hold to No
exec spdt_updatetestcase '20210813-1598', '2018-07-23 20:39:17.280', 'No'

--run task scheduler Depersonalization here and verify the email
-- all the above items should NOT  be deleted, bacause of the 14 days retain

--PASSED

-- put IR_777's Legal Hold to Yes
exec spDT_UpdateTestIR '20210813-942', '2018-07-24 20:12:17.280', 'Yes'


--change case_222 legal hold history to 14 days earlier
Declare @Case_CaseNumber nvarchar(128) ='20210813-1598', -- Case Case number
		@DayMovedAhead int = 14  -- Number of days to move history date time ahead

update h set h.HistoryUTC=dateadd(day, -@DayMovedAhead, h.HistoryUTC)
from Ncase a
join NCaseHistory h on a.CaseID=h.CaseID
where a.CaseNumber=@Case_CaseNumber


--run task scheduler Depersonalization here and verify the email
-- all the above items should NOT  be deleted, bacause of the IR_777 Legal Hold
-- Case, E-Alert and IR numbers can be verified


--PASSED

-- put IR_777's Legal Hold to No
exec spDT_UpdateTestIR '20210813-942', '2018-07-24 20:12:17.280', 'No'


--run task scheduler Depersonalization here and verify the email
-- all the above items should NOT  be deleted, bacause of the IR_777 Legal Hold change in 14 days

--PASSED

--set  IR_777 legal hold lift date to 14 days earlier
Declare @IR_CaseNumber nvarchar(128) ='20210813-942', -- IR Case number
		@DayMovedAheadIR int = 14  -- Number of days to move history date time ahead

update b set b.DateModified=dateadd(day, -@DayMovedAheadIR, b.DateModified)
from IR_IR_BA b
where b.CASE_NUMBER=@IR_CaseNumber


--run task scheduler Depersonalization here and verify the email
-- all the above items should be deleted
-- Case, E-Alert and IR numbers can be verified


--PASSED

