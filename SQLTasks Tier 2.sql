/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

query1="""
SELECT name FROM `Facilities` where membercost>0 ;   
"""
cur.execute(query1)
rows=cur.fetchall()
print("name")
for row in rows:
    print(row)
    

/* Q2: How many facilities do not charge a fee to members? */

query2="""
SELECT count(name) FROM `Facilities` where membercost=0 ;   
"""
cur.execute(query2)
rows=cur.fetchall()
print("count")
for row in rows:
    print(row)



/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

query3="""
SELECT facid, name, membercost, monthlymaintenance FROM `Facilities` where membercost>0 
and membercost<0.2*monthlymaintenance ; 
"""
cur.execute(query3)
rows=cur.fetchall()
print("facid, name, membercost, monthlymaintenance")
for row in rows:
    print(row)



/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

query4="""
SELECT * FROM `Facilities` where facid in (1,5);
"""
cur.execute(query4)
rows=cur.fetchall()
print("bookid, facid, memid, starttime, slots")
for row in rows:
    print(row)


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

query5="""
SELECT name, monthlymaintenance, CASE WHEN monthlymaintenance > 100 THEN 'expensive' 
ELSE 'cheap' END as cost FROM `Facilities` ;
"""
cur.execute(query5)
rows=cur.fetchall()
print("name, monthlymaintenance, cost")
for row in rows:
    print(row)




/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */


query6="""
SELECT  firstname, surname  FROM `Members` where joindate=(SELECT max(joindate) FROM `Members`) ;
"""
cur.execute(query6)
rows=cur.fetchall()
print("firstname, surname")
for row in rows:
    print(row)
    
    

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

query7="""
SELECT  distinct firstname ||' ' || surname  as membername, name as facility From `Members`  
join `Bookings` on Members.memid=Bookings.memid join `Facilities` 
on Bookings.facid=Facilities.facid where name like 'Tennis%' order by membername, facility; 
"""
cur.execute(query7)
rows=cur.fetchall()
print("membername,facility")
for row in rows:
    print(row)
    
    
    
/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

query8="""
SELECT  name as facility, firstname ||' ' || surname as membername,   
CASE WHEN Members.memid=0 THEN guestcost*slots*2 ELSE membercost*slots*2 END 
as cost  From `Members`  join `Bookings` on Members.memid=Bookings.memid 
join `Facilities` on Bookings.facid=Facilities.facid where starttime 
like '2012-09-14%' and ((Members.memid!=0 and membercost*slots*2 >30) 
or (Members.memid=0 and guestcost*slots*2 >30)) order by cost desc;
"""
cur.execute(query8)
rows=cur.fetchall()
print("facility, membername, cost")
for row in rows:
    print(row)





/* Q9: This time, produce the same result as in Q8, but using a subquery. */


query9="""
SELECT  facility, membername, cost from (
SELECT  name as facility, firstname ||' ' || surname as membername, Members.memid, slots, membercost, guestcost,  
CASE WHEN Members.memid=0 THEN guestcost*slots*2 
ELSE membercost*slots*2 END as cost  From `Members`  join `Bookings` 
on Members.memid=Bookings.memid 
join `Facilities` on Bookings.facid=Facilities.facid 
where starttime like '2012-09-14%' ) as bookings_info 
where cost > 30 order by cost desc; 
"""
cur.execute(query9)
rows=cur.fetchall()
print("facility, membername, cost")
for row in rows:
    print(row)




/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

query10="""
SELECT  name as facility, sum(CASE WHEN Bookings.memid=0 THEN guestcost*slots*2 
ELSE membercost*slots*2 END) as revenue From `Bookings`  join `Facilities` 
on Bookings.facid=Facilities.facid group by facility having revenue <1000 order by revenue;
"""
cur.execute(query10)
rows=cur.fetchall()
print("facility, revenue")
for row in rows:
    print(row)




/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


query11="""
         SELECT distinct firstname ||' ' ||  surname as member, (select CASE WHEN b.memid=0 THEN ' ' ELSE firstname ||' ' ||  surname END as recommender FROM `Members` b where a.recommendedby=b.memid ) as recommender from `Members` a order by member ;
        """
cur.execute(query11)
rows=cur.fetchall()
print("member, recommender")
for row in rows:
    print(row)



/* Q12: Find the facilities with their usage by member, but not guests */


query12="""
        SELECT  a.facility, count(a.membername) as No_of_members from 
        (SELECT  distinct name as facility, firstname ||' ' ||  surname as membername  From `Members`  
        join `Bookings` on Members.memid=Bookings.memid join `Facilities` 
        on Bookings.facid=Facilities.facid 
        where Members.memid!=0 order by membername, facility ) as a group by facility; 
        """
cur.execute(query12)
rows = cur.fetchall()
print("facility,No_of_members")
for row in rows:
    print(row)  



/* Q13: Find the facilities usage by month, but not guests */

query13="""
         select name as facility, a.month, count(name) as facility_usage from `Facilities` join (SELECT facid, strftime('%m',starttime) as month, starttime  from `Bookings` where Bookings.memid!=0) as a on a.facid=Facilities.facid group by a.month, facility ;
        """
cur.execute(query13)
rows = cur.fetchall()
print("facility,month,facility_usage")
for row in rows:
    print(row)








