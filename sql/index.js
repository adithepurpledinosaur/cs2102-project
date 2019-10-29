const sql = {}

sql.query = {
    // auth
    userpass: 'SELECT * FROM Users WHERE uname = $1',

    create_user: 'INSERT INTO Users (uname, pwd, fname) VALUES ($1, $2, $3)',
}

module.exports = sql
