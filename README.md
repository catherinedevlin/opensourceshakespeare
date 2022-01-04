# opensourceshakespeare

The Open Source Shakespeare site (http://www.opensourceshakespeare.org/) is a collection of Shakespeare's complete works. This projects adapts its data for powerful open-source relational databases, beginning with PostgreSQL.

This makes a much more interesting data set for sample or demo use than some boring imaginary online retailer. In this dataset, people die!

## Installing the dataset

You don't need to clone this repository, just create the database and import the dump:

```
createdb sampledb
curl -L https://raw.githubusercontent.com/catherinedevlin/opensourceshakespeare/master/shakespeare.sql | psql sampledb
```

## Customising

If you wish to convert the data yourself (and possibly tinker with the process), run `./import`. We run three phases: `fetch`, `load` and `dump`; if you prefer you can run those phases directly but be sure to do it from the root folder.

More likely, you just want the data, so create your database and run shakespeare.sql, like so:

```
createdb sampledb
psql sampledb < shakespeare.sql
```

## Thanks

Compare to https://github.com/edent/Open-Source-Shakespeare, a MySQL port of (I believe) the same data.

- Catherine Devlin (catherine.devlin@gmail.com)
- Benjie Gillam (https://graphile.org/)
