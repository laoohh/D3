-- to test Data Depersonalization
-- there 3 stored procedures to generate Case/IR/E-Alert with virous type of open/close, Legal hold, and Substantiated.
-- and there are 1 stored procedure to link them.

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
exec spDT_CreateTestEIR 'laxsubl', 'laxsubl', '2007-06-24 17:31:17.280'

exec spDT_CreateTestEIR 'laxsubl',NULL, NULL

--run task scheduler Depersonalization here and verify the email
--should be 3 cases, 1 IR, and 1 E-Alert have been deleted and reported in the email 

--4-- Link between Case/IR and Escalate from E-Alert to Case/IR
-- Run exec spDT_Link type1/2/3/4/5, 'Number1', 'Number2' to link Number1 to Number2
-- Type options: 1 CaseLinkCase; 2 CaseLinkIR; 3 IRLinkIR; 4 E-Alert Escalate to Case; 5 E-Alert Escalate to IR

-- For example, 1 CaseLinkCase,

-- generate 2 closed cases first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'

exec spDT_Link 1, '20210726-63', '20210726-64'    -- type 1 - CaseLinkCase

-- generate 1 closed and 1 open cases first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-24 22:06:17.280','No', 'Partially Substantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Open',  '2011-06-24 17:31:17.280','No',  'Substantiated'

exec spDT_Link 1, '20210726-65', '20210726-66'    -- type 1 - CaseLinkCase

-- generate 1 closed and 1 Legal Hold cases first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-04-24 20:39:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2011-06-24 17:31:17.280','Yes', 'UnSubstantiated'

exec spDT_Link 1, '20210726-67', '20210726-68'    -- type 1 - CaseLinkCase

--run task scheduler Depersonalization here and verify the email
--should be 2 cases have been deleted and reported in the email, case numbers can be verified

--5--  2 CaseLinkIR
-- generate 1 closed case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'

exec spDT_Link 2, '20210726-69', '20210726-47'   --2 CaseLinkIR


-- generate 1 closed case and 1 open IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Open', '2018-07-24 20:12:17.280','No'

exec spDT_Link 2, '20210726-70', '20210726-48'   --2 CaseLinkIR

-- generate 1 closed case and 1 Legal Hold IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','Yes'

exec spDT_Link 2, '20210726-71', '20210726-49'   --2 CaseLinkIR

-- generate 1 open case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Open', '2018-07-23 20:39:17.280','No', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'

exec spDT_Link 2, '20210726-72', '20210726-50'   --2 CaseLinkIR

-- generate 1 Legal Hold case and 1 closed IR first, then link them 
exec spDT_CreateTestCase 'laxsubl', 'hwanghan', 'Close', '2018-07-23 20:39:17.280','Yes', 'Substantiated'
exec spDT_CreateTestIR 'laxsubl', 'Close', '2018-07-24 20:12:17.280','No'

exec spDT_Link 2, '20210726-73', '20210726-51'   --2 CaseLinkIR

--run task scheduler Depersonalization here and verify the email
--should be the linked 1 closed cases and 1 closed IR have been deleted and reported in the email
--case number and IR number can be verified




exec spDT_Link 3, '20210725-7', '20210725-8'    --3 IRLinkIR
exec spDT_Link 3, '20210726-10', '20210726-11'    --3 IRLinkIR

exec spDT_Link 4, '250721-49', '20210725-11'    --4 EAlertLinkCase
exec spDT_Link 4, '260721-52', '20210726-12'    --4 EAlertLinkCase

exec spDT_Link 4, '260721-56', '20210726-13'    --4 EAlertLinkCase

exec spDT_Link 5, '250721-51', '20210725-9'     --5 EAlertLinkIR
exec spDT_Link 5, '260721-53', '20210726-13'     --5 EAlertLinkIR


exec spDT_Link 5, '260721-57', '20210726-15'     --5 EAlertLinkIR


exec spDT_Link 4, '260721-58', '20210726-19'    --4 EAlertLinkCase

exec spDT_Link 5, '260721-59', '20210726-20'     --5 EAlertLinkIR

exec spDT_Link 4, '260721-60', '20210726-20'    --4 EAlertLinkCase


----
exec spDT_Link 1, '20210726-21', '20210726-22'    --1 CaseLinkCase
exec spDT_Link 2, '20210726-23', '20210726-21'   --2 CaseLinkIR
exec spDT_Link 3, '20210726-24', '20210726-25'    --3 IRLinkIR



