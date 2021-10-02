-- to test Data Depersonalization
-- there 3 stored procedures to generate Case/IR/E-Alert with virous type of open/close, Legal hold, and Substantiated.
-- and there are 1 stored procedure to link them.

--set user laxsubl's Building to 'MAD9' (for testing), then
--PersonID	CAI	PersonTypeID Building country CountryISOCode	Country	Substantiated	Rules	Year	Month	Day
--10581852	LAXSUBL	2301	MAD9	Spain		ESP				Spain	Yes				F+3		3		0		0
--10581852	LAXSUBL	2301	MAD9	Spain		ESP				Spain	No				F+3M	0		3		0

--1-- to create cases
--Run exec spDT_CreateTestCase ‘Creator’,'Owner','Open/Close','CloseDate',"LegalHold Yes/No',
--       'Substantiated/UnSubstantiated/Partially Substantiated' to generate a new Case. 
--For example, 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-24 22:06:17.280','No', 'Partially Substantiated'

exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Open',  '2011-06-24 17:31:17.280','No',  'Substantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2011-06-24 17:31:17.280','Yes', 'UnSubstantiated'


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



--5-- Link between Case/IR and Escalate from E-Alert to Case/IR
-- Run exec spDT_Link type1/2/3/4/5, 'Number1', 'Number2' to link Number1 to Number2
-- Type options: 1 CaseLinkCase; 2 CaseLinkIR; 3 IRLinkIR; 4 E-Alert Escalate to Case; 5 E-Alert Escalate to IR

-- For example, type 1 CaseLinkCase,

-- generate 2 closed cases first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 1, '20210726-63', '20210726-64'    -- type 1 - CaseLinkCase

-- generate 1 closed and 1 open cases first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-24 22:06:17.280','No', 'Partially Substantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Open',  '2011-06-24 17:31:17.280','No',  'Substantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 1, '20210726-65', '20210726-66'    -- type 1 - CaseLinkCase

-- generate 1 closed and 1 Legal Hold cases first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2011-06-24 17:31:17.280','Yes', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 1, '20210726-67', '20210726-68'    -- type 1 - CaseLinkCase

--run task scheduler Depersonalization here and verify the email
--should be 2 cases have been deleted and reported in the email, case numbers can be verified

--6--  type 2 CaseLinkIR
-- generate 1 closed case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '20210726-69', '20210726-47'   --2 CaseLinkIR


-- generate 1 closed case and 1 open IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '20210726-70', '20210726-48'   --2 CaseLinkIR

-- generate 1 closed case and 1 Legal Hold IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '20210726-71', '20210726-49'   --2 CaseLinkIR

-- generate 1 open case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Open', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '20210726-72', '20210726-50'   --2 CaseLinkIR

-- generate 1 Legal Hold case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','Yes', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 2, '20210726-73', '20210726-51'   --2 CaseLinkIR

--run task scheduler Depersonalization here and verify the email
--should be only the linked 1 closed cases and 1 closed IR have been deleted and reported in the email
--case number and IR number can be verified


--7--  type 3 IRLinkIR
-- generate 2 closed IRs first, then link them 
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 3, '20210726-53', '20210726-54'    --3 IRLinkIR

-- generate 1 closed IR and 1 open IR first, then link them 
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'laxsubl', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 3, '20210726-55', '20210726-56'    --3 IRLinkIR

-- generate 1 closed IR and 1 Legal Hold IR first, then link them 
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 3, '20210726-57', '20210726-58'    --3 IRLinkIR

--run task scheduler Depersonalization here and verify the email
--should be the linked 2 closed IR have been deleted and reported in the email
--IR numbers can be verified


--8-- type 4 E-Alert Escalate to Case
-- generate 1 open E-Alert and 1 closed case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '260721-71', '20210726-79'    --4 E-Alert Escalate to Case

-- generate 1 open E-Alert and 1 open case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Open', '2018-04-24 20:39:17.280','No', 'Substantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '260721-69', '20210726-77'    --4 E-Alert Escalate to Case


-- generate 1 open E-Alert and 1 Legal Hold case first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','Yes', 'Substantiated'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '260721-70', '20210726-78'    --4 E-Alert Escalate to Case

--run task scheduler Depersonalization here and verify the email
--should be only 1 E-Alert and 1 closed case have been deleted and reported in the email
-- E-Alert and case numbers can be verified


--9-- type 5 E-Alert Escalate to IR
-- generate 1 open E-Alert and 1 closed IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '260721-71', '20210726-59'    --4 EAlertLinkCase


-- generate 1 open E-Alert and 1 open IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Open', '2018-07-24 20:12:17.280','No'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '260721-72', '20210726-60'    --4 EAlertLinkCase

-- generate 1 open E-Alert and 1 open IR first, then link them 
exec spDT_CreateTestEIR 'laxsubl',NULL, NULL
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'
-- run above 2 lines first, then copy 2 CaseNumbers from the result to below command as ordered, then run below to link them
exec spDT_Link 4, '260721-74', '20210726-62'    --4 EAlertLinkCase

--run task scheduler Depersonalization here and verify the email
--should be only 1 E-Alert and 1 closed IR have been deleted and reported in the email
-- E-Alert and IR numbers can be verified


