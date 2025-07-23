  
CREATE PROCEDURE [EDS].[Adoption_SyncScopeWiseEDSTimesheetdata]   
AS  
BEGIN TRY  
BEGIN TRANSACTION  
  
CREATE TABLE #All  
(  
Esaprojectid nvarchar(50),  
Scope nvarchar(50)  
)  

DECLARE @Today DATE = CAST(GETDATE() AS DATE);
DECLARE @StartDate DATE;
DECLARE @EndDate DATE;

IF DAY(@Today) BETWEEN 1 AND 5
BEGIN
    -- Previous month range
    SET @StartDate = DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(@Today), MONTH(@Today), 1));
    SET @EndDate = EOMONTH(@StartDate);
END
ELSE
BEGIN
    -- Current month from 1st to today
    SET @StartDate = DATEFROMPARTS(YEAR(@Today), MONTH(@Today), 1);
    SET @EndDate = @Today;
END

--SELECT @StartDate
--SELECT @EndDate
  
INSERT INTO #All (Esaprojectid,Scope)  
SELECT DISTINCT EsaProjectId,'' from [EDS].[TimesheetDetail_All] WITH (NOLOCK) WHERE TimesheetSubmissionDate BETWEEN @StartDate AND @EndDate  
  
SELECT DISTINCT A.EsaProjectID,A.ProjectName,C.AttributeValueID AS ScopeId,D.AttributeValueName AS ScopeName INTO #ProjectScope   
FROM [EDS].[TimesheetDetail_All] A WITH (NOLOCK)
JOIN [$(AppVisionLensDB)].[AVL].[MAS_ProjectMaster] B WITH (NOLOCK) ON A.EsaProjectID=B.EsaProjectId  
JOIN [$(AppVisionLensDB)].[PP].[ProjectAttributeValues]  C WITH (NOLOCK) ON B.ProjectID=C.ProjectID  
JOIN [$(AppVisionLensDB)].[MAS].[PPAttributeValues] D WITH (NOLOCK) ON C.AttributeValueID=D.AttributeValueID  
WHERE C.AttributeID='1' AND B.EsaProjectId IN (SELECT EsaProjectID FROM #All) ORDER BY A.EsaProjectID  
  
Update A set a.Scope='AD'  
from #All A join #ProjectScope B   
on A.EsaProjectID=B.EsaProjectID where B.ScopeId in ('1')  
  
Update A set a.Scope='AD'  
from #All A   
join #ProjectScope B on A.EsaProjectID=B.EsaProjectID where B.ScopeId in ('4')  
  
Update A set a.Scope='AD + AVM'  
from #All A   
join #ProjectScope B on A.EsaProjectID=B.EsaProjectID where B.ScopeId in ('2')  
and A.Scope='AD'  
  
Update A set a.Scope='AVM'  
from #All A join #ProjectScope B on A.EsaProjectID=B.EsaProjectID where B.ScopeId in ('2')  
and A.Scope =''  
  
Update A set a.Scope= CONCAT(A.Scope ,' + INFRA')  
from #All A join #ProjectScope B on A.EsaProjectID=B.EsaProjectID where B.ScopeId in ('3')  
and A.Scope <> ''  
  
Update A set a.Scope= 'INFRA'  
from #All A join #ProjectScope B on A.EsaProjectID=B.EsaProjectID where B.ScopeId in ('3')  
and A.Scope = ''  
  
--Truncate table [EDS].[TimesheetDetail_All_Enhancement_AD]  
   
--insert into Discovereds.[EDS].[TimesheetDetail_All_Enhancement_AD] (EsaProjectID,ProjectName,ActivityCode,Hours,SubmitterID,Submitterdate,CreatedBy,CreatedDate,ActivityDescription,TimesheetStatus,TimesheetSubmissionDate)  
--select EsaProjectID,ProjectName,ActivityCode,Hours,SubmitterID,Submitterdate,CreatedBy,CreatedDate,ActivityDescription,TimesheetStatus,TimesheetSubmissionDate from [EDS].[TimesheetDetail_All_Enhancement]  
   
--delete from Discovereds.[EDS].[TimesheetDetail_All_Enhancement_AD]    
--where esaprojectid in (select esaprojectid from #All_Enhancement WHERE Scope NOT LIKE '%AD%')  

UPDATE A SET A.ProjectScope=B.Scope FROM [EDS].[TimesheetDetail_All] A 
JOIN #All B ON A.EsaProjectID=B.Esaprojectid
WHERE TimesheetSubmissionDate BETWEEN @StartDate AND @EndDate 
  
COMMIT TRANSACTION  
END TRY  
  
BEGIN CATCH  
  
 ROLLBACK TRANSACTION  
   
 DECLARE @ErrorMessage VARCHAR(MAX);             
 SELECT @ErrorMessage = ERROR_MESSAGE()     
   
END CATCH