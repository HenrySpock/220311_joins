-- write your queries here

-- PART 1. DATA
-- 1. Join the two tables so taht every column and record appears, regardless of whether there is an 
-- owner_id. 
SELECT *
FROM owners
LEFT JOIN vehicles
ON owners.id = vehicles.owner_id;

-- 2. Count the number of cars for each owner. Display the owners first_name, last_name, and count of vehicles. 
-- The first_name should be ordered in ascending order. 
SELECT owners.first_name, owners.last_name, COUNT(vehicles.id) AS vehicle_count
FROM owners
LEFT JOIN vehicles
ON owners.id = vehicles.owner_id
GROUP BY owners.first_name, owners.last_name
ORDER BY owners.first_name ASC;

-- 3. Count the number of cars for each owner and display the average price for each of the cars as integers. Display
-- the owners first_name, last_name, average price and count of vehicles. The first_name should be ordered in descending order. 
-- Only display results with more than one vehicle and an average price greater than 10000.
SELECT owners.first_name, owners.last_name, COUNT(vehicles.id) AS vehicle_count, CAST(AVG(vehicles.price) AS INTEGER) AS avg_price
FROM owners
LEFT JOIN vehicles
ON owners.id = vehicles.owner_id
GROUP BY owners.first_name, owners.last_name
HAVING COUNT(vehicles.id) > 1 AND AVG(vehicles.price) > 10000
ORDER BY owners.first_name DESC;

-- PART 2A. SQL ZOO TUTORIAL 6 JOINS
-- 1. The first example shows the goal scored by a player with the last name 'Bender'. The * says 
-- to list all the columns in the table - a shorter way of saying matchid, teamid, player, 
-- gtime 
WHERE teamid = 'GER'

-- 2. 
-- From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we
--  want to know what teams were playing in that match.
-- Notice in the that the column matchid in the goal table corresponds to the id column in the 
-- game table. We can look up information about game 1012 by finding that row in the game table.
-- Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
  FROM game 
WHERE id = 1012
Submit SQLRestore default 

-- 3. You can combine the two steps into a single query with a JOIN.
-- SELECT *
--   FROM game JOIN goal ON (id=matchid)
-- The FROM clause says to merge data from the goal table with that from the game table. The ON 
-- says how to figure out which rows in game go with which rows in goal - the matchid from goal 
-- must match id from game. (If we wanted to be more clear/specific we could say
-- ON (game.id=goal.matchid)
-- The code below shows the player (from the goal) and stadium name (from the game table) for 
-- every goal scored.
-- Modify it to show the player, teamid, stadium and mdate for every German goal.
-- SELECT player,stadium
--   FROM game JOIN goal ON (id=matchid)

SELECT goal.player, goal.teamid, game.stadium, game.mdate
FROM game JOIN goal ON (game.id = goal.matchid)
WHERE goal.teamid = 'GER'

-- 4. Use the same JOIN as in the previous question.
-- Show the team1, team2 and player for every goal scored by a player called Mario player 
-- LIKE 'Mario%'

SELECT team1, team2, player
FROM game
JOIN goal ON id=matchid
WHERE player LIKE 'Mario%'

-- 5. The table eteam gives details of every national team including the coach. You can JOIN 
-- goal to eteam using the phrase goal JOIN eteam on teamid=id
-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
-- SELECT player, teamid, gtime
--   FROM goal 
--  WHERE gtime<=10  

SELECT goal.player, goal.teamid, eteam.coach, goal.gtime
FROM goal 
JOIN eteam ON goal.teamid = eteam.id
WHERE goal.gtime <= 10;

-- 6. To JOIN game with eteam you could use either game JOIN eteam ON (team1=eteam.id) or game 
-- JOIN eteam ON (team2=eteam.id)
-- Notice that because id is a column name in both game and eteam you must specify eteam.id 
-- instead of just id
-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the 
-- team1 coach.

SELECT mdate, teamname
FROM game JOIN eteam ON (team1 = eteam.id)
WHERE coach = 'Fernando Santos'

-- 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT goal.player
FROM game
JOIN goal ON game.id = goal.matchid
WHERE game.stadium = 'National Stadium, Warsaw'
ORDER BY goal.gtime

-- 8. The example query shows all goals scored in the Germany-Greece quarterfinal.
-- Instead show the name of all players who scored a goal against Germany.
-- HINT
-- SELECT player, gtime
--   FROM game JOIN goal ON matchid = id 
--     WHERE (team1='GER' AND team2='GRE')  

SELECT DISTINCT goal.player
FROM game
JOIN goal ON game.id = goal.matchid
WHERE (game.team1 = 'GER' OR game.team2 = 'GER')
AND goal.teamid != 'GER'
ORDER BY goal.player;

-- 9. Show teamname and the total number of goals scored.
-- COUNT and GROUP BY

SELECT eteam.teamname, COUNT(goal.player) AS total_goals
FROM eteam
JOIN goal ON eteam.id = goal.teamid
GROUP BY eteam.teamname
ORDER BY eteam.teamname;

-- 10. Show the stadium and the number of goals scored in each stadium.

SELECT stadium, COUNT(*) AS goals_scored
FROM game
JOIN goal ON game.id = goal.matchid
GROUP BY stadium
ORDER BY goals_scored DESC;

-- 11. For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid,mdate,COUNT(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid,mdate
;

-- 12. For every match where 'GER' scored, show matchid, match date and the number of goals scored 
-- by 'GER'
SELECT goal.matchid, game.mdate, COUNT(*) AS goals_scored
FROM goal
JOIN game ON goal.matchid = game.id
WHERE goal.teamid = 'GER'
GROUP BY goal.matchid, game.mdate
ORDER BY game.mdate, goal.matchid

-- 13. List every match with the goals scored by each team as shown. This will use "CASE WHEN" 
-- which has not been explained in any previous exercises.
-- mdate	team1	score1	team2	score2
-- 1 July 2012	ESP	4	ITA	0
-- 10 June 2012	ESP	1	ITA	1
-- 10 June 2012	IRL	1	CRO	3
-- ...
-- Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in 
-- score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored 
-- by team1. Sort your result by mdate, matchid, team1 and team2.
SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1,
  team2,
  SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
  FROM game LEFT JOIN goal ON matchid = id 
GROUP BY mdate,matchid,team1,team2
;

-- PART 2B. SQL ZOO TUTORIAL 7 MORE JOIN
-- 1. List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962 

-- 2.When was Citizen Kane released? 
SELECT yr FROM movie WHERE title='Citizen Kane' 

-- 3. List all of the Star Trek movies, include the id, title and yr (all of these movies include 
-- the words Star Trek in the title). Order results by year.

SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

-- 4. What id number does the actor 'Glenn Close' have?
SELECT id FROM actor WHERE name='Glenn Close';

-- 5. What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca';

-- 6. Obtain the cast list for 'Casablanca'
SELECT actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE movie.title = 'Casablanca'
ORDER BY casting.ord ASC;

-- 7. Obtain the cast list for the film 'Alien'
SELECT actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE movie.title = 'Alien'
ORDER BY casting.ord ASC;

-- 8. List the films in which 'Harrison Ford' has appeared
SELECT DISTINCT movie.title
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE actor.name = 'Harrison Ford'

-- 9. List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: 
-- the ord field of casting gives the position of the actor. If ord=1 then this actor is in the 
-- starring role]
SELECT movie.title
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE actor.name = 'Harrison Ford' AND casting.ord > 1
ORDER BY movie.yr;

-- 10. List the films together with the leading star for all 1962 films.
SELECT movie.title, actor.name
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE movie.yr = 1962
AND casting.ord = 1;

-- 11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he 
-- made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title)
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON actor.id = casting.actorid
WHERE actor.name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2
ORDER BY COUNT(title) DESC, yr;

12.
-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
-- Did you get "Little Miss Marker twice"?

SELECT title, name
  FROM movie, casting, actor
  WHERE movieid=movie.id
    AND actorid=actor.id
    AND ord=1
    AND movieid IN
    (SELECT movieid FROM casting, actor
     WHERE actorid=actor.id
     AND name='Julie Andrews')
;

-- 13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.

SELECT actor.name
FROM actor
JOIN casting ON actor.id = casting.actorid AND casting.ord = 1
GROUP BY actor.name
HAVING COUNT(*) >= 15
ORDER BY actor.name ASC;


-- 14. List the films released in the year 1978 ordered by the number of actors in the cast, 
-- then by title.

SELECT m.title, COUNT(c.actorid) AS actor_count
FROM movie m
JOIN casting c ON m.id = c.movieid
WHERE m.yr = 1978
GROUP BY m.id, m.title
ORDER BY actor_count DESC, m.title;


-- 15. List all the people who have worked with 'Art Garfunkel'.

SELECT DISTINCT a.name
FROM actor a
JOIN casting c1 ON c1.actorid = a.id
JOIN casting c2 ON c2.movieid = c1.movieid
JOIN actor ag ON ag.name = 'Art Garfunkel' AND ag.id = c2.actorid
WHERE a.id <> ag.id;
