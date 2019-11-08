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
        failureRedirect: '/login?login=fail'
    }));
    app.get('/logout', passport.authMiddleware(), logout);

    app.get('/dashboard', passport.authMiddleware(), (req, res, next) => render(req, res, 'dashboard'));
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
    res.render(page, info);
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
