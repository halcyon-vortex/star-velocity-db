-- Schema: halcyon

-- DROP SCHEMA halcyon;

CREATE SCHEMA halcyon
  AUTHORIZATION postgres;


-- Table: halcyon."Repos"

-- DROP TABLE halcyon."Repos";

CREATE TABLE halcyon."Repos"
(
  id integer NOT NULL,
  num_stars integer,
  language varchar(40),
  date_created date,
  CONSTRAINT pk_repo PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE halcyon."Repos"
  OWNER TO postgres;

-- Index: halcyon.fki_languages

-- DROP INDEX halcyon.fki_languages;

CREATE INDEX fki_languages
  ON halcyon."Repos"
  USING btree
  (language);



-- Table: halcyon."Daily_Stars"

-- DROP TABLE halcyon."Daily_Stars";

CREATE TABLE halcyon."Daily_Stars"
(
  date date NOT NULL,
  stars integer,
  repo_id integer NOT NULL,
  CONSTRAINT pk_repo_and_date PRIMARY KEY (repo_id, date)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE halcyon."Daily_Stars"
  OWNER TO postgres;



-- Table: halcyon."Velocities"

-- DROP TABLE halcyon."Velocities";

CREATE TABLE halcyon."Velocities"
(
  repo_id integer NOT NULL,
  daily_velocity real,
  weekly_velocity real,
  monthly_velocity real,
  CONSTRAINT pk_vel PRIMARY KEY (repo_id),
  CONSTRAINT fk_vel_to_repo FOREIGN KEY (repo_id)
      REFERENCES halcyon."Repos" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE halcyon."Velocities"
  OWNER TO postgres;




-- Insert Statements
-- *****************

-- Insert Repository information

Insert into halcyon."Repos" (id, num_stars, language)
Values (50212606, 375, 'Cocoascript')

Insert into halcyon."Repos" (id, num_stars, language) -- 
Values (47931294, 346, 'Python')

-- Or, including date_created
Insert into halcyon."Repos" (id, num_stars, language, date_created)
Values (7379964, 4762, 'CSS', '12/30/2012')


-- Insert into daily watch increase table

Insert into halcyon."Daily_Stars" (date, stars, repo_id)
Values ('1/28/2016',162, 50212606)

Insert into halcyon."Daily_Stars" (date, stars, repo_id)
Values ('1/28/2016',160, 47931294)

Insert into halcyon."Daily_Stars" (date, stars, repo_id)
Values ('1/28/2016',159, 7379964)


-- Select Statements

Select * from halcyon."Daily_Stars" Where date > (CURRENT_DATE - 7)


-- Velocity computation

select 
  ((endVisits + startVisits)/40) average, 
  (endVisits > startVisits) increasing, 
  ((endVisits - startVisits)/(startVisits) * 100) percentChange 
from 
  (select sum(visit_count) startVisits 
    from store_visit 
    where 
      visit_date > current_date - 40 
      and visit_date <= current_date - 20) startRange,
  (select sum(visit_count) endVisits 
    from store_visit 
    where  
      visit_date > current_date - 20) endRange;

-- becomes ->
-- for daily velocity
select 
  endRange.repo_id,
  ((endStars + startStars)/2) average, 
  (endStars > startStars) increasing, 
  ((endStars - startStars)::real /(startStars) * 100) percentChange 
from 
  (select repo_id, sum(stars) startStars
    from halcyon."Daily_Stars"
    where 
      date = current_date - 2
    group by repo_id) startRange Join
  (select repo_id, sum(stars) endStars 
    from halcyon."Daily_Stars" 
    where  
      date = current_date - 1
    group by repo_id) endRange 
    On startRange.repo_id = endRange.repo_id

-- for weekly velocity
select 
  endRange.repo_id,
  ((endStars + startStars)/14) average, 
  (endStars > startStars) increasing, 
  ((endStars - startStars)::real /(startStars) * 100) percentChange 
from 
  (select repo_id, sum(stars) startStars
    from halcyon."Daily_Stars"
    where 
      date > current_date - 14 - 1
      and date <= current_date - 7 - 1 -- since only have snapshot up to 'yesterday'
    group by repo_id) startRange Join
  (select repo_id, sum(stars) endStars 
    from halcyon."Daily_Stars" 
    where  
      date >= current_date - 7
    group by repo_id) endRange 
    On startRange.repo_id = endRange.repo_id


-- could do queries for any window of time


-- get all info for a specific repo
WITH specificRepo AS (select * from halcyon."Daily_Stars"
    where repo_id = 7379964
    and date >= current_date - 7
      and date <= current_date - 1) 

select 
  ((endStars + startStars)/2) average, 
  (endStars > startStars) increasing, 
  ((endStars - startStars)::real /(startStars) * 100) percentChange 
from 
  
  (select sum(stars) startStars
    from specificRepo
    where 
      date = current_date - 2) startRange,
  (select sum(stars) endStars 
    from specificRepo 
    where  
      date = current_date - 1) endRange 


-- return time series of percent increase
WITH specificRepo AS (select * from halcyon."Daily_Stars"
    where repo_id = 7379964
    and date >= current_date - 7
      and date <= current_date - 1) 


select 
  ((oneBack - twoBack)::real /(twoBack) * 100) yesterdayPercentChange,
  ((twoBack - threeBack)::real /(threeBack) * 100) twoPrevPercentChange 
from 
  
  (select sum(stars) threeBack
    from specificRepo
    where 
      date = current_date - 3) three,
  (select sum(stars) twoBack
    from specificRepo 
    where  
      date = current_date - 2) two,
  (select sum(stars) oneBack
    from specificRepo 
    where  
      date = current_date - 1) one
    