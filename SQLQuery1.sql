-- 2.1.
SELECT enamn FROM DemoMedlem.dbo.Medlem;

-- 2.2. Visade endast antalet påverkade rader (652868 rows).

-- 2.3.
SET STATISTICS IO ON
GO

-- 2.4. Visar antalet påverkade rader samt en massa annat som t.ex. scan count, logical reads och physical reads.

-- 2.5.
SET STATISTICS TIME ON
GO

-- 2.6. Nu visas även tid för parse och compile, och execution.

-- 2.7. Include Actual Execution Plan (Ctrl+M)

-- 2.8. Nu visas mer skit.

-- 2.9. Vad bra.

-- 3.1.
SELECT * FROM DemoMedlem.dbo.Medlem

-- Första körningen:
-- 00:00:30, 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 1313 ms, elapsed time = 30502 ms.
-- Logical reads 40637.

-- Andra körningen:
-- 00:00:31, 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 1359 ms, elapsed time = 31594 ms.
-- Logical reads 40637.

-- Det var ingen större skillnad mellan första och andra körningen. Det var logical reads på båda, vet inte varför.

-- 3.2.
SELECT enamn, fnamn, postnr, ort FROM DemoMedlem.dbo.Medlem

-- Första körningen:
-- 00:00:08, 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 234 ms, elapsed time = 8041 ms.
-- Logical reads 40637

-- Andra körningen:
-- 00:00:09, 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 360 ms, elapsed time = 8788 ms.
-- Logical reads 40637

-- Det blev extremt stor skillnad jämfört med att ta med alla fälten.

-- 3.3.
SELECT * FROM DemoMedlem.dbo.Medlem ORDER BY enamn

-- Första körningen:
-- 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 5188 ms, elapsed time = 35125 ms.
-- Logical reads 40637
-- Execution plan. Sort, cost 98%. Clustered Index Scan, cost 2%.

-- Andra körningen:
-- 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 4640 ms, elapsed time = 36116 ms.
-- Logical reads 40637
-- Execution plan. Sort, cost 98%. Clustered Index Scan, cost 2%.

-- 3.4.
SELECT * FROM DemoMedlem.dbo.Medlem ORDER BY enamn, fnamn

-- Första körningen:
-- 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 5094 ms, elapsed time = 40698 ms.
-- Logical reads 40637
-- Execution plan. Sort, cost 98%. Clustered Index Scan, cost 2%.

-- Andra körningen:
-- 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 5625 ms, elapsed time = 37042 ms.
-- Logical reads 40637
-- Execution plan. Sort, cost 98%. Clustered Index Scan, cost 2%.

-- Det tog längre tid än punkt 1, eftersom raderna skulle sorteras.

-- 3.5.
SELECT enamn, fnamn, postnr, ort FROM DemoMedlem.dbo.Medlem ORDER BY enamn

-- Första körningen:
-- 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 2390 ms, elapsed time = 9952 ms.
-- Logical reads 40637
-- Execution plan. Sort, cost 65%. Clustered Index Scan, cost 35%.

-- Andra körningen:
-- 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 2328 ms, elapsed time = 11455 ms.
-- Logical reads 40637
-- Execution plan. Sort, cost 65%. Clustered Index Scan, cost 35%.

-- Det tog lite längre tid än punkt 2, men eftersom jag begränsade antalet fält var det bara 2 sekunders skillnad.

-- 3.6.
SELECT enamn, fnamn, postnr, ort FROM DemoMedlem.dbo.Medlem ORDER BY enamn, fnamn

-- Första körningen:
-- 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 3063 ms, elapsed time = 12591 ms.
-- Logical reads 40637
-- Execution plan. Sort, cost 65%. Clustered Index Scan, cost 35%.

-- Andra körningen:
-- 652868 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 2828 ms, elapsed time = 10072 ms.
-- Logical reads 40637
-- Execution plan. Sort, cost 65%. Clustered Index Scan, cost 35%.

-- Det tar lite längre tid att sortera på två fält än ett. Men bredden på databasen är viktigare.

-- 3.7.
SELECT * FROM DemoMedlem.dbo.Medlem WHERE ort = 'Kalmar'

-- Första körningen:
-- 4169 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 141 ms, elapsed time = 323 ms.
-- Logical reads 40637
-- Execution plan. Clustered Index Scan, cost 100%.

-- Andra körningen:
-- 4169 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 141 ms, elapsed time = 367 ms.
-- Logical reads 40637
-- Execution plan. Clustered Index Scan, cost 100%.

-- Det är lika många fält som punkt 1, men färre rader. Begränsa sökningen med where minskar tiden väldigt mycket.

-- 3.8.
SELECT * FROM DemoMedlem.dbo.Medlem WHERE ort LIKE 'Kal%'

-- Första körningen:
-- 4470 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 141 ms, elapsed time = 440 ms.
-- Logical reads 40637
-- Execution plan. Clustered Index Scan, cost 100%.

-- Andra körningen:
-- 4470 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 146 ms, elapsed time = 406 ms.
-- Logical reads 40637
-- Execution plan. Clustered Index Scan, cost 100%.

-- Enligt mitt test är WHERE snabbare än LIKE, men väldigt liten skillnad.

-- 3.9.
SELECT * FROM DemoMedlem.dbo.Medlem WHERE ort LIKE 'Kal%' AND enamn LIKE '%son%' ORDER BY fastnr

-- Första körningen:
-- 1398 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 156 ms, elapsed time = 214 ms.
-- Logical reads 40637
-- Execution plan. Sort, cost 4%. Clustered Index Scan, cost 96%.

-- Andra körningen:
-- 1398 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 156 ms, elapsed time = 217 ms.
-- Logical reads 40637
-- Execution plan. Sort, cost 4%. Clustered Index Scan, cost 96%.

-- Fler WHERE och LIKE gör frågan ännu snabbare, även om den ska sorteras på ett annat fält.

-- 3.10.
SELECT * FROM DemoMedlem.dbo.Medlem WHERE anndatum LIKE '2013%'

-- Första körningen:
-- 0 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 141 ms, elapsed time = 153 ms.
-- Logical reads 40637
-- Execution plan. Clustered Index Scan, cost 100%.

-- Andra körningen:
-- 0 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 140 ms, elapsed time = 149 ms.
-- Logical reads 40637
-- Execution plan. Clustered Index Scan, cost 100%.

-- Inga medlemmar har annulerats senaste året så det blir noll rader. Blir ändå inte så stor skillnad mot punkt 9.

-- 3.11.
SELECT postnr, LEFT(STR(anndatum), 6) AS år, COUNT(*) AS antal FROM DemoMedlem.dbo.Medlem GROUP BY postnr, LEFT(STR(anndatum), 6)

-- Första körningen:
-- 20591 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 703 ms, elapsed time = 1174 ms.
-- Logical reads 40637
-- Execution plan. Compute Scalar, 0%. Hash Match, 14%. Compute Scalar, 0%. Clustered Index Scan, 86%.

-- Andra körningen:
-- 20591 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 687 ms, elapsed time = 989 ms.
-- Logical reads 40637
-- Execution plan. Compute Scalar, 0%. Hash Match, 14%. Compute Scalar, 0%. Clustered Index Scan, 86%.

-- Det tog lite längre tid än de andra där jag har begränsat antalet fält, antagligen pga GROUP BY.

-- 3.12.
SELECT DISTINCT ort FROM DemoMedlem.dbo.Medlem ORDER BY ort

-- Första körningen:
-- 1392 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 359 ms, elapsed time = 363 ms.
-- Logical reads 40637
-- Execution plan. Sort, 0%. Hash Match, 12%. Clustered Index Scan, 88%.

-- Andra körningen:
-- 1392 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 359 ms, elapsed time = 363 ms.
-- Logical reads 40637
-- Execution plan. Sort, 0%. Hash Match, 12%. Clustered Index Scan, 88%.

-- Jämfört med punkt 2, som också begränsar antalet fält, gick denna snabbare. Antagligen eftersom det var färre rader.

-- 3.13
SELECT * FROM DemoMedlem.dbo.Medlem WHERE telenr1 != telenr2

-- Första körningen:
-- 590559 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 1312 ms, elapsed time = 28635 ms.
-- Logical reads 40637
-- Execution plan. Clustered Index Scan, cost 100%.

-- Andra körningen:
-- 590559 rows
-- Parse och compile. CPU time = 0 ms, elapsed time = 0 ms.
-- Execution. CPU time 1375 ms, elapsed time = 22356 ms.
-- Logical reads 40637
-- Execution plan. Clustered Index Scan, cost 100%.

-- Det tog fortfarande ganska lång tid jämfört med andra punkter med WHERE. Det är ju fortfarande många rader.

SELECT * FROM DemoMedlem.dbo.Medlem WHERE isnull(conamn, '') != ''
SELECT * FROM DemoMedlem.dbo.Medlem WHERE andrahand != 0
SELECT * FROM DemoMedlem.dbo.Medlem WHERE forhandl != 0
SELECT * FROM DemoMedlem.dbo.Medlem WHERE medlkort != 0
SELECT * FROM DemoMedlem.dbo.Medlem WHERE erskortdatum != 0

SELECT len(fastnr), len(fastnrgl) FROM DemoMedlem.dbo.Medlem
ORDER BY len(fastnrgl) DESC

SELECT len(conamn) FROM DemoMedlem.dbo.Medlem ORDER BY len(conamn) DESC