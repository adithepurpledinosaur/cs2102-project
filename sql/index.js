const sql = {}

sql.query = {
    get_userinfo: 'SELECT * FROM Users WHERE uname = $1',

    create_user: 'INSERT INTO Users (uname, pwd, fname) VALUES ($1, $2, $3)',

    update_userinfo: 'UPDATE Users SET fname = $2, gender = $3, dob = $4, addr = $5 WHERE uname = $1',

    create_driver: 'INSERT INTO Driver (uname) VALUES ($1)',
    create_passenger: 'INSERT INTO Passenger (uname) VALUES ($1)',

    create_car: 'INSERT INTO Car VALUES ($1, $2, $3, $4, $5)',
    get_cars: 'SELECT * FROM Car WHERE uname = $1',
    get_car: 'SELECT * FROM Car WHERE uname = $1 AND plate_num = $2',
    update_car: 'UPDATE Car SET model = $3, num_seats = $4, edate = $5 WHERE uname = $1 AND plate_num = $2',
    delete_car: 'DELETE FROM Car WHERE uname = $1 AND plate_num = $2',

    create_ride: 'INSERT INTO Ride (uname, plate_num, pmax, origin, dest, pdatetime, dtime, min_cost) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)',
}

module.exports = sql
