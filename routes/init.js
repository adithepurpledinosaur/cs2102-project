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
        failureRedirect: '/login?msg=invalid%20login'
    }));
    app.get('/logout', passport.authMiddleware(), logout);

    app.get('/dashboard', passport.authMiddleware(), (req, res, next) => render(req, res, 'dashboard'));
    app.get('/updateprofile', passport.authMiddleware(), show_updateprofile);
    app.post('/updateprofile', passport.authMiddleware(), do_updateprofile);

    app.get('/unlockpassenger', passport.authMiddleware(), unlock_passenger);
    app.get('/unlockdriver', passport.authMiddleware(), unlock_driver);
}

function unlock_driver(req, res, next) {
    pool.query(sql_query.query.create_driver, [req.user.username])
        .then(() => res.redirect("/dashboard?msg=driver%20features%20unlocked"))
        .catch(err => res.redirect("/dashboard?msg=already%20a%20driver"));
}
function unlock_passenger(req, res, next) {
    pool.query(sql_query.query.create_passenger, [req.user.username])
        .then(() => res.redirect("/dashboard?msg=passenger%20features%20unlocked"))
        .catch(err => res.redirect("/dashboard?msg=already%20a%20passenger"));
}

function do_updateprofile(req, res, next) {
    pool.query(sql_query.query.update_userinfo, [req.user.username, req.body.fullname, req.body.gender, req.body.dob, req.body.address])
        .then(() => res.redirect("/dashboard?msg=update%20success"))
        .catch(err => {
            console.log("Failed to update profile", err);
            res.redirect("/updateprofile?msg=invalid");
        });
}

function show_updateprofile(req, res, next) {
    pool.query(sql_query.query.get_userinfo, [req.user.username])
        .then(data => render(req, res, 'updateprofile', {row : data.rows[0]}));
}

// renders a page behind the authwall, with username accessible in ejs and possibly other stuff
function render(req, res, page, other) {
    var info = {
        page: page,
        username: req.user.username,
    };
    if(other) {
        for(var fld in other) {
            info[fld] = other[fld];
        }
    }
    return res.render(page, info);
}

function create_user(req, res, next) {
    const username = req.body.username;
    const passwordHash = bcrypt.hashSync(req.body.password, salt);
    const fullname = req.body.fullname;

    pool.query(sql_query.query.create_user, [username, passwordHash, fullname])
        .then(() => res.redirect("/login"))
        .catch(err => {
            console.log("Error adding user", err);
            res.redirect("/register?reg=fail");
        })
}


// renders a page that everyone can see, such pages require no authentication context
function public_page(pageName) {
    return (req, res, next) => res.render(pageName);
}

function logout(req, res, next) {
    req.session.destroy();
    req.logout();
    res.redirect('/');
}

module.exports = initRouter;
