CREATE TABLE [EDS].[License] (
    [ID]                       BIGINT        IDENTITY (1, 1) NOT NULL,
    [ItemCode]                 VARCHAR (40)  NULL,
    [ItemDisplayName]          VARCHAR (255) NULL,
    [SoftwareProductSysID]     VARCHAR (32)  NOT NULL,
    [SoftwareModelSysID]       VARCHAR (32)  NULL,
    [SoftwareModelDisplayName] VARCHAR (255) NULL,
    [TypeOfIntegration]        VARCHAR (40)  NULL,
    [IsDeleted]                BIT           NOT NULL,
    [CreatedBy]                NVARCHAR (50) NOT NULL,
    [CreatedDate]              DATETIME      NOT NULL,
    [ModifiedBy]               NVARCHAR (50) NULL,
    [ModifiedDate]             DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

