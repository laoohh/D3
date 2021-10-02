TSMC1\SQL2017
demo/DemoPassword

select * into Depersonalization_DataRetention_Map_bak
from Depersonalization_DataRetention_Map

select * from Depersonalization_DataRetention_Map
select * from Depersonalization_DataRetention_Map_Staging
select * from Depersonalization_DataRetention_Map_History

select PersonID, CAI, PersonTypeID, Building, *
from NPerson
where PersonTypeId=2301 
      and (CAI = 'hwanghan' or CAI = 'usa_amazon' or CAI = 'CMSDataMigration');



select PersonID, CAI, PersonTypeID, Building 
from NPerson
where Building like 'HUN%'

update NPerson
set    Building = 'HUN2'
where PersonID=307151

update NPerson
set	   Building='ABE2'
where  CAI = 'usa_amazon';


select *
     from demo.IR_MAP_CountryISOCode
    where Country like '%Hungary%'

select DISTINCT iso.Country, facman.country
from demo.IR_MAP_CountryISOCode iso
left join IR_MAP_IR_MAP_sample_facman_data#csv facman
	on iso.Country = facman.country

select DISTINCT iso.Country, facman.country
from demo.IR_MAP_CountryISOCode iso
right join IR_MAP_IR_MAP_sample_facman_data#csv facman
	on iso.Country = facman.country
where iso.Country is NULL

select DISTINCT country
from demo.IR_MAP_CountryISOCode
where   (country like '%Czech%')
     or (country like '%Taiwan%')
	 or (country like '%Kingdom%' )
	 or (country like 'United States of%')
	 or (country like '%Vie%')






select * from IR_MAP_IR_MAP_sample_facman_data#csv
--update IR_MAP_IR_MAP_sample_facman_data#csv
--set country='United States'
where country='United States of Amarica'

select * from demo.IR_MAP_CountryISOCode
--update  demo.IR_MAP_CountryISOCode
--set Country='United States of Amarica'
where Code='USA'

insert into IR_MAP_IR_MAP_sample_facman_data#csv Values ( 'Uzbekistan', 'UZB2' )
insert into IR_MAP_IR_MAP_sample_facman_data#csv Values ( 'Croatia', 'HRV3' )
insert into IR_MAP_IR_MAP_sample_facman_data#csv Values ( 'Hungary', 'HUN2' )

select * 
from IR_MAP_IR_MAP_sample_facman_data#csv
where country like '%Hungary%'



select * 
from IR_MAP_IR_MAP_sample_facman_data#csv
where name like 'HUN%'


select *
from demo.IR_MAP_CountryISOCode

insert IR_MAP_CountryISOCode Values ('USA','United States')	
insert IR_MAP_CountryISOCode Values ('UZB','Uzbekistan')	
insert IR_MAP_CountryISOCode Values ('BEL','Belgium')	
insert IR_MAP_CountryISOCode Values ('HRV','Croatia')	
insert IR_MAP_CountryISOCode Values ('HUN','Hungary')	

select * from Depersonalization_DataRetention_Map
where CountryISOCode in ('USA','UZB','BEL','HRV','HUN')
order by CountryISOCode desc, Substantiated desc

select * from Depersonalization_DataRetention_Map

update Depersonalization_DataRetention_Map
set  Rules='F+2',Year=2,Month=0
where CountryISOCode='HRV'

update Depersonalization_DataRetention_Map
set  Rules='F+2M',Year=0,Month=2
where CountryISOCode='BEL' and Year=2


select * from IR_MAP_IR_MAP_sample_facman_data#csv where name='BRU1'

select * from EIR_IR_Escalation_Map
select * from IR_OPTN where OPTION_NUMBER=3432

insert into EIR_IR_Escalation_Map
values ('Substantiated','Partial Substantiated',185,1297,3090)

update EIR_IR_Escalation_Map
set FieldValue='Yes'
where FieldValue='Partial Substantiated'

update EIR_IR_Escalation_Map
set SectionID = 185,
	ElementID = 1297,
	OptionID = 3065
where FieldName = 'Substantiated' and FieldValue = 'Yes';

update EIR_IR_Escalation_Map
set SectionID = 185,
	ElementID = 1297,
	OptionID = 3066
where FieldName = 'Substantiated' and FieldValue = 'No';

update EIR_IR_Escalation_Map
set SectionID = 185,
	ElementID = 1299,
	OptionID = 3067
where FieldName = 'Legal Hold' and FieldValue = 'Yes';

update EIR_IR_Escalation_Map
set SectionID = 185,
	ElementID = 1299,
	OptionID = 3068
where FieldName = 'Legal Hold' and FieldValue = 'No';


update EIR_IR_Escalation_Map
set SectionID = 216,
	ElementID = 1303,
	OptionID = 3080
where FieldName = 'Legal Hold IR' and FieldValue = 'Yes';

update EIR_IR_Escalation_Map
set SectionID = 216,
	ElementID = 1303,
	OptionID = 3081
where FieldName = 'Legal Hold IR' and FieldValue = 'No';


select * from IR_MAP_DataRetention_Map

select *
from IR_IR

select * 
from Case_His

select * from ncase order by CaseCreatedDT desc

select * from IR_IR 
order by CLOSE_DATE

select * from EIR_IR

update IR_IR set CLOSE_DATE='2010-05-27 21:10:43.230' where CLOSE_DATE='2010-05-27 21:10:43.230'


select * from D3CaseBrief


select * from Depersonalization_DataRetention_Map


--NCase
select top 1000  CaseNumber, CaseStatusID, CaseCreatorID, CaseClosedDT, CaseClosedUTC, CaseCreatedUTC,CaseCreatedDT,ReportedDateDT,ReportedDateUTC, * 
from NCase
where  CaseNumber='20210725-7' 

select top 100 CaseNumber, CaseStatusID, CaseCreatorID, CaseClosedDT, CaseClosedUTC, CaseCreatedUTC,CaseCreatedDT,ReportedDateDT,ReportedDateUTC,* from NCase
select count(*) from Ncase where CaseClosedUTC is NOT NULL


update NCase
set CaseClosedBy=101597,
	CaseStatusID=602
where CaseNumber='20210725-7'

select * from NListOption where ListID=6



where CaseCreatedUTC > '2021-05-01'
ORDER BY CaseCreatedUTC DESC

UPDATE NCase
SET    
		CaseCreatedUTC = '2018-04-26',
		CaseCreatedDT = '2018-04-26',
		CaseClosedUTC = '2018-04-26',
	   CaseClosedDT = '2018-04-26',
	   ReportedDateDT = '2018-04-26',
	   ReportedDateUTC= '2018-04-26'
where  CaseClosedUTC is not NULL and CaseNumber='20210725-7' --20210723-10 ---20210723-10

UPDATE NCase
SET    CaseClosedUTC = '2017-07-23',
		CaseClosedDT = '2017-07-23'
where CaseNumber='20210723-10' and CaseClosedUTC is not NULL

--IR_IR
select top 1000 CASE_NUMBER, CLOSE_DATE,EMPL_ID_CREATOR, TIMEZONE,TimeZoneId, * from IR_IR 
where Case_Number='20210724-4' or Case_Number='20210724-5' or CASE_NUMBER='20210720-6'
where CLOSE_DATE>'2021-05-01'
order by CLOSE_DATE desc

select CASE_NUMBER, CLOSE_DATE,EMPL_ID_CREATOR, TIMEZONE,TimeZoneId,* from IR_IR
select count(*) from IR_IR where CLOSE_DATE is NOT NULL

update IR_IR 
SET    EMPL_ID_CREATOR = 101284
where Case_Number='20210720-7'	
	
	10286

Update IR_IR 
set CLOSE_DATE = '2020-07-21'
where Case_number='20210720-7' and CLOSE_DATE is not NULL 

Update IR_IR 
set CLOSE_DATE = '2021-01-17',
	report_date = '2021-01-17',
	START_DATE = '2021-01-17',
	END_DATE = '2021-01-17',
	TIMESTAMP = '2021-01-17',
	DateModified = '2021-01-17',
	ReportingLocDate  = '2021-01-17',
	StartLocDate = '2021-01-17',
	EndLocDate = '2021-01-17',
	ReportingUTCDate = '2021-01-17',
	StartUTCDate = '2021-01-17',
	EndUTCDate  = '2021-01-17'
where Case_number='20210720-10' and CLOSE_DATE is not NULL 
where CLOSE_DATE is not NULL and CLOSE_DATE>'2021-05-01'

Update IR_IR 
set 
	CLOSE_DATE  = '2021-01-21'
where Case_number='20210722-1' and CLOSE_DATE is not NULL 

-- EIR_IR  E-Alert
select * from EIR_INSTANCE
update EIR_INSTANCE
set INSTANCE_NAME='Unregistered Asset'
where INSTANCE_ID=3

select * from EIR_IR

select CASE_NUMBER, ArchiveDate, ArchiveBy, REPORT_DATE, EMPL_ID_REPORT,EMPL_ID,  * from EIR_IR
--update EIR_IR
--set ArchiveDate = '2021-01-10'
where CASE_NUMBER='220721-30' 
order by report_date desc

update EIR_IR
set ArchiveDate = '2021-05-18',
	REPORT_DATE = '2021-05-18',
	EMPL_ID = NULL
where CASE_NUMBER='200721-44'

select top 1000 * from EIR_IR_STATUS




Update EIR_IR set ArchiveDate = '2001-06-01', ArchiveBy='101288'
where CASE_NUMBER = '160721-40'

Update EIR_IR set report_date = '2020-06-01'
select top 1000 * from EIR_IR
where CASE_NUMBER = '210621-19'  

delete from EIR_IR where IR_ID=37


--IR Status
select * from vwIR_Status

--verify options of Legal Hold
select top 1000 CLOSE_DATE, * from IR_IR 
where Case_number='20210719-7'

select * from IR_OPTN_IR o 
join [EIR_IR_Escalation_Map]  lh on lh.[SectionID]=o.SCTN_ID and lh.[ElementID]=o.ITEM_ID and lh.OptionID=o.OPTION_NUMBER
where IR_ID= 28666

select * from IR_OPTN_IR
--delete from IR_OPTN_IR
where OPTN_IR_ID=332958 or OPTN_IR_ID=332851

select * from NCase_OPTN_NCase o
join [EIR_IR_Escalation_Map]  lh on lh.[SectionID]=o.SCTN_ID and lh.[ElementID]=o.ITEM_ID and lh.OptionID=o.OPTION_NUMBER
where CaseID= 12107

select * from NCase_OPTN_NCase
--delete from NCase_OPTN_NCase 
where CaseID= 12107 and SCTN_ID=185 and OPTION_NUMBER>3060 and ITEM_ID=1299

select * from EIR_OPTION_EIR

select top 1000  CaseClosedDT, CaseClosedUTC, * from NCase
where CaseNumber='201112000599'   

select * from NCaseOwner
where CaseID=12107

select PersonID, CAI, PersonTypeID, Building, *
from NPerson
where PersonID=101201


-- Case Linked IR
select IncidentID, *
from NCaseLinkedIR
where IncidentID=28610

delete from NCaseLinkedIR
where IncidentID=28610


select top 1000 CLOSE_DATE, * from IR_IR 
where Case_number='20210608-10'

-- end of case linked IR

--check the country relationship
----------------------------------------------
select PersonID, CAI, PersonTypeID, Building
from NPerson
where PersonTypeId=2301 
      and CAI = 'CMSDataMigration';

select * 
from IR_MAP_IR_MAP_sample_facman_data#csv
where name in ('HUN2')

select *
from demo.IR_MAP_CountryISOCode
where Country='Hungary'

select * from Depersonalization_DataRetention_Map
where CountryISOCode='HUN'


select p.PersonID, p.CAI, p.PersonTypeID, p.Building,c.country,d.*
from NPerson p
	join IR_MAP_IR_MAP_sample_facman_data#csv c on c.name=p.Building
	join demo.IR_MAP_CountryISOCode cc			on cc.Country=c.country 
	join Depersonalization_DataRetention_Map d	on cc.Code=d.CountryISOCode
where PersonTypeId=2301 and CAI = 'hun_amazon';

-------------------------------------------------


--Testing
select top 1000 CLOSE_DATE, * from IR_IR

select top 1000 * from EIR_IR
where CASE_NUMBER='080621-28'

select top 1000  CaseClosedDT, CaseClosedUTC, * from NCase
where CaseNumber='201112000599'   

select * from NCaseHistory

select * from NCase_OPTN_NCase o
join [EIR_IR_Escalation_Map]  lh on lh.[SectionID]=o.SCTN_ID and lh.[ElementID]=o.ITEM_ID and lh.OptionID=o.OPTION_NUMBER
where CaseID= 12109


select * from Depersonalization_DataRetention_Map
where CountryISOCode in ('HUN','HRV','BEL','UZB','USA')

update Depersonalization_DataRetention_Map
set rules = 'F+180D', Year=0, Day=180
where CountryISOCode='HUN' and Substantiated = 'Yes'

update Depersonalization_DataRetention_Map
set rules = 'F+12M', Year=0, Month=12
where CountryISOCode='BEL' and Substantiated = 'Yes'


-- history of case Legal Hold
select a.CaseID, h.HistoryUTC, D.*,
		ROW_NUMBER() OVER (PARTITION BY a.CaseID ORDER BY d.HistoryID desc) AS rn
from Deleted_CaseIDs a
	join NCaseHistory h on a.CaseID=h.CaseID
	join NCaseHistoryData d on h.HistoryID=d.HistoryID
	join EIR_IR_Escalation_Map m on m.ElementID=d.FieldID and m.FieldValue=d.NewValue
	where m.FieldName='Legal Hold' and  d.NewValue='Yes'

select * from EIR_IR_Escalation_Map

select * from ncase where CaseNumber='210721000006'

select QueueUTC, d.* ,h.*
from NCaseHistoryData  d
join NCaseHistory h on h.HistoryID=d.HistoryID
where h.CaseID=12264 and d.FieldID=1299
order by h.HistoryUTC 

select * from NCaseHistory
select * from NCaseHistoryData

select * from NCaseHistoryData
where FieldID=1299 and historyID in (12523,12527,12528)
order by HistoryID

select * from NCaseHistory
update NCaseHistory
set HistoryUTC='2021-07-06',
HistoryDT='2021-07-06'
where CaseID=12264 and  historyID in (12528)
order by HistoryID

-- history of IR Legal Hold
--IR history
	select a.IR_ID, [dbo].[ConvertUTCTimeByTimeZone](b.DateModified, b.TimeZoneId) as DateModifiedUTC,
		ROW_NUMBER() OVER (PARTITION BY a.IR_ID ORDER BY ob.OPTN_IR_ID desc) AS rn
	from Deleted_IrIDs_Temp a
	join IR_IR_BA b on a.casenumber=b.CASE_NUMBER
	join IR_OPTN_IR_BA ob on b.IR_ID=ob.IR_ID
	join EIR_IR_Escalation_Map m on ob.ITEM_ID=m.ElementID and ob.OPTION_NUMBER=m.OptionID
	where m.FieldName='Legal Hold IR' and m.FieldValue='yes' 


select * from IR_IR where CASE_NUMBER='20210608-5'
update IR_IR
set START_DATE='2001-05-01',
	END_DATE='2001-06-01',
	DateModified='2001-06-01',
	StartLocDate='2001-05-01',
	EndLocDate='2001-06-01',
	EndUTCDate='2001-06-01',
	StartUTCDate='2001-05-01',
	TIMESTAMP='2001-06-01'
where CASE_NUMBER='20210608-5'

select top 1000 CLOSE_DATE, * from IR_IR 
where Case_number='20210719-11'

select TIMESTAMP,DateModified,* from IR_IR_BA 
where CASE_NUMBER='20210720-10'
      and IR_ID in(10331,10332,10337,10338)

select * from IR_OPTN_IR_BA 
where ITEM_ID=1303 and OPTION_NUMBER in (3080,3081)
	  and IR_ID in (select IR_ID from IR_IR_BA where CASE_NUMBER='20210720-10')

delete from IR_OPTN_IR_BA 
where ITEM_ID=1303 and OPTION_NUMBER in (3080,3081)
	  and IR_ID in (select IR_ID from IR_IR_BA where CASE_NUMBER='20210720-8')
 

select * from EIR_IR_Escalation_Map

update IR_IR_BA 
set 
	DateModified='2021-07-07'	
where CASE_NUMBER='20210720-10'
      and IR_ID in(10332,10337,10338)


update IR_IR_BA 
set START_DATE='2001-05-01',
	END_DATE='2001-06-01',
	DateModified='2001-06-07',
	StartLocDate='2001-05-01',
	EndLocDate='2001-06-01',
	EndUTCDate='2001-06-01',
	StartUTCDate='2001-05-01',
	TIMESTAMP='2001-06-07'
where CASE_NUMBER='20210608-5'
      and IR_ID =10269


--Deleting

select * from Deleted_CaseIDs order by CaseNumber

exec spDT_ClearExpiredRecords '2021-06-09 21:38:21.453'
exec spDT_ClearExpiredRecords '2021-06-09 17:02:57.523'
exec [spDT_GetExpiredCase] '2021-06-09 21:38:21.453'

truncate table Deleted_CaseIDs
exec spDT_GetExpiredCase '2021-06-09 21:38:21.453'
select * from Deleted_CaseIDs

truncate table Deleted_IrIDs
exec spDT_GetExpiredIR '2021-06-09 21:38:21.453', 1
select * from Deleted_IrIDs


delete from Deleted_CaseIDs

truncate table Deleted_CaseIDs
truncate table Deleted_IrIDs
truncate table Deleted_EirIDs
truncate table Deleted_TaskIDs
exec spDT_ClearExpiredRecords '2021-06-18 21:38:21.453'


select * from Deleted_CaseIDs 
where CaseNumber='201112000601' or CaseNumber='210603000024' 
order by CaseNumber

select * from Deleted_IrIDs where CaseNumber='20210608-1'
select * from Deleted_EirIDs
select * from Deleted_TaskIDs

SELECT * FROM Deleted_EIR_IR
SELECT * FROM Deleted_Entity_Task




--all cases could be delelted
select c.CaseID, c.CaseNumber, c.CaseClosedUTC, lh.FieldValue as lh, Sub.FieldValue as sub, p.Building, r.Rules, mc.Country,
	ROW_NUMBER() OVER (PARTITION BY c.CaseID ORDER BY co.ID) AS rn
	from ncase c
	left join NCase_OPTN_NCase o on c.CaseID=o.CaseID
	left join [EIR_IR_Escalation_Map] lh on  lh.[SectionID]=o.SCTN_ID and lh.[ElementID]=o.ITEM_ID and lh.OptionID=o.OPTION_NUMBER
	join NCase_OPTN_NCase o2 on c.CaseID=o2.CaseID
	join [EIR_IR_Escalation_Map] Sub on  Sub.[SectionID]=o2.SCTN_ID and Sub.[ElementID]=o2.ITEM_ID and Sub.OptionID=o2.OPTION_NUMBER
	join NCaseOwner co on co.CaseID=c.CaseID
	join IR_EMPL e on co.CaseOwnerID=e.EMPL_ID
	join NPerson p on e.USERNAME=p.CAI
	join dbo.IR_MAP_IR_MAP_sample_facman_data#csv mc on mc.name=p.Building
	join Depersonalization_DataRetention_Map r on r.Substantiated = sub.FieldValue
		and r.Country= mc.Country
	where c.CaseStatusID=602 
		  and lh.[FieldName]='Legal Hold' 
		  and not( isnull(lh.FieldValue, 'No')='Yes') 
		  and sub.[FieldName]='Substantiated' 
		  and p.IsOriginal=1 and p.PersonTypeID=2301 
		  and DATEADD(year, -r.[Year], DATEADD(month, -r.[Month], DATEADD(day, -r.[Day], GETUTCDATE()))) > c.CaseClosedUTC
order by c.CaseNumber

select * from ncase where CaseID = 12214
select * from NCase_OPTN_NCase where CaseID = 12215 and SCTN_ID=185
select * from EIR_IR_Escalation_Map
select * from NCaseOwner where CaseID = 12215
select * from IR_EMPL where EMPL_ID = 101201
select * from NPerson where CAI = 'CMSDataMigration'
select * from IR_MAP_IR_MAP_sample_facman_data#csv where name='ABE3'
select * from Depersonalization_DataRetention_Map where 




--debug here for case
truncate table Deleted_CaseIDs

declare @ExpireDateBaseLine_UTC datetime = getutcdate()

;WITH cte AS
(
	select c.CaseID, c.CaseNumber, c.CaseClosedUTC, lh.FieldValue as lh, Sub.FieldValue as sub, r.Rules, p.Building, mc.Country,
	ROW_NUMBER() OVER (PARTITION BY c.CaseID ORDER BY co.ID) AS rn
	from ncase c
	left join NCase_OPTN_NCase o on c.CaseID=o.CaseID
	left join [EIR_IR_Escalation_Map] lh on  lh.[SectionID]=o.SCTN_ID and lh.[ElementID]=o.ITEM_ID and lh.OptionID=o.OPTION_NUMBER
	join NCase_OPTN_NCase o2 on c.CaseID=o2.CaseID
	join [EIR_IR_Escalation_Map] Sub on  Sub.[SectionID]=o2.SCTN_ID and Sub.[ElementID]=o2.ITEM_ID and Sub.OptionID=o2.OPTION_NUMBER
	join NCaseOwner co on co.CaseID=c.CaseID
	join IR_EMPL e on co.CaseOwnerID=e.EMPL_ID
	join NPerson p on e.USERNAME=p.CAI
	join dbo.IR_MAP_IR_MAP_sample_facman_data#csv mc on mc.name=p.Building
	join Depersonalization_DataRetention_Map r on r.Substantiated = sub.FieldValue
		and r.Country= mc.Country
	where c.CaseStatusID=602 and lh.[FieldName]='Legal Hold' and not( isnull(lh.FieldValue, 'No')='Yes') and sub.[FieldName]='Substantiated' 
		  and p.IsOriginal=1 and p.PersonTypeID=2301 
		  and DATEADD(year, -r.[Year], DATEADD(month, -r.[Month], DATEADD(day, -r.[Day], @ExpireDateBaseLine_UTC))) > c.CaseClosedUTC
)
insert into Deleted_CaseIDs(CaseID, casenumber, CloseDate, LegalHold, Substantiated, Rules, BuildingCode, Country, num)
SELECT *
FROM cte
WHERE rn = 1

select * from Deleted_CaseIDs order by CaseID;


truncate table temp_caseIDs

;WITH cte1 AS
(
	select a.CaseID, h.HistoryUTC,
		ROW_NUMBER() OVER (PARTITION BY a.CaseID ORDER BY d.HistoryID desc) AS rn
	from Deleted_CaseIDs a
	join NCaseHistory h on a.CaseID=h.CaseID
	join NCaseHistoryData d on h.HistoryID=d.HistoryID
	join EIR_IR_Escalation_Map m on m.ElementID=d.FieldID and m.FieldValue=d.NewValue
	where m.FieldName='Legal Hold' and  d.NewValue='Yes'
)
SELECT CaseID into temp_caseIDs
FROM cte1
WHERE rn = 1 and DATEADD(day, -14, GETUTCDATE())<HistoryUTC

select * from temp_caseIDs
--End debug case



-- debug here for IR

-- Linked to a case
truncate table Deleted_IrIDs

	declare @ExpireDateBaseLine_UTC datetime = getutcdate()
    declare @Substantiated  nvarchar(128) = 'Yes'

	select  i.IR_ID, 
			i.CASE_NUMBER as [IRnumber], 
			[dbo].[ConvertUTCTimeByTimeZone](i.CLOSE_DATE, i.TimeZoneId) as [IRcloseDate], 
			lh.FieldValue, 
			@Substantiated as [Substantiated], 
			a.CaseNumber
	from Deleted_CaseIDs a
	join NCaseLinkedIR l on a.CaseID=l.CaseID
	join IR_IR i on i.IR_ID=l.IncidentID
	join IR_OPTN_IR o on i.IR_ID=o.IR_ID
	join [EIR_IR_Escalation_Map] lh on  lh.[SectionID]=o.SCTN_ID and lh.[ElementID]=o.ITEM_ID and lh.OptionID=o.OPTION_NUMBER
	where lh.[FieldName]='Legal Hold IR' and  not (isnull(lh.FieldValue, 'No')='Yes')
	      AND i.STATUS=3   --Closed IR


select * from IR_IR i where IR_ID = 28615 
select * from Deleted_IrIDs;

-- Individual IRs
	declare @ExpireDateBaseLine_UTC datetime = getutcdate()
    declare @Substantiated  nvarchar(128) = 'Yes'

	select distinct 
			a.IR_ID, 
			a.CASE_NUMBER,
			[dbo].[ConvertUTCTimeByTimeZone](a.CLOSE_DATE, a.TimeZoneId), 
			lh.FieldValue as lh_FieldValue, 
			@Substantiated as sub, 
			r.Rules, 
			p.Building, 
			mc.Country
	from IR_IR a
	left join IR_OPTN_IR o on a.IR_ID=o.IR_ID
	left join [EIR_IR_Escalation_Map] lh on  lh.[SectionID]=o.SCTN_ID and lh.[ElementID]=o.ITEM_ID and lh.OptionID=o.OPTION_NUMBER
	join IR_EMPL e on a.EMPL_ID_REPORT=e.EMPL_ID
	join NPerson p on e.USERNAME=p.CAI
	join dbo.IR_MAP_IR_MAP_sample_facman_data#csv mc on mc.name=p.Building
	join Depersonalization_DataRetention_Map r on r.Substantiated = @Substantiated
		and r.Country= mc.Country
	where a.STATUS=3 and a.CASE_NUMBER='20210608-12'
			and lh.[FieldName]='Legal Hold IR' and not ( isnull(lh.FieldValue, 'No')='Yes')
			and p.IsOriginal=1 
			and DATEADD(year, -r.[Year], DATEADD(month, -r.[Month], DATEADD(day, -r.[Day], @ExpireDateBaseLine_UTC))) >  [dbo].[ConvertUTCTimeByTimeZone](a.CLOSE_DATE, a.TimeZoneId)

select * from [EIR_IR_Escalation_Map] lh
where lh.[FieldName]='Legal Hold IR'

select * from IR_IR where CASE_NUMBER='20210608-12'



