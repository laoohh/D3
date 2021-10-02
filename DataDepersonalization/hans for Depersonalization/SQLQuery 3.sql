--Run exec spDT_CreateTestEIR ‘AssigneeUserName’, ‘ArchiveByUserName’, ‘ArchiveDate’ to generate a new test EIR. For example, 
exec spDT_CreateTestEIR 'hwanghan', 'laxsubl', '2007-06-24 17:31:17.280'
exec spDT_CreateTestEIR 'hwanghan',NULL, NULL


--Run exec spDT_CreateTestIR ‘AssigneeUserName’, ‘IRStatus’, ‘CoseDate’, ‘LegalHoldValue’ to generate a new test IR. For example, 
exec spDT_CreateTestIR 'hwanghan', 'Close', '2018-07-24 20:12:17.280','No'
exec spDT_CreateTestIR 'hwanghan', 'Open', '2011-06-24 17:31:17.280','No'
exec spDT_CreateTestIR 'hwanghan', 'Close', '2011-06-24 17:31:17.280','Yes'


--Run exec spDT_CreateTestEIR ‘AssigneeUserName’ to generate a new test Case. For example, 
exec spDT_CreateTestCase 'hwanghan', 'laxsubl', 'Close', '2018-07-23 20:39:17.280','No', 'Substantiated' --'Substantiated'  --   --'Partially Substantiated'
exec spDT_CreateTestCase 'hwanghan', 'laxsubl', 'Close', '2021-04-24 20:39:17.280','No', 'UnSubstantiated'
exec spDT_CreateTestCase 'hwanghan', 'laxsubl', 'Close', '2018-07-24 22:06:17.280','No', 'Partially Substantiated'

exec spDT_CreateTestCase 'hwanghan', 'laxsubl', 'Open', '2011-06-24 17:31:17.280','No', 'Substantiated'
exec spDT_CreateTestCase 'hwanghan', 'laxsubl', 'Close', '2011-06-24 17:31:17.280','Yes', 'UnSubstantiated'

--Type options: 1 CaseLinkCase; 2 CaseLinkIR; 3 IRLinkIR; 4 EAlertLinkCase; 5 EAlertLinkIR
exec spDT_Link 1, '20210725-8', '20210725-9'    --1 CaseLinkCase
exec spDT_Link 1, '20210725-9', '20210725-8'    --1 CaseLinkCase

exec spDT_Link 2, '20210725-10', '20210725-6'   --2 CaseLinkIR

exec spDT_Link 3, '20210725-7', '20210725-8'    --3 IRLinkIR
exec spDT_Link 3, '20210726-10', '20210726-11'    --3 IRLinkIR

exec spDT_Link 4, '250721-49', '20210725-11'    --4 EAlertLinkCase
exec spDT_Link 4, '260721-52', '20210726-12'    --4 EAlertLinkCase

exec spDT_Link 5, '250721-51', '20210725-9'     --5 EAlertLinkIR
exec spDT_Link 5, '260721-53', '20210726-13'     --5 EAlertLinkIR






