# cs2102-project

## Starting a local instance

Make sure you have npm and postgres.

1. Start postgres instance
    * note: `DATABASE_URL` in `.env` is of the form
      `postgres://USER:PASSWORD@HOSTNAME:PORT/DATABASE`
2. import the schema (`\i sql/drop.sql` and `\i sql/create.sql`)
3. `npm install`
4. `npm start`

## Navigation

There is currently no navigability between pages. Append the following to your localhost URL to reach various pages:
- /about
- /forms
- /insert
- /loops
- /select
- /table
