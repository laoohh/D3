declare 	@ExpireDateBaseLine_UTC datetime = getUTCDate()
exec spDT_ClearExpiredRecords @ExpireDateBaseLine_UTC


select * from Deleted_CaseIDs  order by CASEID
select * from Deleted_IrIDs   order by IR_ID
select * from Deleted_EirIDs order by IR_ID


select count(*) from NCase
select count(*) from IR_IR
select count(*) from EIR_IR


select CaseID, CaseNumber  
into Cases4link
from Ncase
where CaseClosedUTC is NOT NULL
order by CaseID desc

select top 1000 * from Cases4link order by caseID desc
select top 1000 * from IR4link order by IR_ID desc

select count(*) from Cases4link
select count(*) from IR4link


select IR_ID, CASE_NUMBER
into IR4link
from IR_IR
where CLOSE_DATE is not null
order by IR_ID desc


truncate table LegalHoleCases
drop table LegalHoleCases

select * from EIR_IR
--where ArchiveBy = 101288
where ToID is not null or ToCase is not null
order by IR_ID desc

update EIR_IR 
set REPORT_DATE='2021-07-14 3:16:55.847',
	ArchiveDate=NULL,
	ArchiveBy=NULL,
	EMPL_ID=NULL
where IR_ID = 90


truncate table Deleted_CaseIDs
truncate table Deleted_IrIDs
truncate table Deleted_EirIDs
truncate table Deleted_TaskIDs
--exec spDT_ClearExpiredRecords '2020-08-09 16:40:17.280'

declare 	@ExpireDateBaseLine_UTC datetime = getUTCDate()
print @ExpireDateBaseLine_UTC
exec spDT_ClearExpiredRecords @ExpireDateBaseLine_UTC

select * from Depersonalization_DataRetention_Import_Log order by 1 desc

select * from Deleted_CaseIDs  order by CASEID
select * from Deleted_IrIDs   order by IR_ID
select * from Deleted_EirIDs order by IR_ID

select * from Deletable_CaseIDs   order by CASEID
select * from Deletable_IrIDs 
select * from Deletable_EirIDs 

select * from Deletable_CaseIDs_Removed 
select * from Deletable_IrIDs_Removed 

select count(*) from NCase
select count(*) from IR_IR
select count(*) from EIR_IR

select * from NCase order by CaseID desc
select * from IR_IR order by IR_ID desc
select * from EIR_IR

select * from Deleted_NCaseOwner
select * from Deleted_NCase_OPTN_NCase
select * from Deleted_NCase_TXT
select * from Deleted_EIR_IR
select * from Deleted_NCaseLinkedIR
select * from Deleted_NCaseLinkedTask
select * from Deleted_NCaseLinkedCase
select * from Deleted_NAttachment
select * from Deleted_NCasePersonInjury
select * from Deleted_NCasePerson
select * from Deleted_NCaseOrganizationRequest
select * from Deleted_NCaseOrganizationResponse
select * from Deleted_NCaseOrganization
select * from Deleted_NCaseItem
select * from Deleted_NCaseAssignmentHistory
select * from Deleted_NCaseAssignmentWildSearch

select * from Deleted_EIR_OPTION_EIR

select * from Deleted_IR_IR
select * from Deleted_IR_ATCHMNT_BA_LINK
select * from Deleted_IR_ATCHMNT_BA
select * from Deleted_IR_ATCHMNT


select * from Depersonalization_DataRetention_Map

select * from Depersonalization_Deleted_IR_History_temp
select * from Depersonalization_Deleted_Case_History_temp
select * from Depersonalization_Deleted_EIR_History_temp

select * from Depersonalization_Deleted_IR_History order by casenumber
select * from Depersonalization_Deleted_Case_History order by casenumber
select * from Depersonalization_Deleted_EIR_History order by StartTime_UTC


select * from Depersonalization_DataRetention_Import_Log order by id


exec sp_help Depersonalization_Deleted_Case_History_temp
exec sp_help Depersonalization_Deleted_IR_History_temp
exec sp_help Depersonalization_Deleted_EIR_History_temp





