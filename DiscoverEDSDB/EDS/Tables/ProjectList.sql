CREATE TABLE [EDS].[ProjectList] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [ESAProjectId] NVARCHAR (50) NOT NULL,
    [CreatedBy]    NVARCHAR (50) NOT NULL,
    [CreatedDate]  DATETIME      NOT NULL,
    CONSTRAINT [PK_ProjectList] PRIMARY KEY CLUSTERED ([Id] ASC)
);

