CREATE ROLE [SCOM_HealthService]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [SCOM_HealthService] ADD MEMBER [NT SERVICE\HealthService];

