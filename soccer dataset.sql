### European championship 2016 database
#The sample database represents some of the data storage and retrieval about a soccer tournament based on EURO CUP 2016. You might love football, and for all the football lovers we are providing a detail information about a football tournament. This design of database will make it easier to understand the various questions comes in your mind about a soccer tournament.

############# Basic Questions######################

#q1
select count(*) from soccer_venue;

#q2
select count(DISTINCT(team_id)) from player_mast;

#q3
select count(*) where goal_schedule = 'NT';

#q4
select count(*) where result = 'WIN';

#q5
select count(*) where result = 'DRAW';

#q6
select min(play_date) from match_mast;

#q11
select match_no, count(distinct(goal_id)) from goal_details group by match_no order by match_no;

#q12
select match_no,play_date,goal_score from mmatch_mast where stop1_sec = 0;

#13
select count(*) from match_details where win_lose = 'D' AND goal_score = 0 and play_stage = 'G';

#14
select count(*) from match_details where win_lose ='W' and decided_by <> 'P' and goal_score = 1;

#15
select count(*) as player_replaced from player_in_out where in_out = 'I';

#q16
select count(*) as player_replaced from player_in_out where in_out = 'I' and play_schedule = 'NT';

#q19
select count(*) from match_details where win_lose ='D' and goal_score = 0;

#q21 
SELECT 
    play_half, play_schedule, COUNT(*) AS no_substitude
FROM
    player_in_out
WHERE
    in_out = 'I'
GROUP BY play_half , play_schedule
ORDER BY play_half , play_schedule , COUNT(*) DESC;

#q22
select count(*) as no_of_penalty_kicks from penalty_shootout;

#q23
select count(*) as no_of_penalty_kicks from penalty_shootout where score_goal = 'Y';

#q24
select count(*) as goals_missed from penalty_shootout where score_goal = 'N';

#q25
SELECT 
    c.match_no,
    a.country_name AS 'Team',
    b.player_name,
    b.jersey_no,
    c.score_goal,
    c.kick_no
FROM
    soccer_country a,
    penalty_shootout c,
    player_mast b
WHERE
    c.team_id = a.country_id
        AND c.player_id = b.player_id;
        
#q27
SELECT 
    play_half, play_schedule, COUNT(*)
FROM
    player_booked
WHERE
    play_schedule = 'NT'
GROUP BY play_half , play_schedule;




#######SUB QUERIES##########################
#q1
SELECT match_no,country_name
FROM match_details a, soccer_country b
WHERE a.team_id=b.country_id
AND a.match_no=1;


#q2
SELECT country_name as Team 
FROM soccer_country 
WHERE country_id in (
SELECT team_id 
FROM match_details 
WHERE play_stage='F' and win_lose='W');



#q3
SELECT 
    match_no, play_stage, goal_score, audience
FROM
    match_mast
WHERE
    audience = (SELECT 
            MAX(audience)
        FROM
            match_mast);

#q5
SELECT 
    match_no, play_stage, play_date, results, goal_score
FROM
    match_mast
WHERE
    match_no IN (SELECT 
            match_no
        FROM
            match_details
        WHERE
            team_id = (SELECT 
                    country_id
                FROM
                    soccer_country
                WHERE
                    country_name = 'PORTUGAL'
                        AND country_name = 'HUNGARY'));
                        
                        
##q6
SELECT 
    match_no, country_name, player_name, COUNT(match_no)
FROM
    goal_details a,
    soccer_country b,
    player_mast c
WHERE
    a.team_id = b.country_id
        AND a.player_id = c.player_id
GROUP BY match_no , country_name , player_name
ORDER BY match_no;


#q7
SELECT 
    country_name
FROM
    soccer_country
WHERE
    country_id IN (SELECT 
            team_id
        FROM
            goal_details
        WHERE
            match_no = (SELECT 
                    match_no
                FROM
                    match_mast
                WHERE
                    audence = (SELECT 
                            MAX(audence)
                        FROM
                            match_test)
                ORDER BY audence DESC));
                
                
#q8
SELECT 
    player_name
FROM
    player_mast
WHERE
    player_id = (SELECT 
            player_id
        FROM
            goal_details
        WHERE
            match_no = (SELECT 
                    match_no
                FROM
                    match_details
                WHERE
                    team_id = (SELECT 
                            country_id
                        FROM
                            soccer_country
                        WHERE
                            country_name = 'Hungary')
                        OR team_id = (SELECT 
                            country_id
                        FROM
                            soccer_country
                        WHERE
                            country_name = 'Portugal')
                GROUP BY match_no
                HAVING COUNT(DISTINCT team_id) = 2)
                AND team_id = (SELECT 
                    team_id
                FROM
                    soccer_country a,
                    soccer_team b
                WHERE
                    a.country_id = b.team_id
                        AND country_name = 'Portugal')
                AND goal_time = (SELECT 
                    MAX(goal_time)
                FROM
                    goal_details
                WHERE
                    match_no = (SELECT 
                            match_no
                        FROM
                            match_details
                        WHERE
                            team_id = (SELECT 
                                    country_id
                                FROM
                                    soccer_country
                                WHERE
                                    country_name = 'Hungary')
                                OR team_id = (SELECT 
                                    country_id
                                FROM
                                    soccer_country
                                WHERE
                                    country_name = 'Portugal')
                        GROUP BY match_no
                        HAVING COUNT(DISTINCT team_id) = 2)
                        AND team_id = (SELECT 
                            team_id
                        FROM
                            soccer_country a,
                            soccer_team b
                        WHERE
                            a.country_id = b.team_id
                                AND country_name = 'Portugal')));
                                
#q9
SELECT 
    MAX(stop2_sec)
FROM
    match_mast
WHERE
    stop2_sec <> (SELECT 
            MAX(stop_2sec)
        FROM
            match_mast);

#q10 
SELECT 
    country_name
FROM
    soccer_country
WHERE
    country_id in (SELECT 
            team_id
        FROM
            match_details
        WHERE
            match_no in (SELECT 
                    match_no
                FROM
                    match_mast
                WHERE
                    stop2_sec = (SELECT 
                            MAX(stop2_sec)
                        FROM
                            match_mast
                        WHERE
                            stop2_sec <> (SELECT 
                                    MAX(stop_2sec)
                                FROM
                                    match_mast))));
                                    
#q12
SELECT 
    country_name
FROM
    soccer_country
WHERE
    country_id IN (SELECT 
            team_id
        FROM
            match_details
        WHERE
            win_lose = 'L' AND play - stage = 'F');
            
#q13
SELECT 
    playing_club, COUNT(playing_club)
FROM
    player_mast
GROUP BY playing_club
HAVING COUNT(playing_club) = (SELECT 
        MAX(mycount)
    FROM
        (SELECT 
            playing_club, COUNT(playing_club) mycount
        FROM
            player_mast
        GROUP BY playing_club) pm);
        
#q14
SELECT 
    player_name, jersey_no
FROM
    player_mast
WHERE
    player_id = (SELECT 
            player_id
        FROM
            goal_details
        WHERE
            goal_type = 'P'
                AND match_no = (SELECT 
                    MIN(match_no)
                FROM
                    goal_details
                WHERE
                    goal_type = 'P' AND play_stage = 'G'));
                    
#q15
SELECT 
    a.player_name, a.jersey_no, d.country_name
FROM
    player_mast a,
    goal_details b,
    goal_details c,
    soccer_country d
WHERE
    a.player_id = b.player_id
        AND a.team_id = d.country_id
        AND a.player_id = (SELECT 
            b.player_id
        FROM
            goal_details b
        WHERE
            b.goal_type = 'P'
                AND b.match_no = (SELECT 
                    MIN(c.match_no)
                FROM
                    goal_details c
                WHERE
                    c.goal_type = 'P' AND c.play_stage = 'G'))
GROUP BY player_name , jersey_no , country_name;

















############################# joins ###########################

#q1
SELECT 
    venue_name AS name, city
FROM
    soccer_venue
        JOIN
    soccer_city ON soccer_venue.city_id = soccer_city.city_id
        JOIN
    match_mast d ON d.venue_id = soccer_venue.venue_id
        AND d.play_stage = 'F';
    
    
#q2
SELECT 
    m.match_no, c.country_name, m.goal_score
FROM
    match_details m
        JOIN
    soccer_country c ON c.country_id = m.team_id
WHERE
    decided_by = 'N'
ORDER BY match_no;


#q3
SELECT 
    p.player_name, COUNT(g.goal_id), c.country_name
FROM
    player_mast p
        JOIN
    goal_details g ON g.player_id = p.player_id
        JOIN
    soccer_country c ON c.country_id = p.team_id
GROUP BY player_name , country_name
ORDER BY COUNT(goal_id) DESC;

#q4
SELECT 
    p.player_name, COUNT(DISTINCT (g.player_id)), c.country_name
FROM
    goal_details g
        JOIN
    plater_mast p ON p.player_id = g.player_id
        JOIN
    soccer_country c ON g.team_id = c.country_name
GROUP BY player_name , country_name
ORDER BY COUNT(DISTINCT (g.player_id)) desc
LIMIT 1;


#q5
SELECT 
    p.player_name, g.jersey_no, c.country_id
FROM
    goal_details g
        JOIN
    player_mast p ON p.player_id = g.player_id
        JOIN
    soccer_country c ON c.country_id = g.team_id
WHERE
    play_stage = 'F';
    
    
#q6
SELECT 
    c.country_name
FROM
    soccer_country c
        JOIN
    soccer_city s ON s.country_id = c.country_id
        JOIN
    soccer_venue v ON v.city_id = s.city_id
GROUP BY country_name;


#q7

SELECT 
    a.player_name,
    a.jersey_no,
    b.country_name,
    c.goal_time,
    c.play_stage,
    c.goal_schedule,
    c.goal_half
FROM
    player_mast a
        JOIN
    soccer_country b ON a.team_id = b.country_id
        JOIN
    goal_details c ON c.player_id = a.player_id
WHERE
    goal_id = 1;

#q8

SELECT 
    r.refree_name, c.country_name
FROM
    refree_mast r
        JOIN
    match_mast m ON m.refree_id = r.refree_id
        JOIN
    soccer_country c ON c.country_id = r.country_id
        AND match_no = 1;
        
        
#q10

SELECT 
    a.ass_ref_name, c.country_name
FROM
    asst_referee_mast a
        JOIN
    soccer_country c ON c.country_id = a.country_id
        JOIN
    match_details m ON m.ass_ref = a.ass_ref_id
WHERE
    match_no = 1;

#q12

SELECT 
    v.venue_name, s.city
FROM
    soccer_venue v
        JOIN
    soccer_city s ON s.city_id = v.city_id
        JOIN
    match_mast m ON m.venue_id = v.venue_id
WHERE
    match_no = 1;
    
#q14
SELECT 
    v.venue_name, s.city, COUNT(m.match_no)
FROM
    soccer_venue v
        JOIN
    soccer_city s ON s.city_id = v.city_id
        JOIN
    match_mast m ON m.venue_id = v.venue_id
GROUP BY venue_name
ORDER BY venue_name;

#q15

SELECT 
    c.country_name AS Team, s.team_group, s.goal_for
FROM
    soccer_country c
        JOIN
    soccer_team s ON s.team_id = c.country_id
WHERE
    goal_for = 1;
    
    
#q17
SELECT 
    c.country_name, COUNT(s.booking_time) AS no_yellow_card
FROM
    soccer_country c
        JOIN
    player_booked s ON s.team_id = c.country_id
GROUP BY country_name , no_yellow_card
ORDER BY no_yellow_card desc;


#q19
SELECT 
    match_details.match_no, soccer_country.country_name
FROM
    match_mast
        JOIN
    match_details ON match_mast.match_no = match_details.match_no
        JOIN
    soccer_country ON match_details.team_id = soccer_country.country_id
WHERE
    stop1_sec = 0;
    
#q20
SELECT 
    c.country_name, s.team_group, s.match_played
FROM
    soccer_country c
        JOIN
    soccer_team s ON s.team_id = c.country_id
WHERE
    goal_againse = (SELECT 
            MAX(goal_against)
        FROM
            soccer_team)
GROUP BY country_name;

