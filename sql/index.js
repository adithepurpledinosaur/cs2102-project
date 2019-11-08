const sql = {}

sql.query = {
    get_userinfo: 'SELECT * FROM Users WHERE uname = $1',

    create_user: 'INSERT INTO Users (uname, pwd, fname) VALUES ($1, $2, $3)',

    update_userinfo: 'UPDATE Users SET fname = $2, gender = $3, dob = $4, addr = $5 WHERE uname = $1',
}

module.exports = sql
