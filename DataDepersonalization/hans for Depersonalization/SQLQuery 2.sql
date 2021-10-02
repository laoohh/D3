truncate table Deleted_CaseIDs
truncate table Deleted_IrIDs
truncate table Deleted_EirIDs
truncate table Deleted_TaskIDs
exec spDT_ClearExpiredRecords '2021-07-25 12:39:56'

select * from Deleted_CaseIDs 
select * from Deleted_IrIDs 
select * from Deleted_EirIDs 


select * from Depersonalization_DataRetention_Map


select * from Depersonalization_Deleted_Case_History_temp
select * from Depersonalization_Deleted_IR_History_temp
select * from Depersonalization_Deleted_EIR_History_temp

select * from Depersonalization_Deleted_IR_History
select * from Depersonalization_Deleted_Case_History
select * from Depersonalization_Deleted_EIR_History

select * from Depersonalization_DataRetention_Import_Log
