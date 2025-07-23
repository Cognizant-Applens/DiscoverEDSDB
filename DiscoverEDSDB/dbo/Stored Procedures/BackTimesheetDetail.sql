

/***************************************************************************
*COGNIZANT CONFIDENTIAL AND/OR TRADE SECRET
*Copyright [2018] – [2021] Cognizant. All rights reserved.
*NOTICE: This unpublished material is proprietary to Cognizant and
*its suppliers, if any. The methods, techniques and technical
  concepts herein are considered Cognizant confidential and/or trade secret information. 
  
*This material may be covered by U.S. and/or foreign patents or patent applications. 
*Use, distribution or copying, in whole or in part, is forbidden, except by express written permission of Cognizant.
***************************************************************************/
CREATE  procedure [dbo].[BackTimesheetDetail]
AS  
BEGIN    
 SET NOCOUNT ON;    
 BEGIN TRY   

	INSERT INTO [EDS].[TimesheetDetail_JobBackup]
    SELECT 
	ID,
	EsaProjectID,
	ProjectName,
	ActivityCode,
	Hours,
	SubmitterID,
	Submitterdate,
	CreatedBy,
	CreatedDate,
	GETDATE() AS BackUpDate
	FROM [EDS].[TimesheetDetail] WHERE ID NOT IN (SELECT ID FROM [EDS].[TimesheetDetail_JobBackup])

	IF EXISTS(SELECT TOP 1 ID FROM [EDS].[TimesheetDetail_JobBackup] WHERE MONTH(CreatedDate) = (MONTH(GETDATE())-1))
	BEGIN
		DELETE FROM [EDS].[TimesheetDetail_JobBackup] WHERE MONTH(CreatedDate) = (MONTH(GETDATE())-1)
	END
	  
 SET NOCOUNT OFF; 
 END TRY    
 BEGIN CATCH    
 DECLARE @errorMessage VARCHAR(MAX);    
    
   SELECT @errorMessage = ERROR_MESSAGE()    
 
 END CATCH    
End
