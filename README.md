# star-velocity-db



![schema image][schema_image]


### Daily_stars

Table stores the daily log data from the Github Archive [link] 
Each row stores the number of stars (watches) a certain repository gets in a given day. 


### Repos

Each row stores the repository id from Github, the total number of stars that repo currently has, the primary language it uses, and the date the repository was created.


### Languages

A table for storing every language used on Github.


## Queries 

```sql
SELECT blah FROM table WHERE foo

```

## Architecture

#### Log update
Log comes in hourly,
accumulate log data in worker

[schema_image]: https://raw.githubusercontent.com/halcyon-vortex/star-velocity-db/master/assets/schema.png "Schema for logging repository attention"