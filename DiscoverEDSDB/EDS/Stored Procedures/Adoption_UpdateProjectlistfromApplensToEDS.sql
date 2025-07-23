
/***************************************************************************
*COGNIZANT CONFIDENTIAL AND/OR TRADE SECRET
*Copyright [2018] – [2021] Cognizant. All rights reserved.
*NOTICE: This unpublished material is proprietary to Cognizant and
*its suppliers, if any. The methods, techniques and technical
  concepts herein are considered Cognizant confidential and/or trade secret information. 
  
*This material may be covered by U.S. and/or foreign patents or patent applications. 
*Use, distribution or copying, in whole or in part, is forbidden, except by express written permission of Cognizant.
***************************************************************************/
CREATE PROCEDURE [EDS].[Adoption_UpdateProjectlistfromApplensToEDS]  

AS  

BEGIN    
 
	BEGIN TRY   
   
    BEGIN TRANSACTION

		SELECT * INTO #ADMProjectList FROM [$(AdoptionReportDB)].[ADPR].[Associate_Projects] WITH (NOLOCK)
		SELECT * INTO #NonADMProjectList FROM [$(AdoptionReportDB)].[ADPR].[NonADM_EligibleProjects] WITH (NOLOCK)
		
		SELECT DISTINCT B.EsaProjectId INTO #Onboarded from [$(AppVisionLensDB)].[AVL].[PRJ_ConfigurationProgress] A WITH (NOLOCK)
		JOIN [$(AppVisionLensDB)].[AVL].[MAS_ProjectMaster] B WITH (NOLOCK) ON A.ProjectId=B.ProjectId 
		WHERE ScreenId=4 AND A.CompletionPercentage=100 AND A.IsDeleted=0
		AND B.IsDeleted=0


		TRUNCATE TABLE EDS.ProjectList

		INSERT INTO EDS.ProjectList (ESAProjectId,CreatedBy,CreatedDate)

		SELECT EsaProjectId,'Applens',GETDATE() FROM #ADMProjectList
		UNION 
		SELECT EsaProjectId,'Applens',GETDATE() FROM #NonADMProjectList
		UNION
		SELECT EsaProjectId,'Applens',GETDATE() FROM #Onboarded
		--UNION
		--SELECT EsaProjectId,CreatedBy,CreatedDate FROM [EDS].[ProjectList_Inclusion]

	COMMIT TRANSACTION

		DECLARE @MailSubject VARCHAR(MAX);      
		DECLARE @MailBody  VARCHAR(MAX);    
		      
		SELECT @MailSubject = CONCAT(@@servername, ' Adoption_EDS: ProjectList Update  - Job Success Notification')    
		SELECT @MailBody = '<font color="Black" face="Arial" Size = "2">Hi Team,<br><br>ProjectList updated Successfully from Applens to EDS!<br><br>
							Regards,<br>Applens Support Team<br><br>***Note: This is an auto generated mail. Please do not reply.***</font>'     
		  
		EXEC msdb.dbo.sp_send_dbmail @recipients = 'AVMCoEL1Team@cognizant.com;AVMDARTL2@cognizant.com',    
		@profile_name ='ApplensSupport',    
		@subject = @MailSubject,    
		@body = @MailBody,    
		@body_format = 'HTML';   

	END TRY 
	
	BEGIN CATCH    

		ROLLBACK TRANSACTION

		DECLARE @errorMessage VARCHAR(MAX);    
		
		SELECT @errorMessage = ERROR_MESSAGE()   
		
		--Send failure mail notification  
		DECLARE @MailSubjectFailure VARCHAR(MAX);      
		DECLARE @MailBodyFailure  VARCHAR(MAX);    
		      
		SELECT @MailSubjectFailure = CONCAT(@@servername, ' Adoption_EDS: ProjectList Update - Job Failure Notification')    
		SELECT @MailBodyFailure = CONCAT('<font color="Black" face="Arial" Size = "2">Hi Team, <br><br>Oops! Error occurred while updating the ProjectList from Applens to EDS!<br>    
		       <br>Error: ', @ErrorMessage,    
		       '<br><br>Regards,<br>Applens Support Team<br><br>***Note: This is an auto generated mail. Please do not reply.***</font>')    
		  
		EXEC msdb.dbo.sp_send_dbmail @recipients = 'AVMCoEL1Team@cognizant.com;AVMDARTL2@cognizant.com',    
		@profile_name ='ApplensSupport',    
		@subject = @MailSubjectFailure,    
		@body = @MailBodyFailure,    
		@body_format = 'HTML';     
 
	END CATCH    

END
