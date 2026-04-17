# Introduction
In this SQL project, I worked with a relational dataset representing a newly established country club, consisting of three core tables: members, facilities, and bookings. The dataset captures operational data, including member demographic, facility cost structures, and bookings over time. Using the SQL queries below, these explore the possibilites of how information can be leveraged to analyze facility usage, demand patterns, and overall operational efficiency. With that being said, this project provided a realistic environment to develop and apply skills in querying, data modeling, and extracting actionable insights from structured data.


# SQL Queries

###### Table Setup (DDL)
```sql
--Connect to database
\c cd

--Create the members table
CREATE TABLE cd.members
(
  memid integer NOT NULL,
  surname character varying (200) NOT NULL,
  firstname character varying(200) NOT NULL,
  address character varying(300) NOT NULL,
  zipcode integer NOT NULL,
  telephone character varying(20) NOT NULL,
  recommendedby integer,
  joindate timestamp NOT NULL,
  CONSTRAINT members_pk PRIMARY KEY (memid),
  CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
      REFERENCES cd.members(memid) ON DELETE SET NULL

);

--Create the facilities table
CREATE TABLE cd.facilities
(
  facid integer NOT NULL,
  name character varying(100) NOT NULL,
  membercost numeric NOT NULL,
  guestcost numeric NOT NULL,
  initialoutlay numeric NOT NULL,
  monthlymaintenance numeric NOT NULL,
  CONSTRAINT facilities_pk PRIMARY KEY (facid)
);

--Create the bookings table
CREATE TABLE cd.bookings
(
  bookid integer NOT NULL,
  facid integer NOT NULL,
  memid integer NOT NULL,
  starttime timestamp NOT NULL,
  slots integer NOT NULL,
  CONSTRAINT bookings_pk PRIMARY KEY (bookid),
  CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
  CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
);
```

### Modifying Data  
##### Question 1: 

The club is adding a new facility - add it into the facilities table. 
```sql
--Use the following values: facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) 
VALUES 
  (9, 'Spa', 20, 30, 100000, 800);
```

##### Question 2:

Try adding the spa to the facilities table again - automatically generate the value for the next facid, rather than specifying it as a constant.
```sql
--Use the following values: Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

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
```

##### Question 3:

There was a mistake made when entering the data for the second tennis court. Alter the data to fix the error.

```sql
-- The initial outlay was 10000 rather than 8000

UPDATE cd.facilities
SET initialoutlay=10000
WHERE name = 'Tennis Court 2';
```

##### Question 4:

Alter the price of the second tennis court so that it costs 10% more than the first one.   

```sql
--Do this without using constant values for the prices, so that the statement can be reused

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
```

##### Question 5:

As part of a clearout of our database, delete all bookings from the cd.bookings table.    

```sql

DELETE FROM cd.bookings;
```

##### Question 6:

Remove member 37, who has never made a booking from our database.

```sql

DELETE
FROM cd.members
WHERE memid = 37;
```

### Basic Queries

##### Question 7:

Produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost.                                                                                          

```sql
--Return the facility id, facility name, member cost, and monthly maintenance of the facilities in question.

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
```

##### Question 8:

Produce a list of all facilities with the word 'Tennis' in their name. 

```sql

SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';
```

##### Question 9:

Retrieve the details of facilities with ID 1 and 5.                                                        

```sql
--Try to do it without using the OR operator.

SELECT * 
FROM 
  cd.facilities 
WHERE 
  facid IN (1, 5);
```
##### Question 10:

Produce a list of members who joined after the start of September 2012.   

```sql
--Return the memid, surname, firstname, and joindate of the members in question.

SELECT 
  memid, 
  surname, 
  firstname, 
  joindate 
FROM 
  cd.members 
WHERE 
  joindate > '2012-09-01';
```
##### Question 11:

You, for some reason, want a combined list of all surnames and all facility names.

```sql
SELECT 
  cd.members.surname 
FROM 
  cd.members 

UNION 

SELECT 
  cd.facilities.name 
FROM 
  cd.facilities;
```

### Join Tables

##### Question 12:

Produce a list of the start times for bookings by members named 'David Farrell'.    

```sql

SELECT 
  cd.bookings.starttime 
FROM 
  cd.bookings 
  INNER JOIN cd.members on cd.members.memid = cd.bookings.memid 
WHERE 
  cd.members.firstname = 'David' 
  AND cd.members.surname = 'Farrell';
```

##### Question 13:

Produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'. 

```sql
--Return a list of start time and facility name pairings, ordered by the time.

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

```
##### Question 14:

Output a list of all members, including the individual who recommended them (if any).     

```sql
--Ensure that results are ordered by (surname, firstname). 

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
```
##### Question 15:

Output a list of all members, including the individual who recommended them (if any). 

```sql
--Ensure that results are ordered by (surname, firstname).

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
```

##### Question 16:

Output a list of all members, including the individual who recommended them (if any), without using any joins.    

```sql
--Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.

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
```

### Aggregation

##### Question 17:

Produce a count of the number of recommendations each member has made.                                                              

```sql
-- Order by member ID.

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
```

##### Question 18:

Produce a list of the total number of slots booked per facility.   

```sql
--Produce an output table consisting of facility id and slots, sorted by facility id.  
SELECT
  cd.bookings.facid,
  sum(cd.bookings.slots) AS total_slots
FROM
  cd.bookings
GROUP BY
  facid
ORDER BY
  facid;
```

##### Question 19:

Produce a list of the total number of slots booked per facility in the month of September 2012.        

```sql
--Produce an output table consisting of facility id and slots, sorted by the number of slots.

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
```

##### Question 20:

Produce a list of the total number of slots booked per facility per month in the year of 2012.   

```sql
--Produce an output table consisting of facility id and slots, sorted by the id and month.

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
```

##### Question 21:

Find the total number of members (including guests) who have made at least one booking.      

```sql

SELECT COUNT(DISTINCT memid) AS count
FROM cd.bookings;
```

##### Question 22:

Produce a list of each member name, id, and their first booking after September 1st 2012. 

```sql
--Order by member ID. 
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
```

##### Question 23:

Produce a list of member names, with each row containing the total member count.

```sql
-- Order by join date, and include guest members.

SELECT 
  count(*) over(), 
  firstname, 
  surname 
From 
  cd.members 
ORDER BY 
  joindate;
```

##### Question 24:

Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. 

```sql
--Member IDs are not guaranteed to be sequential.

SELECT 
  row_number() OVER(ORDER BY joindate), 
  firstname, 
  surname 
FROM 
  cd.members 
ORDER BY
  joindate;
```

##### Question 25:

Output the facility id that has the highest number of slots booked.           

```sql
--In the event of a tie, all tied results get output

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
```

### String
##### Question 26:

Output the names of all members, formatted as 'Surname, Firstname’.  

```sql

SELECT surname || ', ' || firstname as name
FROM cd.members;

```

##### Question 27:

Find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.  

```sql

SELECT
  memid, 
  telephone 
FROM 
  cd.members 
WHERE 
  telephone ~ '[()]';
```

##### Question 28:

Produce a count of how many members you have whose surname starts with each letter of the alphabet.   
```sql
--Sort by the letter, and don't worry about printing out a letter if the count is 0.

SELECT
  substr (mems.surname, 1, 1) AS letter, 
  COUNT(*) as count 
FROM 
  cd.members mems 
GROUP BY 
  letter 
ORDER BY 
  letter;
```
