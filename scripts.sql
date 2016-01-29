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

Select * from halcyon."Velocities" 