truncate table Deleted_CaseIDs
truncate table Deleted_IrIDs
truncate table Deleted_EirIDs
truncate table Deleted_TaskIDs

select * from Deleted_CaseIDs order by CaseNumber
select * from Deleted_IrIDs order by CaseNumber
select * from Deleted_EirIDs order by CaseNumber

select CaseNumber, CaseStatusID, CaseCreatorID, CaseClosedDT, CaseClosedUTC, CaseCreatedUTC,CaseCreatedDT,ReportedDateDT,ReportedDateUTC, * 
from NCase
where CaseClosedUTC is NOT NULL 
      and CaseNumber NOT in ( select CaseNumber from Deletable_CaseIDs  )

select * from Deletable_CaseIDs
select * from Deletable_IRIDs
select * from Deletable_EirIDs 

select * from Deletable_CaseIDs_temp where CaseNumber='20210723-10'
select * from Deletable_CaseIDs where  CaseNumber='20210723-10'

exec spDT_ClearExpiredRecords '2021-07-25 18:47:21.453'

select * from Deleted_CaseIDs  where CaseNumber='210721000008' 

select * from Deleted_CaseIDs  where CaseNumber='210721000006' or CaseNumber='210721000007'   -- some thing strenge here
select * from Deleted_IrIDs where CaseNumber='20210721-6'                                     -- don't know why this IR cant delete

select * from Deleted_CaseIDs  where CaseNumber='210721000005' 
select * from Deleted_IrIDs where CaseNumber='20210721-4'  or CaseNumber='20210721-5' 

select * from Deleted_IrIDs where CaseNumber='20210720-6' or CaseNumber='20210720-7' or CaseNumber='20210720-8'

select * from Deleted_CaseIDs  where CaseNumber='210720000004' 
select * from Deleted_EirIDs  where CaseNumber='200721-47'

select * from Deleted_IrIDs where CaseNumber='20210719-11' or CaseNumber='20210719-12' 
select * from Deleted_CaseIDs  where CaseNumber='210719000012' 

select * from Deleted_IrIDs where CaseNumber='20210722-1'
select * from Deleted_TaskIDs

select * from Deleted_EirIDs  where CaseNumber='200721-48'

select * from Deleted_CaseIDs

where CaseNumber='201112000601'
--where CaseNumber='210620000001'
--where CaseNumber='201112000599'
--where CaseNumber='210603000028'
--where CaseNumber='201112000024'
--where CaseNumber='201112000586'
--where CaseNumber='201112000590' or CaseNumber='201112000601' or CaseNumber='201112000602' 
order by CaseNumber
select * from Deleted_EirIDs
where CASENUMBER='220621-23'


select * from Deleted_IrIDs where CaseNumber='20210620-5'
select * from Deleted_EirIDs where CaseNumber='200621-11'

select * from Deleted_TaskIDs
select * from Deleted_EirIDs
where CASENUMBER='200621-11'

select * from Deleted_IrIDs 
where CaseNumber='20210620-5'
--where CaseNumber='20210620-5'
--where CaseNumber='20210619-3' or CaseNumber='20210619-4' or CaseNumber='20210619-5'
order by IR_ID 

select CaseClosedUTC, * from NCase where CaseNumber='210603000018'
select * from NCase_OPTN_NCase where caseid=12157


select * from Deleted_EirIDs

select * from Deleted_TaskIDs




select top 1000 CLOSE_DATE, * from IR_IR where CASE_NUMBER='20210608-1'



select * from[Depersonalization_Deleted_Case_History_temp]
select * from Depersonalization_Deleted_Case_History


----------------------------------------------
select PersonID, CAI, PersonTypeID, Building, *
from NPerson
where PersonTypeId=2301 
      and CAI = 'hwanghan';

update NPerson
set Building='MAD9'
where PersonTypeId=2301 
      and CAI = 'hwanghan';

select * 
from IR_MAP_IR_MAP_sample_facman_data#csv
where name in ('HUN2')

select *
from demo.IR_MAP_CountryISOCode
where Country='Hungary'

select * from Depersonalization_DataRetention_Map
where CountryISOCode='HUN'


Substantiated = 'Yes' and 
-------------------------------------------------


select p.PersonID, p.CAI, p.PersonTypeID, p.Building,c.country,d.*
from NPerson p
	join IR_MAP_IR_MAP_sample_facman_data#csv c on c.name=p.Building
	join demo.IR_MAP_CountryISOCode cc			on cc.Country=c.country 
	join Depersonalization_DataRetention_Map d	on cc.Code=d.CountryISOCode
where PersonTypeId=2301 and CAI = 'hwanghan';



select * from Depersonalization_DataRetention_Map

