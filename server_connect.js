var pg = require('pg');

module.exports = {
  connectionString: process.env.DATABASE_URL || 'postgres://postgres@localhost:5432/halcyon' //maybe different db name
}



// in server 

var client = new pg.Client(db.connectionString);
client.connect();

client.query('SQLSQLSQLSQLSQLSQLSQLSQLSQLSQLSQLSQL')