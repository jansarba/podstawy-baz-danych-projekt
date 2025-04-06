-- dbo.Dluznicy source

-- dbo.Dluznicy source

CREATE VIEW dluznicy AS
SELECT 
    s.FirstName,
    s.LastName,
    s.StudentID,
    o.OrderDate,
    od.PaymentDate,
    SUM(COALESCE(oc.BuyPrice, 0) + COALESCE(ow.BuyPrice, 0) + COALESCE(osm.BuyPrice, 0) + COALESCE(os.BuyPrice, 0)) AS TotalBuyPrice
FROM 
    OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
LEFT JOIN OrderCourses oc ON od.OrderDetailsID = oc.OrderDetailsID
LEFT JOIN OrderWebinars ow ON od.OrderDetailsID = ow.OrderDetailsID
LEFT JOIN OrderStudyMeetings osm ON od.OrderDetailsID = osm.OrderDetailsID
LEFT JOIN OrderStudies os ON od.OrderDetailsID = os.OrderDetailsID
JOIN students s ON o.studentid = s.studentid 
WHERE 
    od.PaymentDate IS NULL
GROUP BY 
    s.FirstName,
    s.LastName,
    s.StudentID,
    o.OrderDate,
    od.PaymentDate;


-- dbo.Frekwencja_kursy source

create view Frekwencja_kursy as
SELECT 
    m.ModuleID,
    m.ModuleName,
    COUNT(CASE WHEN md.IsPresent = 1 THEN 1 END) AS PresentCount,
    COUNT(md.StudentID) AS TotalCount,
    CAST(COUNT(CASE WHEN md.IsPresent = 1 THEN 1 END) * 100.0 / COUNT(md.StudentID) AS DECIMAL(5, 2)) AS AttendancePercentage
FROM ModuleDetails AS md
JOIN Modules AS m
    ON md.ModuleID = m.ModuleID
WHERE m.Date < CAST(GETDATE() AS DATE)
GROUP BY m.ModuleID, m.ModuleName;


-- dbo.Frekwencja_studia source

create view Frekwencja_studia as
SELECT 
    sm.StudyMeetingID,
    sm.MeetingName,
    COUNT(CASE WHEN smd.IsPresent = 1 THEN 1 END) AS PresentCount,
    COUNT(smd.StudentID) AS TotalCount,
    CAST(COUNT(CASE WHEN smd.IsPresent = 1 THEN 1 END) * 100.0 / COUNT(smd.StudentID) AS DECIMAL(5, 2)) AS AttendancePercentage
FROM StudyMeetingDetails AS smd
JOIN StudyMeetings AS sm
    ON smd.StudyMeetingID = sm.StudyMeetingID
WHERE sm.Date < CAST(GETDATE() AS DATE)
GROUP BY sm.StudyMeetingID, sm.MeetingName;


-- dbo.Kurs_raport_finansowy source

CREATE VIEW Kurs_raport_finansowy AS
SELECT ID AS 'Course ID', Name, TotalIncome
FROM raport_finansowy rf 
WHERE Type = 'Course';


-- dbo.Lista_obecnosci_szkolenia source

-- 5. Lista obecności dla każdego szkolenia z datą, imieniem, nazwiskiem i informacją o obecności.

CREATE VIEW Lista_obecnosci_szkolenia AS
SELECT sm.Date, s.FirstName, s.LastName, sm.MeetingName, smd.IsPresent
FROM Students AS s
JOIN StudyMeetingDetails AS smd
    ON s.StudentID = smd.StudentID
JOIN StudyMeetings AS sm
    ON sm.StudyMeetingID = smd.StudyMeetingID;


-- dbo.Nadchodzace_kursy source

CREATE VIEW Nadchodzace_kursy AS
SELECT [Event ID] AS 'Course Module ID', Date, DurationTime
from nadchodzace_wydarzenia nw 
WHERE [Event type] = 'Course Module';


-- dbo.Nadchodzace_spotkania_studyjne source

CREATE VIEW Nadchodzace_spotkania_studyjne AS
SELECT [Event ID] AS 'Study Meeting ID', Date, DurationTime
FROM nadchodzace_wydarzenia nw 
WHERE [Event type] = 'Study Meeting';


-- dbo.Nadchodzace_webinary source

CREATE VIEW Nadchodzace_webinary AS
SELECT [Event ID] AS 'Webinar ID', Date, DurationTime
from nadchodzace_wydarzenia nw 
WHERE [Event type] = 'Webinar';


-- dbo.Nadchodzace_wydarzenia source

CREATE VIEW Nadchodzace_wydarzenia AS
SELECT WebinarID AS 'Event ID', WebinarDate AS 'Date', DurationTime, 'Webinar' AS 'Event type'
FROM Webinars
WHERE WebinarDate > GETDATE()
UNION
SELECT ModuleID AS 'Event ID', Date, DurationTime, 'Course Module' AS 'Event type'
FROM Modules
WHERE Date > GETDATE()
UNION
SELECT StudyMeetingID AS 'Event ID', Date, DurationTime, 'Study Meeting' AS 'Event type'
FROM StudyMeetings
WHERE Date > GETDATE();


-- dbo.Osoby_zapisane_na_praktyki source

create view Osoby_zapisane_na_praktyki as
SELECT 
    id.StudentID,
    st.FirstName + ' ' + st.LastName AS StudentName,
    i.InternshipID,
    s.StudyName,
    i.BeginDate,
    id.IsDone
FROM InternshipDetails AS id
JOIN Students AS st
    ON id.StudentID = st.StudentID
JOIN Internships AS i
    ON id.InternshipID = i.InternshipID
JOIN Studies AS s
    ON i.StudyID = s.StudyID;


-- dbo.Osoby_zapisane_na_przyszle_kursy source

CREATE VIEW Osoby_zapisane_na_przyszle_kursy AS
WITH DistinctRooms AS (
    SELECT DISTINCT c.CourseID, m.Room
    FROM Modules AS m
    JOIN Courses AS c ON m.CourseID = c.CourseID
),
DistinctLinks AS (
    SELECT DISTINCT c.CourseID, COALESCE(m.VideoLink, m.LiveLink) AS Link
    FROM Modules AS m
    JOIN Courses AS c ON m.CourseID = c.CourseID
)
SELECT 
    c.CourseID, 
    c.CourseName, 
    COUNT(s.StudentID) AS LiczbaOsob,
    CASE
        WHEN EXISTS (SELECT 1 FROM Modules AS m WHERE m.CourseID = c.CourseID AND m.Room IS NOT NULL) 
            THEN 'stacjonarnie'
        ELSE 'online'
    END AS FormaSpotkania,
    (SELECT STRING_AGG(Room, ', ') FROM DistinctRooms WHERE CourseID = c.CourseID) AS Pokoje,
    SUM(m.Limit) AS LimitOsob,
    CASE
        WHEN NOT EXISTS (SELECT 1 FROM Modules AS m WHERE m.CourseID = c.CourseID AND m.Room IS NOT NULL) 
            THEN (SELECT STRING_AGG(Link, ', ') FROM DistinctLinks WHERE CourseID = c.CourseID)
        ELSE NULL
    END AS Link
FROM 
    Students AS s
JOIN 
    CourseDetails AS cd ON s.StudentID = cd.StudentID
JOIN 
    Courses AS c ON c.CourseID = cd.CourseID
JOIN 
    Modules AS m ON m.CourseID = c.CourseID
WHERE 
    CAST(GETDATE() AS DATE) <= m.Date
GROUP BY 
    c.CourseID, c.CourseName;


-- dbo.Osoby_zapisane_na_przyszle_studia source

CREATE VIEW Osoby_zapisane_na_przyszle_studia AS
SELECT 
    sm.StudyMeetingID, 
    sm.MeetingName, 
    COUNT(s.StudentID) AS LiczbaOsob,
    CASE
        WHEN sm.Room IS NOT NULL THEN 'stacjonarnie'
        ELSE 'online'
    END AS FormaSpotkania,
    sm.Room AS Pokoj,
    sm.Limit AS LimitOsob,
    CASE
        WHEN sm.Room IS NULL THEN COALESCE(sm.VideoLink, sm.LiveLink)
        ELSE NULL
    END AS Link
FROM 
    Students AS s
JOIN 
    StudyMeetingDetails AS smd ON s.StudentID = smd.StudentID
JOIN 
    StudyMeetings AS sm ON sm.StudyMeetingID = smd.StudyMeetingID
WHERE 
    CAST(GETDATE() AS DATE) <= sm.Date
GROUP BY 
    sm.StudyMeetingID, sm.MeetingName, sm.Room, sm.Limit, sm.VideoLink, sm.LiveLink;


-- dbo.Osoby_zapisane_na_przyszle_webinary source

CREATE VIEW Osoby_zapisane_na_przyszle_webinary AS
SELECT 
    w.WebinarID, 
    w.WebinarName, 
    COUNT(s.StudentID) AS LiczbaOsob,
    'online' AS FormaSpotkania,
    COALESCE(w.VideoLink, w.VideoLink) AS Link
FROM 
    Students AS s
JOIN 
    WebinarDetails AS wd ON s.StudentID = wd.StudentID
JOIN 
    Webinars AS w ON w.WebinarID = wd.WebinarID
WHERE 
    CAST(GETDATE() AS DATE) <= w.WebinarDate
GROUP BY 
    w.WebinarID, w.WebinarName, w.VideoLink, w.VideoLink;


-- dbo.Raport_finansowy source

CREATE VIEW Raport_finansowy AS
SELECT w.WebinarID AS ID, w.WebinarName AS Name, 'Webinar' AS Type, w.WebinarPrice *
    (SELECT count(*)
    FROM OrderWebinars ow JOIN
    OrderDetails od ON ow.OrderDetailsID = od.OrderDetailsID JOIN
    Orders o ON od.OrderID = o.OrderID
    WHERE ow.WebinarID = w.WebinarID) AS TotalIncome
FROM Webinars w
UNION
SELECT c.CourseID AS ID, c.CourseName AS Name, 'Course' AS Type, c.CoursePrice *
    (SELECT count(*)
    FROM OrderCourses oc JOIN
    OrderDetails od ON oc.OrderDetailsID = od.OrderDetailsID JOIN
    Orders o ON od.OrderID = o.OrderID
    WHERE oc.CourseID = c.CourseID) AS TotalIncome
FROM Courses c
UNION
SELECT s.StudyID AS ID, s.StudyName AS Name, 'Study' AS Type, s.StudyPrice *
    (SELECT count(*)
    FROM OrderStudies os JOIN
    OrderDetails od ON os.OrderDetailsID = od.OrderDetailsID JOIN
    Orders o ON od.OrderID = o.OrderID
    WHERE os.StudyID = s.StudyID) +
    (SELECT sum(sm.MeetingPrice)
    FROM StudyMeetings sm JOIN
    Classes cl ON sm.ClassID = cl.ClassID
    WHERE cl.StudyID = s.StudyID) AS TotalIncome
FROM Studies s;


-- dbo.Studia_raport_finansowy source

CREATE VIEW Studia_raport_finansowy AS
SELECT ID AS 'Study ID', Name, TotalIncome
FROM raport_finansowy rf 
WHERE Type = 'Study';


-- dbo.Ukonczone_praktyki source

create view Ukonczone_praktyki as
SELECT 
    i.InternshipID,
    i.BeginDate,
    s.StudyName,
    COUNT(CASE WHEN id.IsDone = 1 THEN 1 END) AS CompletedCount,
    COUNT(id.StudentID) AS TotalStudents,
    CAST(COUNT(CASE WHEN id.IsDone = 1 THEN 1 END) * 100.0 / NULLIF(COUNT(id.StudentID), 0) AS DECIMAL(5, 2)) AS CompletionPercentage
FROM Internships AS i
JOIN Studies AS s
    ON i.StudyID = s.StudyID
LEFT JOIN InternshipDetails AS id
    ON i.InternshipID = id.InternshipID
GROUP BY i.InternshipID, i.BeginDate, s.StudyName;


-- dbo.Webinar_raport_finansowy source

CREATE VIEW Webinar_raport_finansowy AS
SELECT ID AS 'Webinar ID', Name, TotalIncome
FROM raport_finansowy rf 
WHERE Type = 'Webinar';