/***************************************************************************
*COGNIZANT CONFIDENTIAL AND/OR TRADE SECRET
*Copyright [2018] – [2021] Cognizant. All rights reserved.
*NOTICE: This unpublished material is proprietary to Cognizant and
*its suppliers, if any. The methods, techniques and technical
  concepts herein are considered Cognizant confidential and/or trade secret information. 
  
*This material may be covered by U.S. and/or foreign patents or patent applications. 
*Use, distribution or copying, in whole or in part, is forbidden, except by express written permission of Cognizant.
***************************************************************************/
CREATE PROCEDURE [dbo].[GetLicenseDetail]
AS  
BEGIN    
 SET NOCOUNT ON;    
 BEGIN TRY   
    SELECT 
                      [ItemCode]
           ,[ItemDisplayName]
           ,[SoftwareProductSysID]
           ,[SoftwareModelSysID]
           ,[SoftwareModelDisplayName]
           ,[TypeOfIntegration]
       FROM (
     SELECT
     ROW_NUMBER() OVER (PARTITION BY [ItemCode] ORDER BY [CreatedDate] DESC)
     AS [RowNum],     
     *
     FROM [EDS].[License]
   )base
  WHERE [RowNum] = 1 AND [IsDeleted]=0
         
 SET NOCOUNT OFF; 
 END TRY    
 BEGIN CATCH    
 DECLARE @errorMessage VARCHAR(MAX);    
    
   SELECT @errorMessage = ERROR_MESSAGE()    
 
 END CATCH    
END
