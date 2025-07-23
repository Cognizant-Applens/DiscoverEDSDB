
CREATE   PROCEDURE [dbo].[ShrinkDB]
  
AS
BEGIN
  ALTER DATABASE [DiscoverEDS]
SET RECOVERY SIMPLE;



-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (DiscoverEDS_log, 1);



-- Reset the database recovery model.
ALTER DATABASE [DiscoverEDS]
SET RECOVERY FULL;





END
