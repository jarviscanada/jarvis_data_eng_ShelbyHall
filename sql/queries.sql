--Modifying Data  
--Question 1: 

INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) 
VALUES 
  (9, 'Spa', 20, 30, 100000, 800);

--Question 2:

INSERT INTO cd.facilities
(facid, name, membercost, guestcost,initialoutlay, monthlymaintenance)
SELECT
MAX(facid) + 1,
'Spa',
20,
30,
100000,
800
FROM
cd.facilities;

--Question 3:

UPDATE cd.facilities
SET initialoutlay=10000
WHERE name = 'Tennis Court 2';


--Question 4:

UPDATE 
  cd.facilities 
SET 
  membercost = (
    SELECT 
      membercost * 1.1 
    FROM 
      cd.facilities 
    WHERE 
      name = 'Tennis Court 1'
  ), 
  guestcost = (
    SELECT 
      guestcost * 1.1 
    FROM 
      cd.facilities 
    WHERE 
      name = 'Tennis Court 1'
  ) 
WHERE 
  name = 'Tennis Court 2';


--Question 5:

DELETE FROM cd.bookings;


--Question 6:

DELETE
FROM cd.members
WHERE memid = 37;


--Basic Queries

--Question 7:

SELECT 
  facid, 
  name, 
  membercost, 
  monthlymaintenance 
FROM 
  cd.facilities 
WHERE 
  membercost > 0 
  AND membercost < monthlymaintenance / 50;

--Question 8:

SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';

--Question 9:

SELECT * 
FROM 
  cd.facilities 
WHERE 
  facid IN (1, 5);

--Question 10:

SELECT 
  memid, 
  surname, 
  firstname, 
  joindate 
FROM 
  cd.members 
WHERE 
  joindate > '2012-09-01';

--Question 11:

SELECT 
  cd.members.surname 
FROM 
  cd.members 

UNION 

SELECT 
  cd.facilities.name 
FROM 
  cd.facilities;


--Join Tables

--Question 12:

SELECT 
  cd.bookings.starttime 
FROM 
  cd.bookings 
  INNER JOIN cd.members on cd.members.memid = cd.bookings.memid 
WHERE 
  cd.members.firstname = 'David' 
  AND cd.members.surname = 'Farrell';


--Question 13:

SELECT 
  bks.starttime AS start, facs.name
FROM 
  cd.facilities facs
    JOIN cd.bookings bks
    ON facs.facid = bks.facid 
WHERE 
  facs.name IN ('Tennis Court 1', 'Tennis Court 2') 
  AND bks.starttime >= '2012-09-21' 
  AND bks.starttime < '2012-09-22'
ORDER BY
  bks.starttime;

--Question 14:

SELECT 
  mems.firstname AS memfname, 
  mems.surname AS memsname, 
  recs.firstname AS recfname,
  recs.surname AS recsname
FROM 
  cd.members mems 
  LEFT JOIN cd.members recs
    ON recs.memid = mems.recommendedby 
ORDER BY 
  memsname, 
  memfname;

--Question 15:

SELECT
  mems.firstname AS memfname, 
  mems.surname AS memsname, 
  recs.firstname AS recfname, 
  recs.surname AS recsname 
FROM 
  cd.members mems 
  LEFT OUTER JOIN cd.members recs ON recs.memid = mems.recommendedby
ORDER BY 
  memsname, 
  memfname;

--Question 16:

SELECT 
  DISTINCT mems.firstname || ' ' || mems.surname as member, 
  (
    SELECT 
      recs.firstname || ' ' || recs.surname as recommender 
    FROM 
      cd.members recs 
    WHERE 
      recs.memid = mems.recommendedby
  ) 
FROM 
  cd.members mems 
ORDER BY 
  member;


--Aggregation

--Question 17:

SELECT 
  recommendedby, 
  COUNT(*) 
FROM 
  cd.members 
WHERE 
  recommendedby IS NOT NULL 
GROUP BY 
  recommendedby 
ORDER BY 
  recommendedby;

--Question 18:

SELECT
  cd.bookings.facid,
  sum(cd.bookings.slots) AS total_slots
FROM
  cd.bookings
GROUP BY
  facid
ORDER BY
  facid;


--Question 19:

SELECT 
  facid, 
  sum(slots) AS total_slots 
FROM 
  cd.bookings 
WHERE 
  starttime >= '2012-09-01' 
  and starttime < '2012-10-01' 
GROUP BY 
  facid 
ORDER BY 
  sum(slots);


--Question 20:

SELECT 
  facid, 
  extract(month FROM starttime) AS month, 
  sum(slots) as total_slots 
FROM 
  cd.bookings 
WHERE 
  extract(year FROM starttime) = 2012 
GROUP BY 
  facid, 
  month 
ORDER BY 
  facid, 
  month;

--Question 21:

SELECT COUNT(DISTINCT memid) AS count
FROM cd.bookings;

--Question 22:

SELECT 
  mems.surname, 
  mems.firstname, 
  mems.memid, 
  MIN(bks.starttime) AS starttime 
FROM 
  cd.bookings bks 
  INNER JOIN cd.members mems on mems.memid = bks.memid 
WHERE 
  starttime >= '2012-09-01' 
GROUP BY 
  mems.surname, 
  mems.firstname, 
  mems.memid 
ORDER BY 
  mems.memid;

--Question 23:

SELECT 
  count(*) over(), 
  firstname, 
  surname 
From 
  cd.members 
ORDER BY 
  joindate;


--Question 24:

SELECT 
  row_number() OVER(ORDER BY joindate), 
  firstname, 
  surname 
FROM 
  cd.members 
ORDER BY
  joindate;


Question 25:

SELECT
  facid, 
  total 
FROM 
  (
    SELECT 
      facid, 
      sum(slots) total, 
      rank() OVER(ORDER BY SUM(slots) desc) rank 
    FROM 
      cd.bookings 
    GROUP BY 
      facid
  ) AS ranked 
WHERE 
  rank = 1;

--String
--Question 26:

SELECT surname || ', ' || firstname as name
FROM cd.members;


--Question 27:

SELECT
  memid, 
  telephone 
FROM 
  cd.members 
WHERE 
  telephone ~ '[()]';

--Question 28:

SELECT
  substr (mems.surname, 1, 1) AS letter, 
  COUNT(*) as count 
FROM 
  cd.members mems 
GROUP BY 
  letter 
ORDER BY 
  letter;

