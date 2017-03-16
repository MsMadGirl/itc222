USE Community_Assist
SELECT Year (GrantRequestDate) as [year], GrantTypeKey,GrantRequestAmount
FROM GrantRequest
;

SELECT Month (GrantRequestDate) as [month], GrantTypeKey, GrantType, GrantRequestAmount
FROM GrantRequest;

SELECT Day (GrantRequestDate) as [Day], GrantTypeKey, GrantType, GrantRequestAmount Amount
FROM GrantRequest
;

SELECT DatePart (Minute,GrantRequestDate)
FROM GrantRequest;

USE Community_Assist

SELECT DateDiff(Day, GetDate(), 3/23/2017); --days left in quarter

SELECT DonationAmount, DonationAmount * .10 Operations, DonationAmount *.90 Charity FROM Donation;

/*see Programability > System Functions to see what is available*/

SELECT DonationAmount, cast(DonationAmount as decimal(10,2)) * .10 Operations, DonationAmount * .90 Charity FROM Donation;

Select format(DonationAmount, '$ #,##0.00') as Amount from Donation;

DECLARE @SocialSec as nchar(9)
Set @SocialSec = '519551234';

SELECT SUBSTRING(@SocialSec,1,3) + '-' + SUBSTRING(@SocialSec,4,2) + '-' + SUBSTRING(@SocialSec,6,4)
As SSNumber

--Aggregate functions operate across groups of rows

SELECT sum(DonationAmount) as total from Donation; --sums all values in DonationAmount column
SELECT avg(DonationAmount) as total from Donation;
SELECT min(DonationAmount) as total from Donation;
SELECT max(DonationAmount) as total from Donation;
SELECT max(Personlastname) as total from Donation;

Select GrantTypeKey(avg(GrantRequestAmount), '$ #,##0.00') as Average, 
format(sum(GrantRequestAmount), '$ #,##0.00') as total
FROM GrantRequest
Group by GrantTypeKey;

Select GrantTypeKey(avg(GrantRequestAmount), '$ #,##0.00') as Average, 
format(sum(GrantRequestAmount), '$ #,##0.00') as total
FROM GrantRequest
WHERE not GrantTypeKey = 2 -- must be before group by, != <> can also be not equal
Group by GrantTypeKey
Having avg(GrantRequestAmount) > 400; -- must be after group by

SELECT name FROM sys.Tables -- these select metadata
SELECT * FROM sys.Tables
SELECT * FROM sys.all_columns where Object_id=373576369

SELECT * FROM sys.databases


