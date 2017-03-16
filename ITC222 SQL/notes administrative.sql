USE Community_Assist

GO
CREATE SCHEMA EmployeeSchema

CREATE VIEW EmployeeSchema.GrantRequests
AS
SELECT
gr.GrantRequestKey,
GrantRequestDate,
PersonKey,
GrantTypeKey


GO
CREATE ROLE EmployeeRole

GO
GRANT SELECT ON SCHEMA::EmployeeSchema TO EmployeeRole
GRANT INSERT, UPDATE ON GrantReview to EmployeeRole
GRANT SELECT ON GrantType TO EmployeeRole

ALTER ROLE EmployeeRole ADD MEMBER EmployeeLogin;

--look at administrative commands on blog