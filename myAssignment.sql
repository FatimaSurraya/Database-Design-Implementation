SELECT DISTINCT p.PropertyID, p.Street, p.Suburb, p.WeeklyRent
FROM property p
JOIN inspection i ON p.PropertyID = i.PropertyID
WHERE i.comments IS NULL;


SELECT DISTINCT a.AgentID, a.FirstName, a.LastName, a.Phone
FROM agent a
JOIN property p ON a.AgentID = p.AgentID
WHERE p.Suburb = 'Daisy Hill' AND p.WeeklyRent < 540.00;


SELECT p.PropertyID, p.Street, p.Suburb, p.WeeklyRent
FROM property p
LEFT JOIN inspection i ON p.PropertyID = i.PropertyID
WHERE i.PropertyID IS NULL;

SELECT a.AgentID, a.FirstName, a.LastName, a.Phone, COUNT(p.PropertyID) AS PropertiesManaged
FROM agent a
JOIN property p ON a.AgentID = p.AgentID
GROUP BY a.AgentID
HAVING COUNT(p.PropertyID) >= 2;

SELECT a.FirstName, a.LastName, p.PropertyID, p.Street, p.Suburb, p.WeeklyRent
FROM agent a
JOIN property p ON a.AgentID = p.AgentID
WHERE p.WeeklyRent < (SELECT AVG(WeeklyRent) FROM property);

SELECT COUNT(*) AS InspectionsMade
FROM inspection
WHERE InspectionDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR);


SELECT c.CustomerID, c.FirstName, c.LastName, c.Phone, c.DOB
FROM customer c
JOIN (
    SELECT CustomerID, COUNT(*) AS NumInspections
    FROM inspection
    GROUP BY CustomerID
    ORDER BY NumInspections DESC
    LIMIT 1
) AS max_inspections ON c.CustomerID = max_inspections.CustomerID;

SELECT r.JobID, r.JobDescription, r.Charge, p.Street, p.Suburb, a.FirstName, a.LastName
FROM repairjob r
JOIN property p ON r.PropertyID = p.PropertyID
JOIN agent a ON p.AgentID = a.AgentID
WHERE r.Charge BETWEEN 1000.00 AND 3000.00;

SELECT p.PropertyID, p.Street, p.Suburb, SUM(r.Charge) AS TotalRepairCost
FROM property p
LEFT JOIN repairjob r ON p.PropertyID = r.PropertyID
GROUP BY p.PropertyID;

SELECT t.TradesmanID, t.FIRSTNAME, t.LASTNAME, t.PHONE, COALESCE(r.JobID, 'No Repair Job') AS JobID, COALESCE(r.JobDescription, 'No Repair Job Description') AS JobDescription, COALESCE(r.CompletedDate, 'No Completed Date') AS CompletedDate
FROM tradesman t
LEFT JOIN repairjob r ON t.TradesmanID = r.TradesmanID
ORDER BY t.LASTNAME ASC;
