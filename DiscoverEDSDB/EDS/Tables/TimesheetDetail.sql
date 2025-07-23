CREATE TABLE [EDS].[TimesheetDetail] (
    [ID]                      BIGINT          IDENTITY (1, 1) NOT NULL,
    [EsaProjectID]            NVARCHAR (50)   NOT NULL,
    [ProjectName]             NVARCHAR (500)  NOT NULL,
    [ActivityCode]            NVARCHAR (50)   NULL,
    [Hours]                   DECIMAL (18, 2) NULL,
    [SubmitterID]             NVARCHAR (50)   NULL,
    [Submitterdate]           DATETIME        NULL,
    [CreatedBy]               NVARCHAR (50)   NOT NULL,
    [CreatedDate]             DATETIME        NOT NULL,
    [ActivityDescription]     NVARCHAR (200)  NULL,
    [TimesheetStatus]         NVARCHAR (10)   NULL,
    [TimesheetSubmissionDate] DATETIME        NULL,
    CONSTRAINT [PK_EDS.TimesheetDetail] PRIMARY KEY CLUSTERED ([ID] ASC)
);

