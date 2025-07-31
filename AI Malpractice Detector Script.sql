

USE master;

--CREATE TABLES

--Table: ExamScores

CREATE TABLE ExamScores (
    StudentID INT,
    Subject VARCHAR(50),
    CA_Score INT,
    Mock_Score INT,
    Final_Score INT,
    External_Score INT,
    Attendance DECIMAL(5,2),   -- percentage (e.g., 85.50)
    StudyHours DECIMAL(5,2),   -- hours per week
    Malpractice INT            -- 1 = caught, 0 = clean, NULL = unknown
);

INSERT INTO ExamScores (StudentID, Subject, CA_Score, Mock_Score, Final_Score, External_Score, Attendance, StudyHours, Malpractice)
VALUES

(101, 'Maths', 65, 68, 70, 72, 90.00, 12.0, 0),
(102, 'English', 55, 60, 58, 59, 85.00, 10.5, 0),
(103, 'Biology', 70, 75, 72, 74, 95.00, 14.0, 0),
(104, 'Maths', 50, 52, 54, 53, 80.00, 8.0, 0),
(105, 'English', 60, 62, 64, 65, 92.00, 13.5, 0),
(106, 'Maths', 30, 28, 32, 80, 40.00, 2.5, 1),
(107, 'English', 35, 30, 33, 85, 50.00, 1.5, 1),
(108, 'Biology', 25, 20, 22, 78, 30.00, 2.0, 1),
(109, 'Maths', 45, 50, 48, 65, 70.00, 6.0, 0),
(110, 'English', 40, 45, 43, 70, 60.00, 5.5, NULL),
(111, 'Biology', 60, 65, 63, 68, 88.00, 10.0, NULL),
(112, 'Maths', 55, 57, 56, 85, 77.00, 7.5, 1),
(113, 'English', 50, 52, 51, 80, 55.00, 4.0, 1),
(114, 'Biology', 75, 78, 80, 82, 96.00, 15.0, 0),
(115, 'Maths', 68, 70, 72, 73, 90.00, 12.0, 0),
(116, 'English', 42, 44, 45, 74, 60.00, 6.0, NULL),
(117, 'Biology', 35, 40, 38, 69, 58.00, 5.0, NULL),
(118, 'Maths', 48, 50, 49, 80, 63.00, 4.0, 1),
(119, 'English', 51, 53, 52, 78, 84.00, 9.0, 1),
(120, 'Biology', 65, 68, 67, 88, 91.00, 12.0, 1);

--Table StudentScores

CREATE TABLE StudentScores (
    StudentID VARCHAR(20),
    Subject VARCHAR(50),
    CA_Score FLOAT,
    Mock_Score FLOAT,
    Final_Score FLOAT,
    External_Score FLOAT,
    Prediction INT
);

INSERT INTO StudentScores (StudentID, Subject, CA_Score, Mock_Score, Final_Score, External_Score)
VALUES 
('S001', 'Maths', 18, 45, 50, 80),
('S002', 'English', 20, 40, 55, 90),
('S003', 'Biology', 15, 30, 45, 85);


--Table PredictionResults

CREATE TABLE PredictionResults (
StudentID	VARCHAR(20),
Subject	VARCHAR(50),
CA_Score	INT,
Mock_Score	INT,
Final_Score	INT,
External_Score	INT,
Malpractice_Prediction	VARCHAR,
Prediction_Probability	FLOAT,
Prediction_Date	DATETIME,
);

INSERT INTO PredictionResults (
    StudentID, Subject, CA_Score, Mock_Score, Final_Score, 
    External_Score, Malpractice_Prediction, Prediction_Probability, Prediction_Date
)
VALUES 
('STU202501', 'Mathematics', 25, 40, 85, 88, 'Y', 0.92, GETDATE()),

('STU202502', 'English', 20, 35, 78, 79, 'N', 0.60, GETDATE()),

('STU202503', 'Biology', 22, 38, 82, 87, 'Y', 0.88, GETDATE()),

('STU202504', 'Chemistry', 18, 33, 74, 77, 'N', 0.55, GETDATE()),

('STU202505', 'Physics', 30, 45, 92, 90, 'Y', 0.95, GETDATE());

SELECT * FROM PredictionResults ORDER BY Prediction_Date DESC

INSERT INTO PredictionResults (
    StudentID, Subject, CA_Score, Mock_Score, Final_Score, External_Score,
    Malpractice_Prediction, Prediction_Probability, Prediction_Date
)
VALUES 
('STU2025001', 'Mathematics', 20, 38, 90, 95, 'Y', 0.92, GETDATE()),
('STU2025002', 'English', 15, 32, 85, 88, 'Y', 0.87, GETDATE()),
('STU2025003', 'Biology', 18, 34, 65, 91, 'Y', 0.89, GETDATE()),
('STU2025004', 'Chemistry', 25, 42, 92, 94, 'N', 0.45, GETDATE()),
('STU2025005', 'Mathematics', 28, 45, 75, 76, 'N', 0.33, GETDATE()),
('STU2025006', 'English', 10, 25, 81, 97, 'Y', 0.93, GETDATE()),
('STU2025007', 'Biology', 30, 48, 79, 80, 'N', 0.20, GETDATE()),
('STU2025008', 'Chemistry', 17, 30, 82, 93, 'Y', 0.88, GETDATE()),
('STU2025009', 'Mathematics', 22, 36, 87, 92, 'Y', 0.91, GETDATE()),
('STU2025010', 'English', 26, 40, 83, 84, 'N', 0.29, GETDATE());


SELECT TOP 5 * 
FROM PredictionResults 
ORDER BY Prediction_Date DESC;

--Students with risk level
-- Step 1: Create a view or CTE to compute score differences
WITH ScoreDiffs AS (
    SELECT 
        StudentID,
        Subject,
        CA_Score,
        Mock_Score,
        Final_Score,
        External_Score,
        Attendance,
        StudyHours,
        (External_Score - CA_Score) AS CA_vs_External,
        (External_Score - Mock_Score) AS Mock_vs_External,
        (External_Score - Final_Score) AS Final_vs_External
    FROM ExamScores
)

-- Step 2: Flag students with suspicious gaps
SELECT 
    StudentID,
    Subject,
    CA_Score,
    Mock_Score,
    Final_Score,
    External_Score,
    Attendance,
    StudyHours,
    CA_vs_External,
    Mock_vs_External,
    Final_vs_External,
    CASE 
        WHEN CA_vs_External > 30 OR 
             Mock_vs_External > 30 OR 
             Final_vs_External > 30 
        THEN 'Likely Malpractice'
        ELSE 'Normal'
    END AS RiskLevel
FROM ScoreDiffs;

----Combined scores of all students to see preddicted malpractice
SELECT 
    *,
    CASE 
        WHEN CA_vs_External > 30 OR 
             Mock_vs_External > 30 OR 
             Final_vs_External > 30 
        THEN 1 ELSE 0
    END AS PredictedMalpractice
FROM (
    SELECT 
        StudentID,
        Subject,
        CA_Score,
        Mock_Score,
        Final_Score,
        External_Score,
        Attendance,
        StudyHours,
        (External_Score - CA_Score) AS CA_vs_External,
        (External_Score - Mock_Score) AS Mock_vs_External,
        (External_Score - Final_Score) AS Final_vs_External
    FROM ExamScores
) AS Derived;


--Counts of risk level
SELECT RiskLevel, COUNT(*) AS StudentCount
FROM (
    SELECT 
        StudentID,
        CASE 
            WHEN (External_Score - Final_Score) > 30 THEN 'High Risk'
            WHEN (External_Score - Final_Score) BETWEEN 15 AND 30 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS RiskLevel
    FROM ExamScores
) AS RiskCategories
GROUP BY RiskLevel;

--Flag students with large internal-external score gaps:

SELECT *, 
       (External_Score - Final_Score) AS FinalGap
FROM ExamScores
WHERE (External_Score - Final_Score) > 30;


--Count malpractice/suspected cases by subject:

SELECT Subject, COUNT(*) AS SuspectedCases
FROM ExamScores
WHERE Malpractice = 1
GROUP BY Subject;
