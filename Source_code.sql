CREATE TABLE Public."DATA"(id int, inning int , over int , ball int , batsman varchar(30) , non_striker varchar(30) , bowler varchar(30), batsman_runs int , extra_runs int , total_runs int , is_wicket int,  dismissal_kind varchar(30),  player_dismissed varchar(30) , fielder varchar(50) , extras_type varchar(30) , batting_team varchar(30) , bowling_team varchar(30))  
							 
select * from public."DATA";
							 
COPY public."DATA" FROM 'C:\Program Files\PostgreSQL\IPL_Ball.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public."MATCHDATA"(id int, city varchar(30),date DATE, player_of_match varchar(50) , venue varchar(60),neutral_venue int,team1 varchar(50),team2 varchar(50), toss_winner varchar(50),toss_decision varchar(20),winner varchar(50),result varchar(30),result_margin int,eliminator varchar(5),method varchar(20),umpire1 varchar(50), umpire2 varchar(50))

COPY public."MATCHDATA" FROM 'C:\Program Files\PostgreSQL\IPL_matches.csv' DELIMITER ',' CSV HEADER 

select * from public."MATCHDATA";
										--DATA TABLES CREATED SUCCESSFULLY--
													--WOHOOO:)!!--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
										-- Let's start with the PROJECT,Let's Go!!
										
/*Write queries for the following tasks:

1.Create a table named ‘matches’ with appropriate data types for columns*/

CREATE TABLE public.Matches(id int, city varchar(30),date DATE, player_of_match varchar(50) , venue varchar(60),neutral_venue int,team1 varchar(50),team2 varchar(50), toss_winner varchar(50),toss_decision varchar(20),winner varchar(50),result varchar(30),result_margin int,eliminator varchar(5),method varchar(20),umpire1 varchar(50), umpire2 varchar(50))


/*
2.Create a table named ‘deliveries’ with appropriate data types for columns*/

CREATE TABLE Public.deliveries(id int, inning int , over int , ball int , batsman varchar(30) , non_striker varchar(30) , bowler varchar(30), batsman_runs int , extra_runs int , total_runs int , is_wicket int,  dismissal_kind varchar(30),  player_dismissed varchar(30) , fielder varchar(50) , extras_type varchar(30) , batting_team varchar(30) , bowling_team varchar(30))  
			
/*
3.Import data from csv file ’IPL_matches.csv’ attached in resources to the table ‘matches’ which was created in Q1 */

COPY public.Matches FROM 'C:\Program Files\PostgreSQL\IPL_matches.csv' DELIMITER ',' CSV HEADER ;

/*
4. Import data from csv file ’IPL_Ball.csv’ attached in resources to the table ‘deliveries’ which was created in Q2*/
							 
COPY public.deliveries FROM 'C:\Program Files\PostgreSQL\IPL_Ball.csv' DELIMITER ',' CSV HEADER;

/*
5.Select the top 20 rows of the deliveries table after ordering them by id, inning, over, ball in ascending order.*/

SELECT * 
FROM deliveries
ORDER BY id,inning,over,ball ASC 
LIMIT 20;

/*
6.Select the top 20 rows of the matches table.*/

SELECT *
FROM matches 
LIMIT 20;

/*
7.Fetch data of all the matches played on 2nd May 2013 from the matches table..*/

SELECT *
FROM matches
WHERE date='2013-05-02';

/*
8.Fetch data of all the matches where the result mode is ‘runs’ and margin of victory is more than 100 runs.*/

SELECT *
FROM matches
WHERE result ='runs' AND result_margin > 100;

/*
9.Fetch data of all the matches where the final scores of both teams tied and order it in descending order of the date.*/

SELECT * 
FROM matches 
WHERE result = 'tie' and date='2020-10-18'
ORDER BY date DESC;

/*
10.Get the count of cities that have hosted an IPL match.*/
SELECT COUNT(DISTINCT city)
FROM matches;

/*
11.Create table deliveries_v02 with all the columns of the table ‘deliveries’ and an additional column ball_result containing values boundary, dot or other depending on the total_run (boundary for >= 4, dot for 0 and other for any other number)
(Hint 1 : CASE WHEN statement is used to get condition based results)
(Hint 2: To convert the output data of select statement into a table, you can use a subquery. Create table table_name as [entire select statement].*/

CREATE TABLE deliveries_v02 AS
SELECT *, 
       CASE
           WHEN total_runs >= 4 THEN 'boundary'
           WHEN total_runs = 0 THEN 'dot'
           ELSE 'other'
       END AS ball_result
FROM deliveries;

/*
12.Write a query to fetch the total number of boundaries and dot balls from the deliveries_v02 table.*/

--total number of boundaries

SELECT COUNT(ball_result)
FROM deliveries_v02
WHERE ball_result='boundary';

--total number of dot balls 

SELECT COUNT(ball_result)
FROM deliveries_v02
WHERE ball_result='dot';


/*
13.Write a query to fetch the total number of boundaries scored by each team from the deliveries_v02 table 
	and order it in descending order of the number of boundaries scored.*/
	
SELECT DISTINCT batting_team,COUNT(ball_result) AS boundaries_scored
FROM deliveries_v02
WHERE ball_result = 'boundary'
GROUP BY DISTINCT batting_team
ORDER BY boundaries_scored DESC;

/*
14.Write a query to fetch the total number of dot balls bowled by each team and 
	order it in descending order of the total number of dot balls bowled.*/
SELECT DISTINCT bowling_team, COUNT(ball_result) AS dot_balls_bowled
FROM deliveries_v02
WHERE ball_result='dot'
GROUP BY DISTINCT bowling_team
ORDER BY dot_balls_bowled DESC;

/*
15.Write a query to fetch the total number of dismissals by dismissal kinds where dismissal kind is not NA*/

SELECT dismissal_kind, COUNT(dismissal_kind) AS "Number of dismissals"
FROM deliveries
WHERE NOT dismissal_kind = 'NA'
GROUP BY dismissal_kind
ORDER BY "Number of dismissals" DESC;

/*
16.Write a query to get the top 5 bowlers who conceded maximum extra runs from the deliveries table*/

SELECT DISTINCT bowler , COUNT(extra_runs) AS Extras_bowled
FROM deliveries
GROUP BY DISTINCT bowler
ORDER BY Extras_bowled  DESC
LIMIT 5;

/*
17.Write a query to create a table named deliveries_v03 with all the columns of deliveries_v02 table 
	and two additional column (named venue and match_date) of venue and date from table matches*/

CREATE TABLE deliveries_v03 AS
SELECT a.*, b.venue, b.date
FROM deliveries_v02 AS a
LEFT JOIN matches AS b ON a.id = b.id
ORDER BY a.id;


/*
18.Write a query to fetch the total runs scored for each venue and order it in the descending order of total runs scored.*/

SELECT DISTINCT venue , SUM(total_runs) AS venue_runs
FROM deliveries_v03
GROUP BY DISTINCT venue
ORDER BY venue_runs DESC;


/*
19.Write a query to fetch the year-wise total runs scored at Eden Gardens and order it in the descending order of total runs scored.*/

SELECT EXTRACT(YEAR FROM date) AS year_wise , 	SUM(total_runs) AS year_wise_runs
FROM deliveries_v03
WHERE venue='Eden Gardens'
GROUP BY year_wise
ORDER BY year_wise_runs DESC;


/*
20.Get unique team1 names from the matches table,
	you will notice that there are two entries for Rising Pune Supergiant one with Rising Pune Supergiant and another one with Rising Pune Supergiants. 
	Your task is to create a matches_corrected table with two additional columns team1_corr and team2_corr containing team names 
	with replacing Rising Pune Supergiants with Rising Pune Supergiant. Now analyse these newly created columns.*/

CREATE TABLE matches_corrected AS
SELECT *,
       REPLACE(team1, 'Rising Pune Supergiants', 'Rising Pune Supergiant') AS team1_corr,
       REPLACE(team2, 'Rising Pune Supergiants', 'Rising Pune Supergiant') AS team2_corr
FROM matches;

/*
21.Create a new table deliveries_v04 with the first column as ball_id containing information of 
	match_id, inning, over and ball separated by ‘-’ (For ex. 335982-1-0-1 match_id-inning-over-ball) and rest of the columns same as deliveries_v03)*/

CREATE TABLE deliveries_v04 AS
SELECT
    CONCAT(id, '-', inning, '-', over, '-', ball) AS ball_id,
    *
FROM deliveries_v03;

/*
22.Compare the total count of rows and total count of distinct ball_id in deliveries_v04*/
SELECT COUNT(*) AS "Total Rows",
       COUNT(DISTINCT ball_id) AS "Distinct Ball IDs"
FROM deliveries_v04;


/*
23.SQL Row_Number() function is used to sort and assign row numbers to data rows in the presence of multiple groups. 
	For example, to identify the top 10 rows which have the highest order amount in each region, 
	we can use row_number to assign row numbers in each group (region) with any particular order (decreasing order of order amount)
	and then we can use this new column to apply filters. 
	Using this knowledge, solve the following exercise. You can use hints to create an additional column of row number.
	Create table deliveries_v05 with all columns of deliveries_v04 and an additional column for row number partition over ball_id. 
	(HINT : Syntax to add along with other columns,  row_number() over (partition by ball_id) as r_num)*/

CREATE TABLE deliveries_v05 AS
SELECT *,
		ROW_NUMBER() OVER (PARTITION BY ball_id) AS r_num
FROM deliveries_v04;

/*
24.Use the r_num created in deliveries_v05 to identify instances where ball_id is repeating. (HINT : select * from deliveries_v05 WHERE r_num=2;)*/

SELECT  *
FROM deliveries_v05
WHERE r_num = 2;

/*
25.Use subqueries to fetch data of all the ball_id which are repeating.
	(HINT: SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=2);*/

SELECT *
FROM deliveries_v05
WHERE ball_id IN (SELECT ball_id FROM deliveries_v05 WHERE r_num = 2);

------------------------------------------------------------------------------------------------------
-- module questions

select player_of_match from matches;

select total_runs from deliveries;

SELECT COUNT(*) AS "Instances of Repeating ball_id"
FROM deliveries_v05
WHERE r_num > 1;

select * from customer where customer_name~*'^(ab)+[a-z\s]+$';



select * from deliveries where ball ='null'
select customer_id from customer where age is null

CREATE TABLE deliveries_v000 AS
SELECT *, 
      case when total_runs>=4 then 'boundary'
	when total_runs=0 then 'dot'
else 'other'
end as ball_result
FROM deliveries;
