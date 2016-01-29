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
