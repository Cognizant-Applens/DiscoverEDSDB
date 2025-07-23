CREATE TABLE [EDS].[TimesheetDetail_All] (
    [ID]                      BIGINT          IDENTITY (1, 1) NOT NULL,
    [EsaProjectID]            NVARCHAR (50)   NOT NULL,
    [ProjectName]             NVARCHAR (500)  NOT NULL,
    [ActivityCode]            NVARCHAR (50)   NULL,
    [ActivityDescription]     NVARCHAR (200)  NULL,
    [Hours]                   DECIMAL (18, 2) NULL,
    [SubmitterID]             NVARCHAR (50)   NULL,
    [TimesheetSubmissionDate] DATETIME        NULL,
    [TimesheetStatus]         NVARCHAR (10)   NULL,
    [Submitterdate]           DATETIME        NULL,
    [CreatedBy]               NVARCHAR (50)   NOT NULL,
    [CreatedDate]             DATETIME        NOT NULL,
    [ModifiedBy]              NVARCHAR (50)   NULL,
    [ModifiedDate]            DATETIME        NULL,
    [ProjectScope]            NVARCHAR (50)   DEFAULT (NULL) NULL,
    CONSTRAINT [PK_EDS.TimesheetDetail_All] PRIMARY KEY CLUSTERED ([ID] ASC)
);

