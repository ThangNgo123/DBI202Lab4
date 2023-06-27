--1
SELECT e.empSSN, e.empName, e.depNum, d.depName
FROM dbo.tblDepartment d
INNER JOIN dbo.tblEmployee e ON d.depNum = e.depNum
WHERE d.depName = N'Phòng Nghiên cứu và phát triển';

--2
SELECT p.proNum, p.proName, d.depName, d.depNum
FROM dbo.tblDepartment d
INNER JOIN dbo.tblProject p ON d.depNum = p.depNum
WHERE d.depName = N'Phòng Nghiên cứu và phát triển';

--3
SELECT p.proNum, p.proName, d.depName
FROM dbo.tblDepartment d INNER JOIN dbo.tblProject p ON d.depNum = p.depNum
WHERE p.proName = N'ProjectB';

--4
SELECT e.empSSN, e.empName
FROM dbo.tblEmployee e 
WHERE e.supervisorSSN = '30121050004';

--5
SELECT e.supervisorSSN, e.empName
FROM dbo.tblEmployee e 
WHERE e.empName = N'Mai Duy An';

--6
SELECT p.proNum, l.locName
FROM dbo.tblProject p INNER JOIN dbo.tblLocation l ON p.locNum = l.locNum
WHERE p.proName = N'ProjectA';

--7
SELECT p.proNum, l.locName
FROM dbo.tblLocation l INNER JOIN dbo.tblProject p ON p.locNum = l.locNum
WHERE l.locName = N'TP Hồ Chí Minh';

--8
SELECT d.depName, d.depBirthdate,e.empName
FROM dbo.tblEmployee e INNER JOIN dbo.tblDependent d ON e.empSSN = d.empSSN
WHERE YEAR(GETDATE()) - YEAR(d.depBirthdate) >= 18;

--9
SELECT d.depName, d.depBirthdate, e.empName
FROM dbo.tblEmployee e INNER JOIN dbo.tblDependent d ON e.empSSN = d.empSSN
WHERE d.depSex = N'M';

--10
SELECT d.depNum, d.depName, l.locName
FROM dbo.tblDepartment d 
JOIN (dbo.tblLocation l JOIN dbo.tblDepLocation dl ON l.locNum = dl.locNum) 
ON d.depNum = dl.depNum
WHERE d.depName = N'Phòng Nghiên cứu và phát triển';

--11
SELECT distinct p.proNum, p.proName, d.depName
FROM dbo.tblProject p
JOIN dbo.tblLocation l ON p.locNum = l.locNum
JOIN dbo.tblDepLocation dl ON p.depNum = dl.depNum
JOIN dbo.tblDepartment d ON p.depNum = d.depNum
WHERE l.locName = N'TP Hồ Chí Minh';

--12
SELECT e.empName, de.depName, de.depRelationship
FROM dbo.tblDepartment d
JOIN (dbo.tblEmployee e JOIN dbo.tblDependent de ON e.empSSN = de.empSSN )
ON d.depNum = e.depNum
WHERE de.depSex = N'F' AND d.depName = N'Phòng Nghiên cứu và phát triển';

--13
SELECT e.empName, de.depName, de.depRelationship
FROM dbo.tblDepartment d
JOIN (dbo.tblEmployee e JOIN dbo.tblDependent de ON e.empSSN = de.empSSN)
ON d.depNum = e.depNum
WHERE YEAR(GETDATE()) - YEAR(de.depBirthdate) >= 18 AND d.depName = N'Phòng Nghiên cứu và phát triển';

--14
SELECT e.empSex, COUNT(e.empSex) as soLuongNguoiPhuThuoc
FROM dbo.tblEmployee e
GROUP BY e.empSex;

--15
SELECT de.depRelationship, COUNT(de.depRelationship) as soLuongNguoiPhuThuoc
FROM dbo.tblDependent de
GROUP BY de.depRelationship;

--16
SELECT d.depNum, d.depName, COUNT(d.depName) AS soLuongNguoiPhuThuoc
FROM dbo.tblDepartment d JOIN dbo.tblEmployee e ON d.depNum = e.depNum
GROUP BY d.depName, d.depNum;

--17
SELECT depNum, depName, soLuongNguoiPhuThuoc
FROM

(SELECT d.depNum, d.depName, COUNT(d.depNum) as soLuongNguoiPhuThuoc
FROM dbo.tblDepartment d JOIN dbo.tblEmployee e ON d.depNum = e.depNum
GROUP BY d.depNum, d.depName) AS bangSoLuongNguoiPhuThuoc

WHERE bangSoLuongNguoiPhuThuoc.soLuongNguoiPhuThuoc <= ALL
((SELECT MIN(bangSoLuongNguoiPhuThuoc.soLuongNguoiPhuThuoc)
FROM (SELECT d.depNum, d.depName, COUNT(d.depNum) as soLuongNguoiPhuThuoc
FROM dbo.tblDepartment d JOIN dbo.tblEmployee e ON d.depNum = e.depNum
GROUP BY d.depNum, d.depName) AS bangSoLuongNguoiPhuThuoc));

--18
SELECT depNum, depName, soLuongNguoiPhuThuoc
FROM

(SELECT d.depNum, d.depName, COUNT(d.depNum) as soLuongNguoiPhuThuoc
FROM dbo.tblDepartment d JOIN dbo.tblEmployee e ON d.depNum = e.depNum
GROUP BY d.depNum, d.depName) AS bangSoLuongNguoiPhuThuoc

WHERE bangSoLuongNguoiPhuThuoc.soLuongNguoiPhuThuoc >= ALL
((SELECT MAX(bangSoLuongNguoiPhuThuoc.soLuongNguoiPhuThuoc)
FROM (SELECT d.depNum, d.depName, COUNT(d.depNum) as soLuongNguoiPhuThuoc
FROM dbo.tblDepartment d JOIN dbo.tblEmployee e ON d.depNum = e.depNum
GROUP BY d.depNum, d.depName) AS bangSoLuongNguoiPhuThuoc));

--19
SELECT e.empSSN,e.empName,d.depName, tableW.sumW
FROM dbo.tblDepartment d JOIN dbo.tblEmployee e ON d.depNum = e.depNum
JOIN (SELECT w.empSSN, SUM (w.workHours) AS sumW
FROM dbo.tblWorksOn w
GROUP BY w.empSSN) AS tableW
ON tableW.empSSN = e.empSSN;

--20
SELECT p.depNum, d.depName, SUM(tableW.sumW) as sumWD
FROM dbo.tblProject p
JOIN dbo.tblDepartment d ON p.depNum = d.depNum
JOIN (SELECT w.proNum, SUM(w.workHours) as sumW 
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableW
ON p.proNum =tableW.proNum
GROUP BY p.depNum, d.depName
;

--21
SELECT e.empSSN, e.empName, tableW.sumW
FROM (SELECT w.empSSN, SUM (w.workHours) AS sumW
FROM dbo.tblWorksOn w
GROUP BY w.empSSN) AS tableW
JOIN dbo.tblEmployee e ON e.empSSN = tableW.empSSN
WHERE tableW.sumW <= ALL(
SELECT MIN(tableW.sumW)
FROM (SELECT w.empSSN, SUM (w.workHours) AS sumW
FROM dbo.tblWorksOn w
GROUP BY w.empSSN) AS tableW)
;

--22
SELECT e.empSSN, e.empName, tableW.sumW
FROM (SELECT w.empSSN, SUM (w.workHours) AS sumW
FROM dbo.tblWorksOn w
GROUP BY w.empSSN) AS tableW
JOIN dbo.tblEmployee e ON e.empSSN = tableW.empSSN
WHERE tableW.sumW >= ALL(
SELECT MAX(tableW.sumW)
FROM (SELECT w.empSSN, SUM (w.workHours) AS sumW
FROM dbo.tblWorksOn w
GROUP BY w.empSSN) AS tableW)
;

--23
SELECT e.empSSN, e.empName, d.depName
FROM dbo.tblDepartment d JOIN dbo.tblEmployee e ON d.depNum = e.depNum 
JOIN
(SELECT w.empSSN, COUNT(w.empSSN) AS countJoinProject
FROM dbo.tblWorksOn w
GROUP BY w.empSSN
HAVING COUNT(w.empSSN) = 1) AS tableCountJoinProject
ON e.empSSN = tableCountJoinProject.empSSN;

--24
SELECT e.empSSN, e.empName, d.depName
FROM dbo.tblDepartment d JOIN dbo.tblEmployee e ON d.depNum = e.depNum 
JOIN
(SELECT w.empSSN, COUNT(w.empSSN) AS countJoinProject
FROM dbo.tblWorksOn w
GROUP BY w.empSSN
HAVING COUNT(w.empSSN) = 2) AS tableCountJoinProject
ON e.empSSN = tableCountJoinProject.empSSN;

--25
SELECT e.empSSN, e.empName, d.depName
FROM dbo.tblDepartment d JOIN dbo.tblEmployee e ON d.depNum = e.depNum 
JOIN
(SELECT w.empSSN, COUNT(w.proNum) AS countPro
FROM dbo.tblWorksOn w
GROUP BY w.empSSN
HAVING COUNT(w.proNum) >= 2) AS tableCountPro
ON e.empSSN = tableCountPro.empSSN;

--26
SELECT p.proNum, p.proName, tableCountEmp.countEmp
FROM dbo.tblProject p
JOIN
(SELECT w.proNum, COUNT(w.empSSN) as countEmp
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableCountEmp
ON p.proNum = tableCountEmp.proNum;

--27
SELECT p.proNum, p.proName, tableSumHour.sumHour
FROM dbo.tblProject p 
JOIN
(SELECT w.proNum, SUM(w.workHours) AS sumHour 
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableSumHour
ON p.proNum = tableSumHour.proNum;

--28
SELECT p.proNum, p.proName, tableCountEmp.countEmp
FROM dbo.tblProject p
JOIN
(SELECT w.proNum, COUNT(w.empSSN) as countEmp
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableCountEmp
ON p.proNum = tableCountEmp.proNum
WHERE tableCountEmp.countEmp <= ALL(
SELECT MIN(tableCountEmp.countEmp)
FROM (SELECT w.proNum, COUNT(w.empSSN) as countEmp
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableCountEmp);

--29
SELECT p.proNum, p.proName, tableCountEmp.countEmp
FROM dbo.tblProject p
JOIN
(SELECT w.proNum, COUNT(w.empSSN) as countEmp
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableCountEmp
ON p.proNum = tableCountEmp.proNum
WHERE tableCountEmp.countEmp >= ALL(
SELECT MAX(tableCountEmp.countEmp)
FROM (SELECT w.proNum, COUNT(w.empSSN) as countEmp
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableCountEmp);

--30
SELECT p.proNum, p.proName, tableSumHour.sumHour
FROM dbo.tblProject p
JOIN
(SELECT w.proNum, SUM(w.workHours) AS sumHour 
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableSumHour
ON p.proNum = tableSumHour.proNum
WHERE tableSumHour.sumHour <= ALL(
SELECT MIN(tableSumHour.sumHour)
FROM (SELECT w.proNum, SUM(w.workHours) AS sumHour 
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableSumHour
);

--31
SELECT p.proNum, p.proName, tableSumHour.sumHour
FROM dbo.tblProject p
JOIN
(SELECT w.proNum, SUM(w.workHours) AS sumHour 
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableSumHour
ON p.proNum = tableSumHour.proNum
WHERE tableSumHour.sumHour >= ALL(
SELECT MAX(tableSumHour.sumHour)
FROM (SELECT w.proNum, SUM(w.workHours) AS sumHour 
FROM dbo.tblWorksOn w
GROUP BY w.proNum) AS tableSumHour
);

--32
SELECT l.locName, tableCountDe.countDe
FROM dbo.tblLocation l
JOIN
(SELECT dl.locNum, COUNT(dl.depNum) AS countDe
FROM dbo.tblDepLocation dl
GROUP BY dl.locNum) AS tableCountDe
ON l.locNum = tableCountDe.locNum;


--33
SELECT d.depNum, d.depName, tableCountLoc.countLoc
FROM dbo.tblDepartment d
JOIN
(SELECT dl.depNum, COUNT(dl.locNum) AS countLoc
FROM dbo.tblDepLocation dl
GROUP BY dl.depNum) AS tableCountLoc
ON d.depNum = tableCountLoc.depNum;

--34
SELECT d.depNum, d.depName, tableCountLoc.countLoc
FROM dbo.tblDepartment d 
JOIN
(SELECT dl.depNum, COUNT(dl.locNum) AS countLoc
FROM dbo.tblDepLocation dl
GROUP BY dl.depNum) AS tableCountLoc
ON d.depNum = tableCountLoc.depNum
WHERE tableCountLoc.countLoc >= ALL(
SELECT MAX(tableCountLoc.countLoc)
FROM (SELECT dl.depNum, COUNT(dl.locNum) AS countLoc
FROM dbo.tblDepLocation dl
GROUP BY dl.depNum) AS tableCountLoc);

--35
SELECT d.depNum, d.depName, tableCountLoc.countLoc
FROM dbo.tblDepartment d 
JOIN
(SELECT dl.depNum, COUNT(dl.locNum) AS countLoc
FROM dbo.tblDepLocation dl
GROUP BY dl.depNum) AS tableCountLoc
ON d.depNum = tableCountLoc.depNum
WHERE tableCountLoc.countLoc <= ALL(
SELECT MIN(tableCountLoc.countLoc)
FROM (SELECT dl.depNum, COUNT(dl.locNum) AS countLoc
FROM dbo.tblDepLocation dl
GROUP BY dl.depNum) AS tableCountLoc);

--36
SELECT l.locName, tableCountDe.countDe
FROM dbo.tblLocation l
JOIN
(SELECT dl.locNum, COUNT(dl.depNum) AS countDe
FROM dbo.tblDepLocation dl
GROUP BY dl.locNum) AS tableCountDe
ON l.locNum = tableCountDe.locNum
WHERE tableCountDe.countDe >= ALL(
SELECT MAX(tableCountDe.countDe)
FROM (SELECT dl.locNum, COUNT(dl.depNum) AS countDe
FROM dbo.tblDepLocation dl
GROUP BY dl.locNum) AS tableCountDe
);

--37
SELECT l.locName, tableCountDe.countDe
FROM dbo.tblLocation l
JOIN
(SELECT dl.locNum, COUNT(dl.depNum) AS countDe
FROM dbo.tblDepLocation dl
GROUP BY dl.locNum) AS tableCountDe
ON l.locNum = tableCountDe.locNum
WHERE tableCountDe.countDe <= ALL(
SELECT MIN(tableCountDe.countDe)
FROM (SELECT dl.locNum, COUNT(dl.depNum) AS countDe
FROM dbo.tblDepLocation dl
GROUP BY dl.locNum) AS tableCountDe
);

--38
SELECT e.empSSN, e.empName, tableCountDependent.countDependent
FROM dbo.tblEmployee e
JOIN
(SELECT d.empSSN, COUNT(d.depRelationship) AS countDependent
FROM dbo.tblDependent d
GROUP BY d.empSSN) AS tableCountDependent
ON e.empSSN = tableCountDependent.empSSN
WHERE tableCountDependent.countDependent >= ALL(
SELECT MAX(tableCountDependent.countDependent)
FROM (SELECT d.empSSN, COUNT(d.depRelationship) AS countDependent
FROM dbo.tblDependent d
GROUP BY d.empSSN) AS tableCountDependent);  

--39
SELECT e.empSSN, e.empName, tableCountDependent.countDependent
FROM dbo.tblEmployee e
JOIN
(SELECT d.empSSN, COUNT(d.depRelationship) AS countDependent
FROM dbo.tblDependent d
GROUP BY d.empSSN) AS tableCountDependent
ON e.empSSN = tableCountDependent.empSSN
WHERE tableCountDependent.countDependent <= ALL(
SELECT MIN(tableCountDependent.countDependent)
FROM (SELECT d.empSSN, COUNT(d.depRelationship) AS countDependent
FROM dbo.tblDependent d
GROUP BY d.empSSN) AS tableCountDependent); 

--40
SELECT e.empSSN, e.empName, d.depName
FROM dbo.tblEmployee e FULL JOIN dbo.tblDependent de ON e.empSSN = de.empSSN
JOIN dbo.tblDepartment d ON e.depNum = d.depNum
WHERE de.depRelationship IS NULL;

--41
SELECT d.depNum, d.depName, COUNT(de.depRelationship) as countDependent
FROM dbo.tblDependent de
FULL JOIN(dbo.tblDepartment d JOIN dbo.tblEmployee e ON d.depNum = e.depNum)
ON de.empSSN = e.empSSN
GROUP BY d.depNum, d.depName
HAVING COUNT(de.depRelationship) = 0;
;

--42
SELECT e.empSSN, e.empName, d.depName 
FROM dbo.tblEmployee e FULL JOIN dbo.tblWorksOn w ON e.empSSN = w.empSSN
FULL JOIN dbo.tblDepartment d ON e.depNum = d.depNum
WHERE w.proNum IS NULL;

--43
SELECT d.depNum, d.depName
FROM dbo.tblDepartment d FULL JOIN dbo.tblProject p ON d.depNum = p.depNum
WHERE p.proNum IS NULL;

--44
SELECT DISTINCT d.depNum, d.depName
FROM dbo.tblDepartment d FULL JOIN dbo.tblProject p ON d.depNum = p.depNum
WHERE p.proName NOT IN ('ProjectA') OR p.proName IS NULL;

--45
SELECT p.depNum, d.depName, COUNT(p.proNum) as countPro
FROM dbo.tblProject p JOIN dbo.tblDepartment d ON p.depNum = d.depNum
GROUP BY p.depNum, d.depName;

--46
SELECT d.depNum, d.depName, tableCountPro.countPro
FROM dbo.tblDepartment d
JOIN
(SELECT p.depNum, COUNT(p.proNum) as countPro
FROM dbo.tblProject p
GROUP BY p.depNum) AS tableCountPro
ON d.depNum = tableCountPro.depNum
WHERE tableCountPro.countPro <= ALL(
SELECT MIN(tableCountPro.countPro)
FROM (SELECT p.depNum, COUNT(p.proNum) as countPro
FROM dbo.tblProject p
GROUP BY p.depNum) AS tableCountPro);

--47
SELECT d.depNum, d.depName, tableCountPro.countPro
FROM dbo.tblDepartment d
JOIN
(SELECT p.depNum, COUNT(p.proNum) as countPro
FROM dbo.tblProject p
GROUP BY p.depNum) AS tableCountPro
ON d.depNum = tableCountPro.depNum
WHERE tableCountPro.countPro >= ALL(
SELECT MAX(tableCountPro.countPro)
FROM (SELECT p.depNum, COUNT(p.proNum) as countPro
FROM dbo.tblProject p
GROUP BY p.depNum) AS tableCountPro);

--48
SELECT d.depNum, d.depName, tableCountEmp.countEmp, p.proName
FROM dbo.tblDepartment d
JOIN dbo.tblProject p ON d.depNum = p.depNum
JOIN
(SELECT e.depNum, COUNT(e.empSSN) AS countEmp 
FROM dbo.tblEmployee e
GROUP BY e.depNum
HAVING COUNT(e.empSSN) >= 5) AS tableCountEmp
ON d.depNum = tableCountEmp.depNum;

--49
SELECT e.empSSN, e.empName
FROM dbo.tblEmployee e FULL JOIN dbo.tblDependent de ON e.empSSN = de.empSSN
FULL JOIN dbo.tblDepartment d ON e.depNum = d.depNum
WHERE de.depRelationship IS NULL AND d.depName = N'Phòng Nghiên cứu và phát triển';

--50
SELECT e.empSSN, e.empName, tableCountWorkHour.countWorkHour
FROM dbo.tblEmployee e FULL JOIN dbo.tblDependent de ON e.empSSN = de.empSSN
FULL JOIN
(SELECT w.empSSN, SUM(w.workHours) as countWorkHour
FROM dbo.tblWorksOn w
GROUP BY w.empSSN) AS tableCountWorkHour
ON e.empSSN = tableCountWorkHour.empSSN
WHERE de.depRelationship IS NULL;

--51
SELECT e.empSSN, e.empName, tableCountDependent.countDependent, tableCountWorkHour.countWorkHour
FROM 
(SELECT d.empSSN, COUNT(d.depRelationship) AS countDependent
FROM dbo.tblDependent d
GROUP BY d.empSSN) AS tableCountDependent
JOIN 
(SELECT w.empSSN, SUM(w.workHours) as countWorkHour
FROM dbo.tblWorksOn w
GROUP BY w.empSSN) AS tableCountWorkHour  
ON tableCountWorkHour.empSSN = tableCountDependent.empSSN
JOIN dbo.tblEmployee e ON tableCountDependent.empSSN = e.empSSN
WHERE tableCountDependent.countDependent >= 3;

--52
SELECT e.empSSN, e.empName, tableCountWorkHour.countWorkHour
FROM dbo.tblEmployee e
JOIN (SELECT w.empSSN, SUM(w.workHours) as countWorkHour
FROM dbo.tblWorksOn w
GROUP BY w.empSSN) AS tableCountWorkHour
ON tableCountWorkHour.empSSN = e.empSSN
WHERE e.supervisorSSN = '30121050004';

SELECT *
FROM dbo.tblDepartment;

SELECT *
FROM dbo.tblDependent;

SELECT *
FROM dbo.tblDepLocation;

SELECT *
FROM dbo.tblEmployee;

SELECT *
FROM dbo.tblLocation;

SELECT *
FROM dbo.tblProject;

SELECT *
FROM dbo.tblWorksOn;

