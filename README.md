The Open Source Shakespeare site (http://www.opensourceshakespeare.org/) is a collection of Shakespeare's complete works.  This projects adapts its data for powerful open-source relational databases, beginning with PostgreSQL.

This makes a much more interesting data set for sample or demo use than some boring imaginary online retailer.  In this dataset, people die!

If you wish to convert the data yourself (and possibly tinker with the process), run `./get_raw.sh`, then `schema_pg.sql`.

More likely, you just want the data, so create your database and run shakespeare.sql, like so:

    createdb shakespeare
    psql shakespeare < shakespeare.sql

To skip even fetching the repository:

    createdb shakespeare
    curl https://raw.githubusercontent.com/catherinedevlin/opensourceshakespeare/master/shakespeare.sql | psql shakespeare


Compare to https://github.com/edent/Open-Source-Shakespeare, a MySQL port of (I believe) the same data.

- Catherine Devlin (catherine.devlin@gmail.com)

 

