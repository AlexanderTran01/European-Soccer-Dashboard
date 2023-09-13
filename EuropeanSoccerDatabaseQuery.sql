-- Add new columns for joining later
-- Soccer seasons were decided to start in August and
-- end in July of the following year
ALTER TABLE Player_Attributes ADD Season VARCHAR(9);
UPDATE Player_Attributes 
SET Season = CASE  
                 WHEN Player_Attributes.date >= '2006-08-01 00:00:00' AND Player_Attributes.date <= '2007-07-31 00:00:00' THEN '2006/2007'
                 WHEN Player_Attributes.date >= '2007-08-01 00:00:00' AND Player_Attributes.date <= '2008-07-31 00:00:00' THEN '2007/2008'
                 WHEN Player_Attributes.date >= '2008-08-01 00:00:00' AND Player_Attributes.date <= '2009-07-31 00:00:00' THEN '2008/2009'
                 WHEN Player_Attributes.date >= '2009-08-01 00:00:00' AND Player_Attributes.date <= '2010-07-31 00:00:00' THEN '2009/2010'
                 WHEN Player_Attributes.date >= '2010-08-01 00:00:00' AND Player_Attributes.date <= '2011-07-31 00:00:00' THEN '2010/2011'
                 WHEN Player_Attributes.date >= '2011-08-01 00:00:00' AND Player_Attributes.date <= '2012-07-31 00:00:00' THEN '2011/2012'
                 WHEN Player_Attributes.date >= '2012-08-01 00:00:00' AND Player_Attributes.date <= '2013-07-31 00:00:00' THEN '2012/2013'
                 WHEN Player_Attributes.date >= '2013-08-01 00:00:00' AND Player_Attributes.date <= '2014-07-31 00:00:00' THEN '2013/2014'
                 WHEN Player_Attributes.date >= '2014-08-01 00:00:00' AND Player_Attributes.date <= '2015-07-31 00:00:00' THEN '2014/2015'
                 WHEN Player_Attributes.date >= '2015-08-01 00:00:00' AND Player_Attributes.date <= '2016-07-31 00:00:00' THEN '2015/2016'
             END;
ALTER TABLE Team_Attributes ADD Season VARCHAR(9);
UPDATE Team_Attributes 
SET Season = CASE  
                 WHEN Team_Attributes.date >= '2009-08-01 00:00:00' AND Team_Attributes.date <= '2010-07-31 00:00:00' THEN '2009/2010'
                 WHEN Team_Attributes.date >= '2010-08-01 00:00:00' AND Team_Attributes.date <= '2011-07-31 00:00:00' THEN '2010/2011'
                 WHEN Team_Attributes.date >= '2011-08-01 00:00:00' AND Team_Attributes.date <= '2012-07-31 00:00:00' THEN '2011/2012'
                 WHEN Team_Attributes.date >= '2012-08-01 00:00:00' AND Team_Attributes.date <= '2013-07-31 00:00:00' THEN '2012/2013'
                 WHEN Team_Attributes.date >= '2013-08-01 00:00:00' AND Team_Attributes.date <= '2014-07-31 00:00:00' THEN '2013/2014'
                 WHEN Team_Attributes.date >= '2014-08-01 00:00:00' AND Team_Attributes.date <= '2015-07-31 00:00:00' THEN '2014/2015'
                 WHEN Team_Attributes.date >= '2015-08-01 00:00:00' AND Team_Attributes.date <= '2016-07-31 00:00:00' THEN '2015/2016'
             END;

-----------------------------------------------------------------------------------------------------------------------------------------------

-- Player Query
SELECT
    Player.player_name AS Name,
    Player_Attributes.Season,
    league.name AS League,
    Team.team_long_name AS Team,
    -- Interested in birth month as research suggests the
    -- existence of the relative age effect in sports
    CASE
        WHEN birthday LIKE '____-01-%' THEN 'January'
        WHEN birthday LIKE '____-02-%' THEN 'February'
        WHEN birthday LIKE '____-03-%' THEN 'March'
        WHEN birthday LIKE '____-04-%' THEN 'April'
        WHEN birthday LIKE '____-05-%' THEN 'May'
        WHEN birthday LIKE '____-06-%' THEN 'June'
        WHEN birthday LIKE '____-07-%' THEN 'July'
        WHEN birthday LIKE '____-08-%' THEN 'August'
        WHEN birthday LIKE '____-09-%' THEN 'September'
        WHEN birthday LIKE '____-10-%' THEN 'October'
        WHEN birthday LIKE '____-11-%' THEN 'November'
        WHEN birthday LIKE '____-12-%' THEN 'December'
    END as "Birth Month",
    -- Obtain age using birthday and date of player record
    -- Casting as integers because dates are stored as text
    CASE
        WHEN CAST(SUBSTRING(birthday, 6, 2) AS INTEGER) > CAST(SUBSTRING(Player_Attributes.date, 6, 2) AS INTEGER) THEN
             CAST(SUBSTRING(Player_Attributes.date, 1, 4) AS INTEGER) - CAST(SUBSTRING(birthday, 1, 4) AS INTEGER) - 1
        ELSE CAST(SUBSTRING(Player_Attributes.date, 1, 4) AS INTEGER) - CAST(SUBSTRING(birthday, 1, 4) AS INTEGER)
    END as Age,
    height AS "Height(cm)",
    weight AS "Weight(lb)",
    overall_rating AS "Overall Rating",
    potential AS Potential,
    preferred_foot AS "Preferred Foot",
    attacking_work_rate AS "Attacking Work Rate",
    defensive_work_rate AS "Defensive Work Rate",
    crossing AS Crossing,
    finishing AS Finishing,
    heading_accuracy AS "Heading Accuracy",
    short_passing AS "Short Passing",
    volleys AS Volleys,
    dribbling AS Dribbling,
    curve AS Curve,
    free_kick_accuracy AS "Free Kick Accuracy",
    long_passing AS "Long Passing",
    ball_control AS "Ball Control",
    acceleration AS "Acceleration",
    sprint_speed AS "Sprint Speed",
    agility AS Agility,
    reactions AS Reactions,
    balance AS Balance,
    shot_power AS "Shot Power",
    jumping AS Jumping,
    stamina AS Stamina,
    strength AS Strength,
    long_shots AS "Long Shots",
    aggression AS Aggression,
    interceptions AS Interceptions,
    positioning AS Positioning,
    vision AS Vision,
    penalties AS Penalties,
    marking AS Marking,
    standing_tackle AS "Standing Tackle",
    sliding_tackle AS "Sliding Tackle",
    gk_diving AS "Goalkeeper Diving",
    gk_handling AS "Goalkeeper Handling",
    gk_kicking AS "Goalkeeper Kicking",
    gk_positioning AS "Goalkeeper Positioning",
    gk_reflexes AS "Goalkeeper Reflexes"
FROM
    Player
    INNER JOIN Player_Attributes
        ON Player.player_api_id = Player_Attributes.player_api_id
    -- Join on matches where player is present
    INNER JOIN Match
        ON Player.player_api_id IN 
            (Match.home_player_1, Match.home_player_2,
             Match.home_player_3, Match.home_player_4, 
             Match.home_player_5, Match.home_player_6, 
             Match.home_player_7, Match.home_player_8, 
             Match.home_player_9, Match.home_player_10, 
             Match.home_player_11, Match.away_player_1, 
             Match.away_player_2, Match.away_player_3, 
             Match.away_player_4, Match.away_player_5, 
             Match.away_player_6, Match.away_player_7, 
             Match.away_player_8, Match.away_player_9,
             Match.away_player_10, Match.away_player_11)
             AND Player_Attributes.Season = Match.season
    INNER JOIN League
        ON Match.league_id = League.id
    -- Identify team of player using match data
    INNER JOIN Team
        ON CASE
               WHEN Player.player_api_id IN (Match.home_player_1, Match.home_player_2,
                                             Match.home_player_3, Match.home_player_4, 
                                             Match.home_player_5, Match.home_player_6, 
                                             Match.home_player_7, Match.home_player_8, 
                                             Match.home_player_9, Match.home_player_10, 
                                             Match.home_player_11)
                    THEN Match.home_team_api_id
               WHEN Player.player_api_id IN (Match.away_player_1, Match.away_player_2,
                                             Match.away_player_3, Match.away_player_4, 
                                             Match.away_player_5, Match.away_player_6, 
                                             Match.away_player_7, Match.away_player_8, 
                                             Match.away_player_9, Match.away_player_10, 
                                             Match.away_player_11)
                    THEN Match.away_team_api_id
           END = Team.team_api_id
GROUP BY Player.player_api_id, Player_Attributes.Season, Match.season;

-----------------------------------------------------------------------------------------------------------------------------------------------

-- Team Query
SELECT
    Team.team_long_name AS Name,
    Team_Attributes.Season AS Season,
    league.name AS League,
    buildUpPlaySpeed AS "Build-up Play Speed",
    buildUpPlaySpeedClass AS "Build-up Play Speed Class",
    buildUpPlayDribbling AS "Build-up Play Dribbling",
    buildUpPlayDribblingClass AS "Build-up Play Dribbling Class",
    buildUpPlayPassing AS "Build-up Play Passing",
    buildUpPlayPassingClass AS "Build-up Passing Class",
    buildUpPlayPositioningClass AS "Build-up Play Positioning Class",
    chanceCreationPassing AS "Chance Creation Passing",
    chanceCreationPassingClass AS "Chance Creation Passing Class",
    chanceCreationCrossing AS "Chance Creation Crossing",
    chanceCreationCrossingClass AS "Chance Creation Crossing Class",
    chanceCreationShooting AS "Chance Creation Shooting",
    chanceCreationShootingClass AS "Chance Creation Shooting Class",
    chanceCreationPositioningClass AS "Chance Creation Positioning Class",
    defencePressure AS "Defence Pressure",
    defencePressureClass AS "Defence Pressure Class",
    defenceAggression AS "Defence Aggression",
    defenceAggressionClass AS "Defence Aggression Class",
    defenceTeamWidth AS "Defence Team Width",
    defenceTeamWidthClass AS "Defence Team Width Class",
    defenceDefenderLineClass AS "Defence Defender Line Class"
FROM
    Team
    INNER JOIN Team_Attributes
        ON Team.team_api_id = Team_Attributes.team_api_id
    -- Join on matches where player is present
    INNER JOIN Match
        ON Team.team_api_id IN 
            (home_team_api_id, away_team_api_id) AND Team_Attributes.Season = Match.season
    INNER JOIN League
        ON Match.league_id = League.id
GROUP BY Team.team_api_id, Team_Attributes.Season, Match.season;

