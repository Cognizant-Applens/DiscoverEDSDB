CREATE PROCEDURE [EDS].[Adoption_SyncESATimesheetDetails]       
      
AS      
      
BEGIN TRY      
      
 BEGIN TRANSACTION      
        
  --Sync Timesheet Detail All      
  BEGIN      
    
   --Copy of EDS.TimesheetDetail    
   SELECT * INTO #EDSTimesheetDetail FROM EDS.TimesheetDetail with (nolock)   
      
   --To insert the consolidated Hours in EDS.TimesheetDetail      
   SELECT DISTINCT EsaProjectID,ProjectName,ActivityCode,SUM(Hours) AS Hours,SubmitterId,Submitterdate,CreatedBy,CreatedDate,ActivityDescription,TimesheetSubmissionDate      
   INTO #Temp_Sum FROM #EDSTimesheetDetail      
   GROUP BY EsaProjectID,ProjectName,ActivityCode,SubmitterId,Submitterdate,CreatedBy,CreatedDate,ActivityDescription,TimesheetSubmissionDate      
   HAVING COUNT(SubmitterId)>1 ORDER BY TimesheetSubmissionDate DESC      
         
   --SELECT * FROM #Temp_Sum    
         
   DELETE A FROM #EDSTimesheetDetail A JOIN #Temp_Sum B ON A.EsaProjectID=B.EsaProjectID AND A.ProjectName=B.ProjectName AND      
   A.ActivityCode=B.ActivityCode AND A.SubmitterId=B.SubmitterId AND A.Submitterdate=B.Submitterdate AND A.CreatedBy=B.CreatedBy AND      
   A.CreatedDate=B.CreatedDate AND A.ActivityDescription=B.ActivityDescription AND A.TimesheetSubmissionDate=B.TimesheetSubmissionDate      
         
   INSERT INTO #EDSTimesheetDetail (EsaProjectID,ProjectName,ActivityCode,Hours,SubmitterId,Submitterdate,CreatedBy,CreatedDate,ActivityDescription,TimesheetSubmissionDate)      
   SELECT EsaProjectID,ProjectName,ActivityCode,Hours,SubmitterId,Submitterdate,CreatedBy,CreatedDate,ActivityDescription,TimesheetSubmissionDate FROM #Temp_Sum      
     
   --Updating status from EDS.TimesheetDetail    
   SELECT DISTINCT EsaProjectId,ActivityCode,SubmitterId,TimesheetStatus,TimesheetSubmissionDate INTO #StatusUpdate FROM EDS.TimesheetDetail    
    
   UPDATE A SET A.TimesheetStatus=B.TimesheetStatus FROM #EDSTimesheetDetail A JOIN #StatusUpdate B ON A.EsaProjectId=B.EsaProjectId    
   AND A.ActivityCode=B.ActivityCode AND A.SubmitterId=B.SubmitterId AND A.TimesheetSubmissionDate=B.TimesheetSubmissionDate    
    
   MERGE [EDS].[TimesheetDetail_All] A USING #EDSTimesheetDetail B      
         
   ON A.EsaProjectId=B.EsaProjectId AND A.ProjectName=B.ProjectName AND A.ActivityCode=B.ActivityCode AND A.SubmitterId=B.SubmitterId AND A.TimesheetSubmissionDate=B.TimesheetSubmissionDate      
   AND A.ActivityDescription=B.ActivityDescription      
         
   WHEN MATCHED AND B.TimesheetStatus IN ('APR','SUB') THEN      
         
   UPDATE SET A.Hours=B.Hours,A.TimesheetStatus=B.TimesheetStatus,A.CreatedDate=B.CreatedDate,A.SubmitterDate=B.SubmitterDate,A.ModifiedBy='Applens',A.ModifiedDate=GETDATE()      
         
   WHEN NOT MATCHED BY TARGET AND B.TimesheetStatus IN ('APR','SUB') THEN      
         
   INSERT (EsaProjectId,ProjectName,ActivityCode,Hours,SubmitterID,Submitterdate,CreatedBy,CreatedDate,ActivityDescription,TimesheetStatus,TimesheetSubmissionDate,ModifiedBy,ModifiedDate)      
   VALUES (B.EsaProjectId,B.ProjectName,B.ActivityCode,B.Hours,B.SubmitterID,B.Submitterdate,B.CreatedBy,B.CreatedDate,B.ActivityDescription,B.TimesheetStatus,B.TimesheetSubmissionDate,NULL,GETDATE());      
          
  END      
      
  -- Separate DELETE statement    
DELETE FROM [EDS].[TimesheetDetail_All]    
WHERE EXISTS (    
    SELECT 1    
    FROM #EDSTimesheetDetail B    
    WHERE [EDS].[TimesheetDetail_All].EsaProjectId = B.EsaProjectId    
    AND [EDS].[TimesheetDetail_All].ProjectName = B.ProjectName    
    AND [EDS].[TimesheetDetail_All].SubmitterId = B.SubmitterId    
    AND [EDS].[TimesheetDetail_All].TimesheetSubmissionDate = B.TimesheetSubmissionDate    
    AND convert(date,[EDS].[TimesheetDetail_All].ModifiedDate) != convert(date,GETDATE())     
 --and  EsaProjectID='1000442044' and SubmitterID='176356' and      
 --convert(date,TimesheetSubmissionDate) between '2025-06-01' and  '2025-06-20'    
);    
    
  ----Remove Invalid Entries from All      
  --CREATE TABLE ToBeRemoved (      
  -- ID INT IDENTITY (1,1),      
  -- EsaProjectId NVARCHAR(50),      
  -- SubmitterId NVARCHAR(50),      
  -- TotalHours DECIMAL,      
  -- TimesheetSubmissionDate DATETIME      
  --)      
      
  --INSERT INTO ToBeRemoved      
  --SELECT EsaProjectId,SubmitterId,SUM(Hours) AS TotalHours,TimesheetSubmissionDate FROM [EDS].[TimesheetDetail_All] GROUP BY EsaProjectId,SubmitterId,TimesheetSubmissionDate HAVING SUM(Hours)>9      
      
  ----SELECT * FROM ToBeRemoved      
      
  --DECLARE @Count INT      
  --DECLARE @i INT=0      
      
  --SET @Count= (SELECT COUNT(*) FROM ToBeRemoved)      
      
  --WHILE (@Count > 0)      
      
  --BEGIN      
         
  -- DECLARE @Id INT=1      
  -- DECLARE @MinCreatedDate DATETIME      
      
  -- SET @MinCreatedDate = (SELECT MIN(CreatedDate) FROM [EDS].[TimesheetDetail_All] A JOIN ToBeRemoved B ON A.EsaProjectID=B.EsaProjectID AND A.SubmitterID=B.SubmitterID AND A.TimesheetSubmissionDate=B.TimesheetSubmissionDate WHERE B.ID=@Id )      
      
  -- DELETE FROM [EDS].[TimesheetDetail_All] WHERE ID = (SELECT A.ID FROM [EDS].[TimesheetDetail_All] A JOIN ToBeRemoved B ON A.EsaProjectID=B.EsaProjectID AND A.SubmitterID=B.SubmitterID AND A.TimesheetSubmissionDate=B.TimesheetSubmissionDate WHERE B.ID
  
    
  --@Id AND CreatedDate=@MinCreatedDate)      
         
  -- SET @i = @i+1      
  -- SET @Count = @Count-1      
  -- SET @Id = @Id+1      
      
  --END      
      
  --DROP TABLE ToBeRemoved      
    
  --Sync Timesheet Detail All Enhancement      
  --TRUNCATE TABLE [EDS].[TimesheetDetail_All_Enhancement]      
        
  --INSERT INTO [EDS].[TimesheetDetail_All_Enhancement] (EsaProjectId,ProjectName,ActivityCode,Hours,SubmitterID,Submitterdate,CreatedBy,CreatedDate,ActivityDescription,TimesheetStatus,TimesheetSubmissionDate,ModifiedBy,ModifiedDate)      
  --SELECT EsaProjectId,ProjectName,ActivityCode,Hours,SubmitterID,Submitterdate,TA.CreatedBy,TA.CreatedDate,ActivityDescription,TimesheetStatus,TimesheetSubmissionDate,TA.ModifiedBy,TA.ModifiedDate    
  --FROM [EDS].[TimesheetDetail_All] TA    
  --JOIN [EDS].[ESAActivityDetails] AD ON TA.ActivityDescription = AD.[ActivityName]    
  --WHERE AD.[IsDeleted]=0    
      
  --Delete Old Data      
  --DELETE FROM EDS.TimesheetDetail_All where TimesheetSubmissionDate <= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-2, -1)      
          
 COMMIT TRANSACTION      
      
 EXEC [EDS].[Adoption_SyncScopeWiseEDSTimesheetdata];      
        
 --Send Success mail notification        
 DECLARE @MailSubject VARCHAR(MAX);            
 DECLARE @MailBody  VARCHAR(MAX);          
             
 SELECT @MailSubject = CONCAT(@@servername, ' Adoption_EDS: Sync ESA Timesheet Details - Job Success Notification')          
 SELECT @MailBody = '<font color="Black" face="Arial" Size = "2">Hi Team,<br><br>EDS Timesheet data succesfully synced!<br><br>      
      Regards,<br>Applens Support Team<br><br>***Note: This is an auto generated mail. Please do not reply.***</font>'           
         
EXEC [$(AppVisionLensDB)].[AVL].[SendDBEmail] @To='AVMCoEL1Team@cognizant.com;AVMDARTL2@cognizant.com',    @From='ApplensSupport@cognizant.com',    @Subject =@MailSubject,    @Body = @MailBody    
    
       
     
 DROP TABLE #EDSTimesheetDetail    
 DROP TABLE #Temp_Sum    
 DROP TABLE #StatusUpdate    
        
END TRY      
      
BEGIN CATCH      
      
 ROLLBACK TRANSACTION      
       
 DECLARE @ErrorMessage VARCHAR(MAX);                 
 SELECT @ErrorMessage = ERROR_MESSAGE()                 
       
 --Send failure mail notification        
 DECLARE @MailSubjectFailure VARCHAR(MAX);            
 DECLARE @MailBodyFailure  VARCHAR(MAX);          
             
 SELECT @MailSubjectFailure = CONCAT(@@servername, ' Adoption_EDS: Sync ESA Timesheet Details - Job Failure Notification')          
 SELECT @MailBodyFailure = CONCAT('<font color="Black" face="Arial" Size = "2">Hi Team, <br><br>Oops! Error occurred while syncing timesheet data!<br>          
        <br>Error: ', @ErrorMessage,          
        '<br><br>Regards,<br>Applens Support Team<br><br>***Note: This is an auto generated mail. Please do not reply.***</font>')          
    
EXEC [$(AppVisionLensDB)].[AVL].[SendDBEmail] @To='AVMCoEL1Team@cognizant.com;AVMDARTL2@cognizant.com',    @From='ApplensSupport@cognizant.com',    @Subject =@MailSubjectFailure,    @Body = @MailBodyFailure    
               
END CATCH    
    