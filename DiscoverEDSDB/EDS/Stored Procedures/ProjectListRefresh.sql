CREATE PROCEDURE EDS.ProjectListRefresh

AS

BEGIN TRY 

	BEGIN TRANSACTION

		SELECT * INTO #ADMProjectList FROM [CTSINTBMVPALDBL].[AdoptionReport].[ADP].[Associate_Projects] WITH (NOLOCK)
		SELECT * INTO #AIAProjectList FROM [CTSINTBMVPALDBL].[AdoptionReport].[ADP].[Associate_Projects_AIA] WITH (NOLOCK)
		SELECT * INTO #CDBProjectList FROM [CTSINTBMVPALDBL].[AdoptionReport].[ADP].[Associate_Projects_CDB] WITH (NOLOCK)
		SELECT * INTO #EASProjectList FROM [CTSINTBMVPALDBL].[AdoptionReport].[ADP].[Associate_Projects_EAS] WITH (NOLOCK)
		
		SELECT DISTINCT B.EsaProjectId INTO #Onboarded from [CTSINTBMVPALDBL].[$(AppVisionLensDB)].[AVL].[PRJ_ConfigurationProgress] A WITH (NOLOCK)
		JOIN [CTSINTBMVPALDBL].[$(AppVisionLensDB)].[AVL].[MAS_ProjectMaster] B WITH (NOLOCK) ON A.ProjectId=B.ProjectId 
		WHERE ScreenId=4 AND A.CompletionPercentage=100 AND A.IsDeleted=0
		AND B.IsDeleted=0

		TRUNCATE TABLE EDS.ProjectList

		INSERT INTO EDS.ProjectList (ESAProjectId,CreatedBy,CreatedDate)

		SELECT EsaProjectId,'Applens',GETDATE() FROM #ADMProjectList
		UNION 
		SELECT EsaProjectId,'Applens',GETDATE() FROM #AIAProjectList
		UNION
		SELECT EsaProjectId,'Applens',GETDATE() FROM #CDBProjectList
		UNION
		SELECT EsaProjectId,'Applens',GETDATE() FROM #EASProjectList
		UNION
		SELECT EsaProjectId,'Applens',GETDATE() FROM #Onboarded

	COMMIT TRANSACTION

END TRY 

BEGIN CATCH 

	ROLLBACK TRANSACTION

END CATCH



