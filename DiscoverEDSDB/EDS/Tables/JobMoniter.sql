CREATE TABLE [EDS].[JobMoniter] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [JobName]     NVARCHAR (255) NOT NULL,
    [Status]      NVARCHAR (50)  NOT NULL,
    [StartDate]   DATETIME       NULL,
    [EndDate]     DATETIME       NULL,
    [CreatedBy]   NVARCHAR (50)  NOT NULL,
    [CreatedDate] DATETIME       NOT NULL,
    CONSTRAINT [PK_JobMoniter] PRIMARY KEY CLUSTERED ([Id] ASC)
);

