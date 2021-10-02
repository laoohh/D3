--Test Starting Date 20210809   Time  2:00pm
--Test Environment local: TSMC1\SQL2017.SCS_demo

-- to test Data Depersonalization
-- there are 3 stored procedures to generate Case/IR/E-Alert with various type of attributes such as open/close, Legal hold, and Substantiated.
-- and there is 1 stored procedure to link case, IR or Ealert.

--Any user ID from a country that needs to be tested can be added. For this test purpose we set user laxsubl's Building to 'MAD9' (for testing), then
--PersonID	CAI	PersonTypeID Building country CountryISOCode	Country	Substantiated	Rules	Year	Month	Day
--10581852	LAXSUBL	2301	MAD9	Spain		ESP				Spain	Yes				F+3		3		0		0
--10581852	LAXSUBL	2301	MAD9	Spain		ESP				Spain	No				F+3M	0		3		0

--1-- to create cases
--Run exec spDT_CreateTestCase ¡®Creator¡¯,'Owner','Open/Close','CloseDate',"LegalHold Yes/No',
--       'Substantiated/UnSubstantiated/Partially Substantiated' to generate a new Case. 
--For example, 
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-24 22:06:17.280','No', 'Partially Substantiated'

exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Open',  '2011-06-24 17:31:17.280','No',  'Substantiated'
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2011-06-24 17:31:17.280','Yes', 'UnSubstantiated'


--2-- to create IRs
--Run exec spDT_CreateTestIR ¡®Creator¡¯, ¡®Status¡¯, ¡®CloseDate¡¯, ¡®LegalHold Yes/No¡¯ to generate a new IR. 
--For example, 
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'

exec spDT_CreateTestIR 'hun_amazon', 'Open', '2011-06-24 17:31:17.280','No'
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2011-06-24 17:31:17.280','Yes'


--3-- to create E-Alert
--Run exec spDT_CreateTestEIR ¡®AssigneeUserName¡¯, ¡®ArchiveUserName¡¯, ¡®ArchiveDate¡¯ to generate a new Archived E-Alert. 
--if ArchiveUserName and ArchiveDate are all NULL, will create an open E-Alert (not archived)
--For example, 
exec spDT_CreateTestEIR 'hun_amazon', 'laxsubl', '2007-06-24 17:31:17.280'   --archived E-Alert

exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL  -- Open E-Alert


--run task scheduler Depersonalization here and verify the email
--should be 3 cases, 1 IR, and 1 E-Alert have been deleted and reported in the email 

--PASSED

--4-- to verify the retention period expiration
--case policy F+3 , 3 years (Substantiated)
exec spDT_CreateTestCase 'bru_amazon', 'hun_amazon', 'Close', '2020-08-14 13:00:17.280','No', 'Substantiated'
exec spDT_CreateTestCase 'bru_amazon', 'hun_amazon', 'Close', '2020-08-14 13:10:17.280','No', 'Substantiated'

--case policy F+3 , 3 years (Patially Substantiated)
exec spDT_CreateTestCase 'bru_amazon', 'hun_amazon', 'Close', '2020-08-14 13:00:17.280','No', 'Partially Substantiated'
exec spDT_CreateTestCase 'bru_amazon', 'hun_amazon', 'Close', '2020-08-14 13:10:17.280','No', 'Partially Substantiated'

--case policy F+3M , 3 months (UnSubstantiated)
exec spDT_CreateTestCase 'bru_amazon', 'hun_amazon', 'Close', '2021-06-14 13:00:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'bru_amazon', 'hun_amazon', 'Close', '2021-06-14 13:10:17.280','No', 'UnSubstantiated'

--IR policy F+3 , 3 years (IR always use Substantiated policy)
exec spDT_CreateTestIR 'bru_amazon', 'Close', '2020-08-14 13:00:17.280','No'
exec spDT_CreateTestIR 'bru_amazon', 'Close', '2020-08-14 13:10:17.280','No'

--Archived E-Alert policy F+3M , 3 months ( E-Alert always use UnSubstantiated policy)
exec spDT_CreateTestEIR 'bru_amazon', 'hun_amazon', '2021-06-14 13:00:17.280'   --archived E-Alert
exec spDT_CreateTestEIR 'bru_amazon', 'hun_amazon', '2021-06-14 13:10:17.280'   --archived E-Alert


--run task scheduler Depersonalization here and verify the email
--there should be 2 cases, 1 IR, 1 E-Alert deleted, and could verify the CaseNumbers

--PASSED

--5-- Link between Case/IR and Escalate from E-Alert to Case/IR
-- Run exec spDT_Link type1/2/3/4/5, 'Number1', 'Number2' to link Number1 to Number2
-- Type options: 1 CaseLinkCase; 2 CaseLinkIR; 3 IRLinkIR; 4 E-Alert Escalate to Case; 5 E-Alert Escalate to IR

-- For example, type 1 CaseLinkCase,

-- generate 2 closed cases first, then link them 
exec spDT_CreateTestCase 'bru_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestCase 'bru_amazon', 'hun_amazon', 'Close', '2021-04-27 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 1, '210814000013', '210814000014'    -- type 1 - CaseLinkCase

-- generate 1 closed and 1 open cases first, then link them 
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-24 22:06:17.280','No', 'Partially Substantiated'
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Open',  '2011-06-24 17:31:17.280','No',  'Substantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 1, '210814000015', '210814000016'    -- type 1 - CaseLinkCase

-- generate 1 closed and 1 Legal Hold cases first, then link them 
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2021-04-26 23:00:00.280','Yes', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 1, '210814000017', '210814000018'    -- type 1 - CaseLinkCase


--run task scheduler Depersonalization here and verify the email
--should be 2 cases have been deleted and reported in the email, case numbers can be verified

--PASSED

--6--  type 2 CaseLinkIR
-- generate 1 closed case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '210814000019', '20210814-6'   --2 CaseLinkIR


-- generate 1 closed case and 1 open IR first, then link them 
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'hun_amazon', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '210814000020', '20210814-7'   --2 CaseLinkIR

-- generate 1 closed case and 1 Legal Hold IR first, then link them 
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '210814000021', '20210814-8'   --2 CaseLinkIR

-- generate 1 open case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Open', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '210814000022', '20210814-9'   --2 CaseLinkIR

-- generate 1 Legal Hold case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','Yes', 'Substantiated'
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '210814000023', '20210814-10'   --2 CaseLinkIR


--run task scheduler Depersonalization here and verify the email
--should be only the linked 1 closed cases and 1 closed IR have been deleted and reported in the email
--case number and IR number can be verified

--PASSED


--7--  type 3 IRLinkIR
-- generate 2 closed IRs first, then link them 
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 3, '20210814-11', '20210814-12'    --3 IRLinkIR

-- generate 1 closed IR and 1 open IR first, then link them 
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'hun_amazon', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 3, '20210814-13', '20210814-14'    --3 IRLinkIR

-- generate 1 closed IR and 1 Legal Hold IR first, then link them 
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 3, '20210814-15', '20210814-16'    --3 IRLinkIR


--run task scheduler Depersonalization here and verify the email
--should be the linked 2 closed IR have been deleted and reported in the email
--IR numbers can be verified

--PASSED

--8-- type 4 E-Alert Escalate to Case
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '140821-25980', '210814000024'    --4 E-Alert Escalate to Case

-- generate 1 open E-Alert and 1 open case first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestCase 'hun_amazon', 'hwanghan', 'Open', '2018-04-24 20:39:17.280','No', 'Substantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '140821-25981', '210814000025'    --4 E-Alert Escalate to Case


-- generate 1 open E-Alert and 1 Legal Hold case first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','Yes', 'Substantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '140821-25982', '210814000026'    --4 E-Alert Escalate to Case


--run task scheduler Depersonalization here and verify the email
--should be only 1 E-Alert and 1 closed case have been deleted and reported in the email
-- E-Alert and case numbers can be verified

--PASSED

--9-- type 5 E-Alert Escalate to IR
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '140821-25983', '20210814-17'    --5 EAlertLinkIR


-- generate 1 open E-Alert and 1 open IR first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestIR 'hun_amazon', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '140821-25984', '20210814-18'    --5 EAlertLinkIR

-- generate 1 open E-Alert and 1 open IR first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '140821-25985', '20210814-19'    --5 EAlertLinkIR


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

exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2021-04-26 23:00:00.280','Yes', 'UnSubstantiated'
exec spDT_Link 1, '210814000017', '210814000018'    -- type 1 - CaseLinkCase
--set Legal Hold to No
exec spdt_updatetestcase '210814000018', '2018-04-24 20:39:17.280', 'No'

exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','Yes'
exec spDT_Link 2, '210814000021', '20210814-8'   --2 CaseLinkIR
--set Legal Hold to No
exec spDT_UpdateTestIR '20210814-8', '2018-04-24 20:39:17.280', 'No'



exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','Yes', 'Substantiated'
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_Link 2, '210814000023', '20210814-10'   --2 CaseLinkIR
--set Legal Hold to No
exec spdt_updatetestcase '210814000023', '2018-04-24 20:39:17.280', 'No'



exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','Yes'
exec spDT_Link 3, '20210814-15', '20210814-16'    --3 IRLinkIR
--set Legal Hold to No
exec spDT_UpdateTestIR '20210814-16', '2018-04-24 20:39:17.280', 'No'



exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','Yes', 'Substantiated'
exec spDT_Link 4, '140821-25982', '210814000026'    --4 E-Alert Escalate to Case
--set Legal Hold to No
exec spdt_updatetestcase '210814000026', '2018-04-24 20:39:17.280', 'No'



exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','Yes'
exec spDT_Link 5, '140821-25985', '20210814-19'    --5 EAlertLinkIR
--set Legal Hold to No
exec spDT_UpdateTestIR '20210814-19', '2018-04-24 20:39:17.280', 'No'

--run task scheduler Depersonalization here and verify the email
--should be only 1 E-Alert and 1 closed IR have been deleted and reported in the email
-- E-Alert and IR numbers can be verified

--PASSED


--11-- change legal hold history to 14 days before
-- Case
Declare @Case_CaseNumber nvarchar(128) ='210814000018', -- Case Case number
		@DayMovedAhead int = 14  -- Number of days to move history date time ahead

update h set h.HistoryUTC=dateadd(day, -@DayMovedAhead, h.HistoryUTC)
from Ncase a
join NCaseHistory h on a.CaseID=h.CaseID
where a.CaseNumber=@Case_CaseNumber

------------------
Declare @Case_CaseNumber nvarchar(128) ='210814000023', -- Case Case number
		@DayMovedAhead int = 14  -- Number of days to move history date time ahead

update h set h.HistoryUTC=dateadd(day, -@DayMovedAhead, h.HistoryUTC)
from Ncase a
join NCaseHistory h on a.CaseID=h.CaseID
where a.CaseNumber=@Case_CaseNumber

------------------
Declare @Case_CaseNumber nvarchar(128) ='210814000026', -- Case Case number
		@DayMovedAhead int = 14  -- Number of days to move history date time ahead

update h set h.HistoryUTC=dateadd(day, -@DayMovedAhead, h.HistoryUTC)
from Ncase a
join NCaseHistory h on a.CaseID=h.CaseID
where a.CaseNumber=@Case_CaseNumber



-- IR
Declare @IR_CaseNumber nvarchar(128) ='20210814-16', -- IR Case number
		@DayMovedAheadIR int = 14  -- Number of days to move history date time ahead

update b set b.DateModified=dateadd(day, -@DayMovedAheadIR, b.DateModified)
from IR_IR_BA b
where b.CASE_NUMBER=@IR_CaseNumber


------------------------
Declare @IR_CaseNumber nvarchar(128) ='20210814-8', -- IR Case number
		@DayMovedAheadIR int = 14  -- Number of days to move history date time ahead

update b set b.DateModified=dateadd(day, -@DayMovedAheadIR, b.DateModified)
from IR_IR_BA b
where b.CASE_NUMBER=@IR_CaseNumber


-------------------------
Declare @IR_CaseNumber nvarchar(128) ='20210814-19', -- IR Case number
		@DayMovedAheadIR int = 14  -- Number of days to move history date time ahead

update b set b.DateModified=dateadd(day, -@DayMovedAheadIR, b.DateModified)
from IR_IR_BA b
where b.CASE_NUMBER=@IR_CaseNumber


--run task scheduler Depersonalization here and verify the email
--all the above Legal Hold linked cases/IR/E-alert should be deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified

--PASSED


--12-- 5 level linear link
--E-Alert  - Case  - Case  - IR  - E-alert

--test for linked open case

--E-Alert Escalate to Case
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '140821-25986', '210814000027'    --4 E-Alert Escalate to Case


--E-Alert Escalate to IR
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '140821-25987', '20210814-20'    --5 EAlertLinkIR

--create a open case
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Open',  '2011-06-24 17:31:17.280','No',  'Substantiated'
-- link this case to above Case
exec spDT_Link 1, '210814000028', '210814000027'    -- type 1 - CaseLinkCase
-- again, link this case to above IR
exec spDT_Link 2, '210814000028', '20210814-20'   --2 CaseLinkIR


--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be NOT deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified


--PASSED

--close the open case
exec spdt_updatetestcase '210814000028', '2011-06-24 17:31:17.280', 'No'



--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified

--PASSED


--===================================================================================


--test for linked open IR

--E-Alert Escalate to Case
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '140821-25988', '210814000029'    --4 E-Alert Escalate to Case


--E-Alert Escalate to IR
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestIR 'hun_amazon', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '140821-25989', '20210814-21'    --5 EAlertLinkIR

--create a open case
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close',  '2011-06-24 17:31:17.280','No',  'Substantiated'
-- link this case to above Case
exec spDT_Link 1, '210814000030', '210814000029'    -- type 1 - CaseLinkCase
-- again, link this case to above IR
exec spDT_Link 2, '210814000030', '20210814-21'   --2 CaseLinkIR


--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be NOT deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified

--PASSED

--close the open IR  
exec spDT_UpdateTestIR '20210814-21', '2018-07-24 20:12:17.280', 'No'


--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified

--PASSED



--===================================================================================


--test for linked Legal Hold case

--E-Alert Escalate to Case
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '140821-25990', '210814000031'    --4 E-Alert Escalate to Case


--E-Alert Escalate to IR
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '140821-25991', '20210814-22'    --5 EAlertLinkIR

--create a open case
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close',  '2011-06-24 17:31:17.280','Yes',  'Substantiated'
-- link this case to above Case
exec spDT_Link 1, '210814000032', '210814000031'    -- type 1 - CaseLinkCase
-- again, link this case to above IR
exec spDT_Link 2, '210814000032', '20210814-22'   --2 CaseLinkIR


--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be NOT deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified


--PASSED

--lift the  case to legal hold=No
exec spdt_updatetestcase '210814000032', '2011-06-24 17:31:17.280', 'No'



--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should not be deleted because of the 14 days retention
-- Case, E-Alert and IR numbers can be verified

--PASSED


--change legal hold history to 14 days earlier
Declare @Case_CaseNumber nvarchar(128) ='210814000032', -- Case Case number
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
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '140821-25992', '210814000033'    --4 E-Alert Escalate to Case


--E-Alert Escalate to IR
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '140821-25993', '20210814-23'    --5 EAlertLinkIR

--create a open case
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close',  '2011-06-24 17:31:17.280','No',  'Substantiated'
-- link this case to above Case
exec spDT_Link 1, '210814000034', '210814000033'    -- type 1 - CaseLinkCase
-- again, link this case to above IR
exec spDT_Link 2, '210814000034', '20210814-23'   --2 CaseLinkIR


--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should be NOT deleted and reported in the email
-- Case, E-Alert and IR numbers can be verified


--PASSED

--lift the  case to legal hold=No
exec spDT_UpdateTestIR '20210814-23', '2018-07-24 20:12:17.280', 'No'



--run task scheduler Depersonalization here and verify the email
--all the above linked cases/IR/E-alert should not be deleted because of the 14 days retention
-- Case, E-Alert and IR numbers can be verified

--PASSED


--change legal hold history to 14 days earlier
Declare @IR_CaseNumber nvarchar(128) ='20210814-23', -- IR Case number
		@DayMovedAheadIR int = 14  -- Number of days to move history date time ahead

update b set b.DateModified=dateadd(day, -@DayMovedAheadIR, b.DateModified)
from IR_IR_BA b
where b.CASE_NUMBER=@IR_CaseNumber


--PASSED




--13--  9 level round link



--E-Alert AAA Escalate to Case_111
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '140821-25994', '210814000035'    --4 E-Alert AAA Escalate to Case_111

--create a IR_222
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
--link this IR_222  to above escalated case_111
exec spDT_Link 2, '210814000035', '20210814-24'   --2 CaseLinkIR

--E-Alert BBB Escalate to IR_111
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '140821-25995', '20210814-25'    --5 EAlertLinkIR to IR_111

-- create a case_222
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
-- link this case_222 to above escalated IR_111
exec spDT_Link 2, '210814000036', '20210814-25'   --2 CaseLinkIR

-- create a case_333
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
-- link this case_333 to above Case_222
exec spDT_Link 1, '210814000037', '210814000036'    -- type 1 - CaseLinkCase
-- again, link this case_333 to above IR_222
exec spDT_Link 2, '210814000037', '20210814-24'   --2 CaseLinkIR


-- create a IR_444
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
--line IR_444 to case_333
exec spDT_Link 2, '210814000037', '20210814-26'   --2 CaseLinkIR

-- create a IR_555
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
--link IR_555 to IR_444
exec spDT_Link 3, '20210814-27', '20210814-26'    --3 IRLinkIR



-- create a case_666
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
-- link this case_666 to above IR_555
exec spDT_Link 2, '210814000038', '20210814-27'   --2 CaseLinkIR

-- create a case_666_2
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
-- link this case_666_2 to above Case_333
exec spDT_Link 1, '210814000039', '210814000037'    -- type 1 - CaseLinkCase


--E-Alert CCC Escalate to IR_777
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'hun_amazon',NULL, NULL
exec spDT_CreateTestIR 'hun_amazon', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 5, '140821-25996', '20210814-28'    --5 EAlertLinkIR to IR_777

 
--link IR_777 to case_666 and case_666_2
--link this IR_777 to above case_666
exec spDT_Link 2, '210814000038', '20210814-28'   --2 CaseLinkIR
--link this IR_777 to above case_666_2
exec spDT_Link 2, '210814000039', '20210814-28'   --2 CaseLinkIR

--===============================================
-- create a case_333_2, which is a open case
exec spDT_CreateTestCase 'hun_amazon', 'hun_amazon', 'Open', '2018-07-23 20:39:17.280','No', 'Substantiated'
-- link this case_333_2 to above Case_333
--exec spDT_Link 1, '210814000040', '210810000054'    -- type 1 - CaseLinkCase
exec spDT_Link 2, '210814000040', '20210814-26'   --2 CaseLinkIR   IR_444
--PASSED

-- close case_333_2 
exec spdt_updatetestcase '210814000040', '2018-07-23 20:39:17.280', 'No'

-- run task scheduler Depersonalization here and verify the email
-- all the above items should not be deleted
-- Case, E-Alert and IR numbers can be verified


--PASSED


-- create a IR_555_2, which is a open IR
exec spDT_CreateTestIR 'hun_amazon', 'Open', '2018-07-24 20:12:17.280','No'
--link IR_555_2 to IR_555
exec spDT_Link 3, '20210814-29', '20210814-27'    --3 IRLinkIR
--link IR_555_2 to IR_444
exec spDT_Link 3, '20210814-29', '20210814-26'    --3 IRLinkIR
exec spDT_Link 2, '210814000040', '20210814-27'   --2 CaseLinkIR   IR_444

--PASSED



-- close IR_555_2
exec spDT_UpdateTestIR '20210814-29', '2018-07-24 20:12:17.280', 'No'

-- run task scheduler Depersonalization here and verify the email
-- all the above items should be deleted
-- Case, E-Alert and IR numbers can be verified


--PASSED


---=======================================================================================
-- put the legal hold to case_333_2

exec spdt_updatetestcase '210814000040', '2018-07-23 20:39:17.280', 'Yes'


-- in above items,  case_333_2 is Legal Hold
--run task scheduler Depersonalization here and verify the email
-- all the above items should NOT  be deleted
-- Case, E-Alert and IR numbers can be verified


--PASSED

--lifted legal hold, set case_333_2 legal hold to No
exec spdt_updatetestcase '210814000040', '2018-07-23 20:39:17.280', 'No'

--run task scheduler Depersonalization here and verify the email
-- all the above items should NOT  be deleted, bacause of the 14 days retain
-- Case, E-Alert and IR numbers can be verified


--PASSED



--set  case_333_2 legal hold lift date to 14 days earlier

Declare @Case_CaseNumber nvarchar(128) ='210814000040', -- Case Case number
		@DayMovedAhead int = 14  -- Number of days to move history date time ahead

update h set h.HistoryUTC=dateadd(day, -@DayMovedAhead, h.HistoryUTC)
from Ncase a
join NCaseHistory h on a.CaseID=h.CaseID
where a.CaseNumber=@Case_CaseNumber



--run task scheduler Depersonalization here and verify the email
-- all the above items should  be deleted
-- Case, E-Alert and IR numbers can be verified


--PASSED


---=======================================================================================
-- put the legal hold to IR_555_2

exec spDT_UpdateTestIR '20210814-29', '2018-07-24 20:12:17.280', 'Yes'

-- in above items,  IR_555_2 is Legal Hold
--run task scheduler Depersonalization here and verify the email
-- all the above items should NOT  be deleted
-- Case, E-Alert and IR numbers can be verified


--PASSED

--lifted legal hold, set IR_555_2 legal hold to No
exec spDT_UpdateTestIR '20210814-29', '2018-07-24 20:12:17.280', 'No'


--run task scheduler Depersonalization here and verify the email
-- all the above items should NOT  be deleted, bacause of the 14 days retain
-- Case, E-Alert and IR numbers can be verified


--PASSED



--set  IR_555_2 legal hold lift date to 14 days earlier
Declare @IR_CaseNumber nvarchar(128) ='20210814-29', -- IR Case number
		@DayMovedAheadIR int = 14  -- Number of days to move history date time ahead

update b set b.DateModified=dateadd(day, -@DayMovedAheadIR, b.DateModified)
from IR_IR_BA b
where b.CASE_NUMBER=@IR_CaseNumber


--run task scheduler Depersonalization here and verify the email
-- all the above items should be deleted
-- Case, E-Alert and IR numbers can be verified


--PASSED



--14--  Archived E-Alert

--generate 2 pare Archived E-Alert


--1st pare without Assignee
exec spDT_CreateTestEIR 'hun_amazon', 'laxsubl', '2021-06-14 17:31:17.280'   --archived E-Alert
exec spDT_CreateTestEIR 'hun_amazon', 'laxsubl', '2021-06-18 17:31:17.280'   --archived E-Alert
--delete the assignee
update EIR_IR 
set REPORT_DATE='2021-06-14 10:31:17.280',
	EMPL_ID=NULL      --assignee
where IR_ID = 61074 or IR_ID = 61075
--run Depersonalization, should use the archived user country's policy which is 2 months
-- the first E-Alert should be deleted and 2nd should not

--PASSED


--2nd pare without Assignee and archived user missing
exec spDT_CreateTestEIR 'hun_amazon', 'laxsubl', '2021-07-14 17:31:17.280'   --archived E-Alert
--delete the assignee and archived user
update EIR_IR 
set REPORT_DATE='2021-07-14 16:31:17.280',
	ArchiveDate=NULL, --archived date
	ArchiveBy=NULL,   --archived user
	EMPL_ID=NULL      --assignee
where IR_ID = 61078

--in 30 days
exec spDT_CreateTestEIR 'hun_amazon', 'laxsubl', '2021-07-18 17:31:17.280'   --archived E-Alert
--delete the assignee and archived user
update EIR_IR 
set REPORT_DATE='2021-07-18 16:31:17.280',
	ArchiveDate=NULL, --archived date
	ArchiveBy=NULL,   --archived user
	EMPL_ID=NULL      --assignee
where IR_ID = 61079


--run Depersonalization, should use the reported date + 30 days
-- the first E-Alert should be deleted and 2nd should not

--PASSED


