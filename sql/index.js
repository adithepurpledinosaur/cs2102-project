const sql = {}

sql.query = {
    // auth
    userpass: 'SELECT * FROM Users WHERE uname = $1'
}

module.exports = sql
