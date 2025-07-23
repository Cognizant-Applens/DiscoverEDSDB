﻿CREATE TABLE [EDS].[Asset] (
    [ID]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [EmployeeID]   VARCHAR (40)  NULL,
    [ProjectID]    VARCHAR (32)  NULL,
    [AssetSysID]   VARCHAR (32)  NOT NULL,
    [AssetID]      VARCHAR (40)  NULL,
    [SerialNumber] VARCHAR (100) NULL,
    [IsPrimary]    VARCHAR (40)  NULL,
    [IsDeleted]    BIT           NOT NULL,
    [CreatedBy]    NVARCHAR (50) NOT NULL,
    [CreatedDate]  DATETIME      NOT NULL,
    [ModifiedBy]   NVARCHAR (50) NULL,
    [ModifiedDate] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

