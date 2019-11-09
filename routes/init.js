const sql_query = require('../sql');
const express = require('express');
const passport = require('passport');
const bcrypt = require('bcrypt')
const router = express.Router();

// SQL Connection
const { Pool } = require('pg');
const pool = new Pool({
    connectionString: process.env.DATABASE_URL
});
const salt  = bcrypt.genSaltSync(10);

function initRouter(app) {
    app.get('/', passport.antiMiddleware(), public_page('index'));

    app.get('/register', passport.antiMiddleware(), public_page('register'));
    app.post('/register', passport.antiMiddleware(), create_user);

    app.get('/login', passport.antiMiddleware(), public_page('login'));
    app.post('/login', passport.authenticate('local', {
        successRedirect: '/dashboard',
        failureRedirect: withMsg("/login", "invalid login"),
    }));
    app.get('/logout', passport.authMiddleware(), logout);

    app.get('/dashboard', passport.authMiddleware(), (req, res, next) => render(req, res, 'dashboard'));
    app.get('/updateprofile', passport.authMiddleware(), show_updateprofile);
    app.post('/updateprofile', passport.authMiddleware(), do_updateprofile);

    //app.get('/unlockpassenger', passport.authMiddleware(), unlock_passenger);
    app.get('/unlockdriver', passport.authMiddleware(), unlock_driver);

    app.get('/mycars', passport.authMiddleware(), show_cars);
    app.post('/addcar', passport.authMiddleware(), add_car);
    // these car-related API take in the plate number via query string which is ensured to exist via the appropriately-named middleware
    const ensure_platenumber = ensure_query_has(['plate_num'], withMsg("/mycars", "you need to specify a car"));
    app.get('/editcar', passport.authMiddleware(), ensure_platenumber, show_editcar);
    app.post('/editcar', passport.authMiddleware(), ensure_platenumber, do_editcar);
    app.get('/deletecar', passport.authMiddleware(), ensure_platenumber, do_deletecar);

    app.get('/addride', passport.authMiddleware(), ensure_platenumber, show_addride);
    app.post('/addride', passport.authMiddleware(), ensure_platenumber, do_addride);

    app.get('/rides', passport.authMiddleware(), get_rides);
    app.get('/rideadmin', passport.authMiddleware(), show_rideadmin);
    app.get('/deleteride', passport.authMiddleware(),
        ensure_query_has(['plate_num', 'origin', 'dest', 'pdatetime'], withMsg("/rideadmin","")),
        delete_ride);

    app.get('/rewards', passport.authMiddleware(), show_rewards);
    app.get('/benefits', passport.authMiddleware(), show_benefits);

}

const show_rewards = (req, res, next) =>
    pool.query(sql_query.query.get_drivers_rides, [req.user.username])
        .then(data => render(req, res, 'rewards', {rows: data.rows}));

const show_benefits = (req, res, next) =>
    pool.query(sql_query.query.get_drivers_rides, [req.user.username])
        .then(data => render(req, res, 'benefits', {rows: data.rows}));

const delete_ride = (req, res, next) =>
    pool.query(sql_query.query.delete_ride, [req.user.username, req.query.plate_num, req.query.origin, req.query.dest, req.query.pdatetime])
        .then(() => res.redirect(withMsg("/rideadmin", "ride deleted")))
        .catch(() => res.redirect(withMsg("/rideadmin", "invalid delete attempt")))

const show_rideadmin = (req, res, next) =>
    pool.query(sql_query.query.get_drivers_rides, [req.user.username])
        .then(data => render(req, res, 'rideadmin', {rows: data.rows}));

const get_rides = (req, res, next) =>
    pool.query(sql_query.query.get_rides, [req.user.username, `%${req.query['search'] || ''}%`])
        .then(data => render(req, res, 'rides', {rows: data.rows}));

function do_addride(req, res, next) {
    pool.query(sql_query.query.create_ride, [req.user.username, req.query.plate_num, req.body.pmax, req.body.origin, req.body.dest, req.body.date + ' ' + req.body.time, req.body.dtime || null, req.body.min_cost])
        .then(data => {
            if (data.rowCount != 1) {
                throw new Error("not inserted");
            }
            res.redirect(withMsg("/rideadmin", "ride added"))
        })
        .catch(() => res.redirect(withMsg("/addride", "invalid ride information given") + "&plate_num=" + encodeURI(req.query.plate_num)));
}
function show_addride(req, res, next) {
    pool.query(sql_query.query.get_car, [req.user.username, req.query.plate_num])
        .then(data => {
            if (data.rows.length == 0) {
                throw new Error("You don't own this car");
            }
            render(req, res, 'addride', {row: data.rows[0]});
        })
        .catch(() => res.redirect(withMsg("/mycars", "cannot use unregistered car")));
}
function do_deletecar(req, res, next) {
    pool.query(sql_query.query.delete_car, [req.user.username, req.query.plate_num])
        .then(() => res.redirect(withMsg("/mycars", "car (and all rides associated) are deleted")))
        .catch(() => res.redirect(withMsg("/mycars", "nothing to delete it appears like")));
}
function ensure_query_has(keys, redirto) {
    return (req, res, next) =>
        keys.every(k => req.query[k]) ? next () : res.redirect(redirto);
}
function do_editcar(req, res, next) {
    pool.query(sql_query.query.update_car, [req.user.username, req.query.plate_num, req.body.model, req.body.num_seats, req.body.edate])
        .then(() => res.redirect("/mycars"))
        .catch(() => res.redirect(withMsg("/mycars", "failed to edit car, please ensure you have activated your driver features and inputs are valid")));
}
function show_editcar(req, res, next) {
    pool.query(sql_query.query.get_car, [req.user.username, req.query.plate_num])
        .then(data => {
            if (data.rows.length == 0) {
                throw new Error("You don't own this car");
            }
            render(req, res, 'editcar', {row: data.rows[0]});
        })
        .catch(() => res.redirect(withMsg("/mycars", "cannot use unregistered car")));
}

function show_cars(req, res, next) {
    pool.query(sql_query.query.get_cars, [req.user.username])
        .then(data => render(req, res, 'mycars', {rows: data.rows}));
}

function add_car(req, res, next) {
    pool.query(sql_query.query.create_car,
        [req.user.username, req.body.plate_num, req.body.num_seats, req.body.model, req.body.edate])
        .then(() => res.redirect(withMsg("/mycars", "car added")))
        .catch(err => res.redirect(withMsg("/mycars", "failed to add car, please ensure you have activated your driver features and inputs are valid")));
}

function unlock_driver(req, res, next) {
    pool.query(sql_query.query.create_driver, [req.user.username])
        .then(() => res.redirect(withMsg("/dashboard", "driver features unlocked")))
        .catch(err => res.redirect(withMsg("/dashboard", "already a driver")));
}
// done by a trigger
function unlock_passenger(req, res, next) {
    pool.query(sql_query.query.create_passenger, [req.user.username])
        .then(() => res.redirect(withMsg("/dashboard", "passenger features unlocked")))
        .catch(err => res.redirect(withMsg("/dashboard", "already a passenger")));
}

function do_updateprofile(req, res, next) {
    pool.query(sql_query.query.update_userinfo, [req.user.username, req.body.fullname, req.body.gender, req.body.dob, req.body.address])
        .then(() => res.redirect(withMsg("/dashboard", "update success")))
        .catch(err => {
            console.log("Failed to update profile", err);
            res.redirect(withMsg("/updateprofile", "invalid input (if you're younger than 16 you shouldn't be here"))
        });
}

function show_updateprofile(req, res, next) {
    pool.query(sql_query.query.get_userinfo, [req.user.username])
        .then(data => render(req, res, 'updateprofile', {row : data.rows[0]}));
}

function create_user(req, res, next) {
    const username = req.body.username;
    const passwordHash = bcrypt.hashSync(req.body.password, salt);
    const fullname = req.body.fullname;

    pool.query(sql_query.query.create_user, [username, passwordHash, fullname])
        .then(() => res.redirect("/login"))
        .catch(err => {
            console.log("Error adding user", err);
            res.redirect(withMsg("/register", "username taken"));
        })
}

// renders a page behind the authwall, with username accessible in ejs and possibly other stuff
function render(req, res, page, other) {
    var info = {
        page: page,
        username: req.user.username,
    };
    if (other) {
        for(var fld in other) {
            info[fld] = other[fld];
        }
    }
    return render_wrap(req, res, page, info);
}

// renders a page that everyone can see, such pages require no authentication context
function public_page(pageName) {
    return (req, res, next) => render_wrap(req, res, pageName, {});
}

function logout(req, res, next) {
    req.session.destroy();
    req.logout();
    res.redirect('/');
}

// bolt on feedback using query strings (which is prone to xss and other fun stuff)
function render_wrap(req, res, page, info) {
    info['msg'] = req.query['msg'];
    return res.render(page, info);
}

function withMsg(endpoint, msg) {
    return endpoint + "?msg=" + encodeURI(msg);
}

module.exports = initRouter;
