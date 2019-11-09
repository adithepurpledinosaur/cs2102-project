# cs2102-project

## Setting up

Make sure you have npm and postgres.

1. Start postgres instance
    * note: `DATABASE_URL` in `.env` is of the form
      `postgres://USER:PASSWORD@HOSTNAME:PORT/DATABASE`
2. import the schema in this order
    * `drop.sql` if necessary,
    * `create.sql`,
    * `triggers.sql` and,
    * `mocks.sql` if desired
3. `npm install`
4. `npm start`
