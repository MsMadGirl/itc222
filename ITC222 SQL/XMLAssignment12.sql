use MetroAlt

CREATE XML SCHEMA COLLECTION MaintenanceNotesSchema AS 
'<?xml version="1.0" encoding="utf-8"?>
<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="maintenanceNotes">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="comments">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="comment" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="actions">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="action" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
      <xs:attribute name="xlmns" type="xs:string" use="required" />
    </xs:complexType>
  </xs:element>
</xs:schema>'

ALTER TABLE [dbo].[MentainanceDetail]
DROP COLUMN [MaintenanceNotes]

ALTER TABLE [dbo].[MentainanceDetail]
ADD MaintenanceNotes XML (MaintenanceNotesSchema)

INSERT INTO [dbo].[Maintenaince]([MaintenanceDate], [BusKey])
vALUES(GetDate(), 3);


INSERT INTO [dbo].[MentainanceDetail]([MaintenanceKey], [EmployeeKey], [BusServiceKey], [MaintenanceNotes])
VALUES (Ident_current('Maintenaince'), 69, 2,
'<?xml version="1.0" encoding="utf-8"?>
<maintenanceNotes xlmns="http://www.metroalt.com/maintenanceNotes">

  <comments>
    <comment>Bus stinks.</comment>
	<comment>Broken back seat.</comment>
  </comments>

  <actions>
    <action>Have bus cleaned and back seat repaired.</action>
  </actions>

</maintenanceNotes>')

SELECT * FROM MentainanceDetail;

SELECT TOP 10 EmployeeLastName, EmployeeFirstName, EmployeeEmail FROM Employee
FOR XML RAW;

SELECT TOP 10 EmployeeLastName, EmployeeFirstName, EmployeeEmail FROM Employee
FOR XML RAW('employee'), ELEMENTS, ROOT('employees');

SELECT TOP 10 EmployeeLastName, EmployeeFirstName, EmployeeEmail, PositionName, EmployeeHourlyPayRate 
FROM Employee
INNER JOIN EmployeePosition
ON Employee.EmployeeKey = EmployeePosition.EmployeeKey
INNER JOIN Position
ON Position.PositionKey = EmployeePosition.PositionKey
FOR XML AUTO, ELEMENTS, ROOT('employees');

SELECT MaintenanceKey, EmployeeKey, BusServiceKey, 
MaintenanceNotes.query('declare namespace mn="http://www.metroalt.com/maintenanceNotes";
//mn:maintenanceNotes/mn:comments/*') AS comments FROM MentainanceDetail;